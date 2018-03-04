require IEx;

defmodule Router do
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

defmodule Webserver do
  use Router
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
