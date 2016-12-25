defmodule SalasAPIClientTest do
  use ExUnit.Case
  import Mock

  setup do
    fixtures =
      [
        reserva: ~s(
          {
            "date": "1-1-2000",
            "reservation": "41530",
            "room": 1,
            "time": "8:00 - 10:30",
            "turn": 4
          }
        ),
        created: ~s(
          {
            "room": 1,
            "turn": 3,
            "date": "1-1-2000",
            "time": "8:00 - 10:30",
            "reservation": "41530"
          }
        ),
        deleted: ~s(
          {"reservation": "41530"}
        ),
        sala: ~s(
          {
            "id": 1,
            "turns": [
              {
                "id": 1,
                "time": "8:00 - 10:30",
                "available": false
              }
            ]
          }
        ),
        salas: ~s(
          [
            {
              "id": 1,
              "turns": [
                {},
                {},
                {},
                {
                  "id": 4,
                  "time": "14:30 - 16:30",
                  "available": true
                }
              ]
            },
            {
              "id": 4,
              "turns": [
                {
                  "id": 1,
                  "time": "8:00 - 10:30",
                  "available": true
                }
              ]
            }
          ]
        )
      ]
    {:ok, fixtures}
  end

  test "get a single sala", fixtures do
    with_mock HTTPoison,
      [get:
        fn(url) ->
          assert url == "http://api.salas.gonebe.com/salas/1"
          {:ok, %{status_code: 200, body: fixtures.sala}}
        end
      ] do

      {:ok, sala } = BibingSalasBot.SalasAPIClient.get_sala(1)
      turno = Enum.at(sala["turns"], 0)

      assert sala["id"] == 1
      assert turno["id"] == 1
      assert turno["time"] == "8:00 - 10:30"
      assert turno["available"] == false
    end
  end

  test "get the list of salas", fixtures do
    with_mock HTTPoison,
      [get:
        fn(url) ->
          assert url == "http://api.salas.gonebe.com/salas"
          {:ok, %{status_code: 200, body: fixtures.salas}}
        end
      ] do

      {:ok, res} = BibingSalasBot.SalasAPIClient.get_salas

      sala1 = Enum.at(res, 0)
      sala1_turno4 = Enum.at(sala1["turns"], 3)
      assert sala1["id"] == 1
      assert sala1_turno4["id"] == 4
      assert sala1_turno4["time"] == "14:30 - 16:30"
      assert sala1_turno4["available"] == true

      sala4 = Enum.at(res, 1)
      sala4_turno1 = Enum.at(sala4["turns"], 0)
      assert sala4["id"] == 4
      assert sala4_turno1["id"] == 1
      assert sala4_turno1["time"] == "8:00 - 10:30"
      assert sala4_turno1["available"] == true
    end
  end

  test "get the reserva for a given date", fixtures do
    with_mock HTTPoison,
      [get:
        fn(url) ->
          assert url == "http://api.salas.gonebe.com/reservas/1-1-2000?username=user&password=passwd"
          {:ok, %{status_code: 200, body: fixtures.reserva}}
        end
      ] do

      {:ok, res} = BibingSalasBot.SalasAPIClient
        .get_reserva("1-1-2000", "user", "passwd")

      assert res["date"] == "1-1-2000"
      assert res["reservation"] == "41530"
      assert res["room"] == 1
      assert res["turn"] == 4
      assert res["time"] == "8:00 - 10:30"
    end
  end

  test "create a reservation", fixtures do
    with_mock HTTPoison,
      [post:
        fn(url, _, _) ->
          assert url == "http://api.salas.gonebe.com/reservas"
          {:ok, %{status_code: 200, body: fixtures.created}}
        end
      ] do

      form = %{
        name: "John Doe",
        uvus: "johdoe",
        email: "email@email.com",
        date: "1-1-2000",
        room: 1,
        turn: 3,
        username: "johdoe",
        password: "qwerty"
      }

      {:ok, res} = BibingSalasBot.SalasAPIClient.create_reserva(form)

      assert res["room"] == 1
      assert res["turn"] == 3
      assert res["date"] == "1-1-2000"
      assert res["time"] == "8:00 - 10:30"
      assert res["reservation"] == "41530"
    end
  end

  test "cancel a reservation", fixtures do
    with_mock HTTPoison,
      [delete:
        fn(url) ->
          assert url == "http://api.salas.gonebe.com/reservas/41530"
          {:ok, %{status_code: 200, body: fixtures.deleted}}
        end
      ] do

      {:ok, res} = BibingSalasBot.SalasAPIClient.delete_reserva("41530")

      assert res["reservation"] == "41530"
    end
  end
end
