defmodule CoverGen.Create do
  alias Litcovers.Repo
  alias Litcovers.Media
  alias Litcovers.Media.Image

  alias CoverGen.OAI
  alias CoverGen.SD
  # alias CoverGen.Overlay
  alias CoverGen.Helpers
  alias CoverGen.Spaces

  def new(%Image{} = image) do
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
    end
  end

  # def more(%Image{} = image) do
  # if image.ideas == [] do
  #   {:ok, ideas_list} =
  #     OAI.description_to_cover_idea(
  #       image.description,
  #       image.prompt.type,
  #       image.character_gender,
  #       System.get_env("OAI_TOKEN")
  #     )
  #
  #   save_ideas(ideas_list, image)
  # end
  #
  # %{idea: idea} = image.ideas |> Enum.random()
  #
  # with prompt <-
  #        Helpers.create_prompt(
  #          idea,
  #          image.prompt.style_prompt,
  #          image.character_gender,
  #          image.prompt.type
  #        ),
  #      {:ok, sd_res} <-
  #        SD.diffuse(
  #          prompt,
  #          image.character_gender,
  #          image.prompt.type,
  #          1,
  #          System.get_env("REPLICATE_TOKEN")
  #        ) do
  #   %{"output" => image_list} = sd_res
  #
  #   case Spaces.save_to_spaces(image_list) do
  #     {:error, reason} ->
  #       IO.inspect(reason)
  #
  #     img_urls ->
  #       for url <- img_urls do
  #         image_params = %{"cover_url" => url, "prompt" => prompt}
  #         {:ok, cover} = Media.create_cover(image, image_params)
  #
  #         urls =
  #           Overlay.put_text_on_images(
  #             image.title |> Overlay.get_line_length_list(),
  #             cover.cover_url,
  #             image.author,
  #             image.title,
  #             image.prompt.realm |> to_string()
  #           )
  #
  #         for url <- urls do
  #           Media.create_overlay(cover, %{url: url})
  #         end
  #       end
  #
  #       image = Media.get_request_and_covers!(image.id)
  #
  #       broadcast(image, :gen_complete)
  #   end
  # end
  # end

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
