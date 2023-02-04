defmodule CoverGen.Helpers do
  alias Litcovers.Media
  require Elixir.Logger

  def create_prompt(idea_prompt, style_prompt, gender, :portrait) do
    "#{random_portrait(gender)}, #{idea_prompt}, #{style_prompt}"
  end

  def create_prompt(idea_prompt, style_prompt, _gender, :setting) do
    "#{idea_prompt}, #{style_prompt}"
  end

  defp random_portrait(gender) do
    [
      "A cjw close up portrait of a #{gender_to_naming(gender)}",
      "A cjw symmetrical face portrait of a #{gender_to_naming(gender)}"
    ]
    |> Enum.random()
  end

  defp gender_to_naming(gender) do
    case gender do
      "male" ->
        "man"

      "female" ->
        "woman"
    end
  end

  def delete_image_after(image_id, time) do
    # deletes image after one day
    Task.start(fn ->
      # waits one day
      time |> Process.sleep()
      image = Media.get_image!(image_id)

      unless image.unlocked do
        Logger.info("deleting image, id: #{image.id}")
        Media.delete_image(image)
        CoverGen.Spaces.delete_object(image.url)
      end
    end)
  end
end
