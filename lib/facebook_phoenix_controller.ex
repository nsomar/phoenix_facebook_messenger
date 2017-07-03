defmodule FacebookMessenger.Phoenix.Controller do
  @moduledoc """
  Module that defines the basic methods required to be a facebook messanger bot

  This module defines methods to handle facebook messanger authentication challenge
  and facebook webhook callbacks
  """

  defmacro __using__(x) do
    quote do
      require Logger
      use Phoenix.Controller

      @behaviour FacebookMessenger.Callback

      @callback_handler __MODULE__

      ## overridable

      def get_verify_token(conn) do
        Application.get_env(:facebook_messenger, :challenge_verification_token)
      end
      def challenge_successful(_conn, _params), do: :ok
      def challenge_failed(_conn, _params), do: :ok

      defoverridable [get_verify_token: 1, challenge_successful: 2, challenge_failed: 2]

      ## actions

      def challenge(conn, params) do
        case check_challenge(conn, params) do
          {:ok, challenge} ->
            challenge_successful(conn, params)
            conn
            |> resp(200, challenge)
            |> responder().respond()
          :error ->
            challenge_failed(conn, params)
            invalid_token(conn, params)
        end
      end

      def webhook(conn, params) do
        params
        |> FacebookMessenger.parse_message()
        |> inform_and_reply(conn)
      end

      ## private

      defp inform_and_reply({:ok, message}, conn) do
        status =
          case @callback_handler.message_received(conn, message) do
            :error -> 500
            _ -> 200
          end
        conn
        |> resp(status, "")
        |> responder().respond()
      end

      defp inform_and_reply(:error, conn) do
        conn
        |> resp(500, "")
        |> responder().respond()
      end

      defp invalid_token(conn, params) do
        Logger.error("Bad request #{inspect(conn)} with params #{inspect(params)}")
        conn
        |> resp(500, "")
        |> responder().respond()
      end

      defp responder do
        Application.get_env(:facebook_messenger, :responder) || FacebookMessenger.Responder
      end

      defp check_challenge(conn, %{"hub.mode" => "subscribe", "hub.verify_token" => token, "hub.challenge" => challenge} = params) do

        case token == get_verify_token(conn) do
          true -> {:ok, challenge}
          false -> :error
        end
      end
      defp check_challenge(_conn, params), do: :error


    end
  end
end
