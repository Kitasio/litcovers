defmodule CoverGen.Helpers do
  # alias Litcovers.Character

  def create_prompt(idea_prompt, style_prompt, _gender, :portrait) do
    "#{random_portrait()}, #{idea_prompt}, #{style_prompt}"
  end

  def create_prompt(idea_prompt, style_prompt, _gender, :setting) do
    "#{idea_prompt}, #{style_prompt}"
  end

  defp random_portrait do
    ["A cjw side profile portrait", "A cjw close up portrait", "a cjw symmetrical face portrait"]
    |> Enum.random()
  end
end
