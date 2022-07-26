defmodule Airports do
  alias NimbleCSV.RFC4180, as: CSV

  def airport_csv do
    Application.app_dir(:airports, "/priv/airports.csv")
  end

  def open_csv() do
    airport_csv()
    |> File.stream!()
    |> Flow.from_enumerable()
    |> Flow.map(fn row ->
      [row] = CSV.parse_string(row, skip_headers: false)

      %{
        id: Enum.at(row, 0),
        type: Enum.at(row, 2),
        name: Enum.at(row, 3),
        country: Enum.at(row, 8)
      }
    end)
    |> Flow.reject(&(&1.type == "closed"))
    |> Flow.partition(key: {:key, :country})
    |> Flow.group_by(fn item -> item.country end)
    |> Flow.on_trigger(fn acc, _partition_info, {type, id, trigger} ->
      events =
        acc
        |> Enum.map(fn {country, data} -> {country, Enum.count(data)} end)

      IO.inspect({type, id, trigger}, label: :done, limit: 10)

      case trigger do
        :done ->
          {events, acc}

        {:every, 1000} ->
          IO.inspect(acc, label: :every_500)
          {[], acc}
      end
    end)
    |> Flow.take_sort(10, fn {_, a}, {_, b} -> a > b end)
    |> Enum.to_list()
    # |> Flow.run()
    |> List.flatten()
  end

end
