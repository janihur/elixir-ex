defmodule Ex001Json do
  @moduledoc """
  How to transform a JSON:

  1) use Jason.encode!/1 to convert input JSON to (input) Elixir value (i.e. Map)
  2) use standard Elixir functions to build a new (output) Elixir value from the input value
  3) use Jason.decode!/1 to convert Elixir value (i.e. Map) to output JSON

  The example is not consistent as different ways are trialled.

  Note this example is missing deeply nested structures.
  """

  def device_imeiNumber(input) do
    %{
      "device" => %{
        "imeiNumber" => input |> Map.get("device") |> Map.get("deviceIdentifier") |> Map.get("id")
      }
    }
  end

  def notes(input) do
    %{
      "notes" =>
        input["note"] |> Enum.map(fn note ->
          Enum.reduce(note, %{"type" => "ISSUE"}, fn {k, v}, acc ->
            Map.put(acc, k, v)
          end)
        end)
    }
  end

  def tasks(input) do
    %{
      "tasks" =>
        input["characteristic"] |> Enum.map(fn characteristic ->
          Enum.reduce(characteristic, %{}, fn {name, value}, acc ->
            case name do
              # JSON name/value pairs that needs to be modified
              "name" ->
                Map.put(acc, "id", String.to_integer(value))
              # JSON name/value pairs that can be copied as-is
              _ ->
                Map.put(acc, name, value)
            end
          end)
        end)
    }
  end

  def contact_address(input) do
    %{
      "contactAddress" => %{
        "address1" => input["postContact"]["street1"],
        "name"     => input["postContact"]["name"],
        "city"     => input["postContact"]["city"],
        "zip"      => input["postContact"]["postCode"],
        "country"  => input["postContact"]["country"],
      }
    }
  end
end
