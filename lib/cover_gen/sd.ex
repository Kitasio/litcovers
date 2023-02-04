defmodule CoverGen.SD do
  alias CoverGen.SD
  alias HTTPoison.Response
  require Elixir.Logger

  @derive Jason.Encoder
  defstruct version: "9936c2001faa2194a261c01381f90e65261879985476014a0a37a334593a05eb",
            input: %{
              prompt: "multicolor hyperspace",
              width: 512,
              height: 768,
              num_outputs: 1
            }

  def get_sd_params(prompt, gender, type, amount, width, height) do
    %SD{
      version: get_version(type, gender),
      input: %{
        prompt: prompt,
        width: width,
        height: height,
        num_outputs: amount
      }
    }
  end

  # Returns a list of image links
  def diffuse(_sd_params, nil),
    do: raise("REPLICATE_TOKEN was not set\nVisit https://replicate.com/account to get it")

  def diffuse(sd_params, replicate_token) do
    body = Jason.encode!(sd_params)
    headers = [Authorization: "Token #{replicate_token}", "Content-Type": "application/json"]
    options = [timeout: 50_000, recv_timeout: 165_000]

    endpoint = "https://api.replicate.com/v1/predictions"

    Logger.info("Generating images with SD")

    {:ok, %Response{body: res_body}} = HTTPoison.post(endpoint, body, headers, options)
    %{"urls" => %{"get" => generation_url}} = Jason.decode!(res_body)
    check_for_output(generation_url, headers, options)
  end

  defp get_version(_type, "couple") do
    "139abcbafe063bd8569836fbc97913ff9d0db1308a93e6f9a2a4d7d721008b9c"
  end

  defp get_version(type, _gender) do
    case type do
      :setting ->
        "8abccf52e7cba9f6e82317253f4a3549082e966db5584e92c808ece132037776"

      :portrait ->
        "139abcbafe063bd8569836fbc97913ff9d0db1308a93e6f9a2a4d7d721008b9c"

      _ ->
        "139abcbafe063bd8569836fbc97913ff9d0db1308a93e6f9a2a4d7d721008b9c"
    end
  end

  defp check_for_output(generation_url, headers, options) do
    %Response{body: res} = HTTPoison.get!(generation_url, headers, options)
    res = res |> Jason.decode!()

    case res["error"] do
      nil ->
        case res["status"] do
          "starting" ->
            Logger.debug("Starting")
            :timer.seconds(2) |> Process.sleep()
            check_for_output(generation_url, headers, options)

          "processing" ->
            Logger.debug("Processing")
            :timer.seconds(1) |> Process.sleep()
            check_for_output(generation_url, headers, options)

          "succeeded" ->
            Logger.debug("Succeeded")
            {:ok, res}

          "failed" ->
            Logger.debug("Failed")
            {:error, :sd_failed, "Generation failed, try again"}
        end

      error ->
        {:error, :sd_failed, error}
    end
  end

  def dummy_diffuse do
    params = %{
      version: "139abcbafe063bd8569836fbc97913ff9d0db1308a93e6f9a2a4d7d721008b9c",
      input: %{
        prompt: "a cjw cat",
        width: 128,
        height: 128,
        num_outputs: 1,
        num_inference_steps: 1
      }
    }

    replicate_token = System.get_env("REPLICATE_TOKEN")

    body = Jason.encode!(params)
    headers = [Authorization: "Token #{replicate_token}", "Content-Type": "application/json"]
    options = [timeout: 50_000, recv_timeout: 165_000]

    endpoint = "https://api.replicate.com/v1/predictions"
    HTTPoison.post(endpoint, body, headers, options)
  end
end
