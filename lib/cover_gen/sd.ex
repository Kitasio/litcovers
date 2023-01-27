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
  def diffuse(_prompt, _amount, nil),
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

  def process_testing do
    {:ok, pid} =
      Task.start_link(fn ->
        :timer.seconds(5) |> Process.sleep()
        IO.puts("5 seconds passed")
      end)

    {:ok, killer_pid} =
      Task.start_link(fn ->
        :timer.seconds(6) |> Process.sleep()
        Process.exit(pid, :kill)
      end)

    {pid, killer_pid}
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
            IO.inspect(res)
            {:error, res}
        end

      error ->
        {:error, error}
    end
  end
end
