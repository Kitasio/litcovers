defmodule CoverGen.Create do
  alias Litcovers.Repo
  alias Litcovers.Media
  alias Litcovers.Media.Image

  alias CoverGen.OAI
  alias CoverGen.SD
  alias CoverGen.Helpers
  alias CoverGen.Spaces

  require Elixir.Logger

  def new(%Image{} = image, root_pid) do
    with {:ok, ideas_list} <-
           OAI.description_to_cover_idea(
             image.description,
             image.prompt.type,
             image.character_gender,
             System.get_env("OAI_TOKEN")
           ),
         _ <- save_ideas(ideas_list, image),
         prompt <-
           Helpers.create_prompt(
             ideas_list |> Enum.random(),
             image.prompt.style_prompt,
             image.character_gender,
             image.prompt.type
           ),
         sd_params <-
           SD.get_sd_params(
             prompt,
             image.character_gender,
             image.prompt.type,
             1,
             image.width,
             image.height
           ),
         {:ok, sd_res} <-
           SD.diffuse(
             sd_params,
             System.get_env("REPLICATE_TOKEN")
           ) do
      %{"output" => image_list} = sd_res

      case Spaces.save_to_spaces(image_list) do
        {:error, reason} ->
          IO.inspect(reason)

        img_urls ->
          for url <- img_urls do
            image_params = %{url: url, completed: true}
            {:ok, image} = ai_update_image(image, image_params)
            broadcast(image.user_id, image.id, :gen_complete)
          end
      end
    else
      {:error, :oai_failed} ->
        send(root_pid, {:error, :oai_failed})

      {:error, :sd_failed, error} ->
        send(root_pid, {:error, :sd_failed, error})
    end
  end

  def new_async(%Image{} = image, root_pid) do
    # Check if genserver is running
    if GenServer.whereis(Litcovers.DrippingMachine) != nil do
      send(Litcovers.DrippingMachine, {:drip, :user})
    end

    Task.start_link(fn ->
      caller = self()

      {:ok, pid} =
        Task.start_link(fn ->
          new(image, root_pid)
          send(caller, {:ok, :finished})
        end)

      get_result_or_kill(pid, root_pid, image.id)
    end)
  end

  defp get_result_or_kill(pid, root_pid, image_id) do
    receive do
      {:ok, :finished} ->
        Logger.info("Finished generating, image id: #{image_id}")
    after
      :timer.minutes(7) ->
        Process.exit(pid, :kill)
        Logger.error("Timeout generating image, id: #{image_id}")
        send(root_pid, {:error, :gen_timeout})
    end
  end

  def ai_update_image(%Image{} = image, attrs) do
    image
    |> Image.ai_changeset(attrs)
    |> Repo.update()
  end

  def save_ideas(ideas_list, image) do
    for idea <- ideas_list do
      idea = String.trim(idea)
      Media.create_idea(image, %{idea: idea})
    end
  end

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(Litcovers.PubSub, "generations:#{user_id}")
  end

  defp broadcast(user_id, image_id, event) do
    Phoenix.PubSub.broadcast(Litcovers.PubSub, "generations:#{user_id}", {event, image_id})
    {:ok, image_id}
  end
end
