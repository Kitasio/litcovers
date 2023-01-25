defmodule LitcoversWeb.PageController do
  use LitcoversWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: "/images?test_param=hello_world&another=bye_world")
  end

  def dummy(_conn, _params), do: nil
end
