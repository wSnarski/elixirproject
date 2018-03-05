require IEx;

defmodule Example do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Example.TestPlug, [], port: 4000)
    ]

    Logger.info("Started application")

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule Example.Router do
  defmacro __using__(_opts) do
    quote do
      def init(options) do
        options
      end
      def call(conn, _opts) do
        route(conn.method, conn.path_info, conn)
      end
    end
  end
end

defmodule Example.TestPlug do
  import Plug.Conn
  use Example.Router
  @moduledoc """
  Documentation for Webserver.
  """

  @doc """
  ## Examples
  """
  def route("GET", ["hello"], conn) do
    conn |> Plug.Conn.send_resp(200, "Hello, world!")
  end

  def route("GET", ["users", user_id], conn) do
    conn |> Plug.Conn.send_resp(200, "You requested user #{user_id}")
  end

  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "Couldn't find that page, sorry!")
  end
end
