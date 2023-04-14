defmodule Ex001JsonTest do
  use ExUnit.Case

  @input_json ~s({
      "externalId": "EXTERNAL_ID",
      "note": [
        {
          "title": "NOTE_1_TITLE",
          "text": "NOTE_1_TEXT"
        },
        {
          "title": "NOTE_2_TITLE",
          "text": "NOTE_2_TEXT"
        },
        {
          "text": "NOTE_3_TEXT"
        }
      ],
      "characteristic": [
        {
          "name": "1",
          "value": "CHARACTERICTIC_1_VALUE"
        },
        {
          "name": "2",
          "value": "CHARACTERICTIC_2_VALUE"
        }
      ],
      "device": {
        "deviceIdentifier": {
          "id": "DEVICEIDENTIFIER_ID"
        }
      },
      "contact": {
        "name": "RELATEDPARTY_1_NAME",
        "role": "ORDER_CONTACT"
      },
      "emailContact": {
        "emailAddress": "RELATEDPARTY_1_EMAILADDRESS"
      },
      "telephoneContact": {
        "phoneNumber": "RELATEDPARTY_1_PHONENUMBER"
      },
      "postContact": {
        "city": "RELATEDPARTY_1_CITY",
        "country": "RELATEDPARTY_1_COUNTRY",
        "postCode": "RELATEDPARTY_1_POSTCODE",
        "street1": "RELATEDPARTY_1_STREET1",
        "name": "RELATEDPARTY_1_NAME"
      }
    })

  test "json encoding (from Elixir values to JSON)" do
    assert(
      "{\"age\":44,\"name\":\"Steve Irwin\",\"nationality\":\"Australian\"}"
      ==
      Jason.encode!(%{"age" => 44, "name" => "Steve Irwin", "nationality" => "Australian"})
      # |> IO.inspect(label: "JSON")
    )
  end

  test "json decoding (from JSON to Elixir values)" do
    assert(
      %{"age" => 44, "name" => "Steve Irwin", "nationality" => "Australian"}
      ==
      Jason.decode!(~s({"age":44,"name":"Steve Irwin","nationality":"Australian"}))
      # |> IO.inspect(label: "Elixir values")
    )
  end

  test "device_imeiNumber" do
    assert(
      %{"device" => %{"imeiNumber" => "DEVICEIDENTIFIER_ID"}}
      ==
      Ex001Json.device_imeiNumber(%{"device" => %{"deviceIdentifier" => %{"id" => "DEVICEIDENTIFIER_ID"}}})
    )
  end

  test "notes" do
    assert(
      %{"notes" => [
        %{"text" => "NOTE_1_TEXT", "title" => "NOTE_1_TITLE", "type" => "ISSUE"},
        %{"text" => "NOTE_2_TEXT", "title" => "NOTE_2_TITLE", "type" => "ISSUE"},
        %{"text" => "NOTE_3_TEXT",                            "type" => "ISSUE"}
      ]}
      ==
      Ex001Json.notes(%{"note" => [
        %{"text" => "NOTE_1_TEXT", "title" => "NOTE_1_TITLE"},
        %{"text" => "NOTE_2_TEXT", "title" => "NOTE_2_TITLE"},
        %{"text" => "NOTE_3_TEXT"}
      ]})
    )
  end

  test "tasks" do
    assert(
      %{"tasks" => [
        %{"id" => 1, "value" => "CHARACTERICTIC_1_VALUE"},
        %{"id" => 2, "value" => "CHARACTERICTIC_2_VALUE"}
      ]}
      ==
      Ex001Json.tasks(%{ "characteristic" => [
        %{"name" => "1", "value" => "CHARACTERICTIC_1_VALUE"},
        %{"name" => "2", "value" => "CHARACTERICTIC_2_VALUE"}
      ]})
    )
  end

  @tag runonly: true
  test "JSON transformation" do
    input_value = Jason.decode!(@input_json) #|> IO.inspect(label: "input_value")

    # illustrates different ways to build output value
    output_value =
      %{
        "customer" => %{"id" => 111},
        "location" => %{"id" => 222},
        "queue"    => %{"id" => 333}
      }
      |> Map.put("reference", Map.get(input_value, "externalId"))
      |> Map.merge(Ex001Json.device_imeiNumber(input_value))
      |> Map.merge(Ex001Json.notes(input_value))
      |> Map.merge(Ex001Json.tasks(input_value))
      |> Map.put("contactName", Map.get(Map.get(input_value, "contact"), "name"))
      |> Map.put("contactEmail", Map.get(Map.get(input_value, "emailContact"), "emailAddress"))
      |> Map.put("contactPhone", Map.get(Map.get(input_value, "telephoneContact"), "phoneNumber"))
      |> Map.merge(Ex001Json.contact_address(input_value))
      # |> IO.inspect(label: "output_value")

    assert(
      %{
        "contactAddress" => %{
          "address1" => "RELATEDPARTY_1_STREET1",
          "city" => "RELATEDPARTY_1_CITY",
          "country" => "RELATEDPARTY_1_COUNTRY",
          "name" => "RELATEDPARTY_1_NAME",
          "zip" => "RELATEDPARTY_1_POSTCODE"
        },
        "contactEmail" => "RELATEDPARTY_1_EMAILADDRESS",
        "contactName" => "RELATEDPARTY_1_NAME",
        "contactPhone" => "RELATEDPARTY_1_PHONENUMBER",
        "customer" => %{"id" => 111},
        "device" => %{"imeiNumber" => "DEVICEIDENTIFIER_ID"},
        "location" => %{"id" => 222},
        "notes" => [
          %{"text" => "NOTE_1_TEXT", "title" => "NOTE_1_TITLE", "type" => "ISSUE"},
          %{"text" => "NOTE_2_TEXT", "title" => "NOTE_2_TITLE", "type" => "ISSUE"},
          %{"text" => "NOTE_3_TEXT", "type" => "ISSUE"}
        ],
        "queue" => %{"id" => 333},
        "reference" => "EXTERNAL_ID",
        "tasks" => [
          %{"id" => 1, "value" => "CHARACTERICTIC_1_VALUE"},
          %{"id" => 2, "value" => "CHARACTERICTIC_2_VALUE"}
        ]
      }
      ==
      output_value
    )
    _output_json = Jason.encode!(output_value) #|> IO.inspect(label: "output_json")
  end
end
