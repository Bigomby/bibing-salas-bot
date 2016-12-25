defmodule BibingSalasBot.SalasAPIClient do
  @moduledoc """
  This modules handle the calls to the Salas API
  """

  @user_agent [{"User-agent", "Bibing Salas Bot"}]
  @salas_api_url Application.get_env(:bibing_salas_bot, :salas_api_url)

  import Poison.Parser, only: [parse!: 1]
  import Poison.Encoder, only: [encode: 2]

  def get_salas do
    "#{@salas_api_url}/salas"
    |> HTTPoison.get
    |> handle_response
  end

  def get_sala(sala) do
    "#{@salas_api_url}/salas/#{sala}"
    |> HTTPoison.get
    |> handle_response
  end

  def get_reserva(date, username, password) do
    ~s(#{@salas_api_url}/reservas/#{date}?username=#{username}\
&password=#{password})
    |> HTTPoison.get
    |> handle_response
  end

  def create_reserva(form) when is_map(form) do
    "#{@salas_api_url}/reservas"
    |> HTTPoison.post(encode(
      %{
        name: form["name"],
        uvus: form["uvus"],
        email: form["email"],
        date: form["date"],
        room: form["room"],
        turn: form["turn"],
        username: form["username"],
        password: form["password"]
      }, []), %{"Content-type" => "application/json"})
    |> handle_response
  end

  def delete_reserva(id) do
    "#{@salas_api_url}/reservas/#{id}"
    |> HTTPoison.delete
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, parse!(body)}
  end

  defp handle_response({_, %{status_code: _, body: body}}) do
    {:error, parse!(body)}
  end
end
