defmodule Ex002ReqTest do
  use ExUnit.Case
  # doctest Ex002Req

  # test "greets the world" do
  #   assert Ex002Req.hello() == :world
  # end

  # test "Req" do
  #   response =
  #   Req.get!("https://api.chucknorris.io/jokes/random")
  #   |> IO.inspect()

  #   # response.body.value |> IO.inspect()
  # end

  test "Req.Response" do
    response = %Req.Response{
      status: 200,
      headers: [
        {"date", "Tue, 18 Apr 2023 15:52:03 GMT"},
        {"content-type", "application/json;charset=UTF-8"},
        {"transfer-encoding", "chunked"},
        {"connection", "keep-alive"},
        {"via", "1.1 vegur"},
        {"cf-cache-status", "DYNAMIC"},
        {"report-to",
         "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v3?s=U%2F5GD48zu5tuA4baLQ1tjLM65pGv8zeJaSI19MY8RXRnBz5CZejKT3LnSa6ztmx%2FelArLWSgIMC6R%2B%2BfTqh%2Fl4s1fEMJ8OdwaqG801xGTSsNOBcFI4VURsIF0Y3tyETP2ik7jfc%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}"},
        {"nel",
         "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}"},
        {"server", "cloudflare"},
        {"cf-ray", "7b9e129b5dba09a8-ARN"},
        {"content-encoding", "gzip"},
        {"alt-svc", "h3=\":443\"; ma=86400, h3-29=\":443\"; ma=86400"}
      ],
      body: %{
        "categories" => [],
        "created_at" => "2020-01-05 13:42:25.352697",
        "icon_url" => "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
        "id" => "pIKfudjkQTizn5dyyxKm9A",
        "updated_at" => "2020-01-05 13:42:25.352697",
        "url" => "https://api.chucknorris.io/jokes/pIKfudjkQTizn5dyyxKm9A",
        "value" => "Believe it or not, people living in the jungles of Southeast Asia wore a Chuck Norris face mask on the back of their heads to prevent tigers from attacking them from behind."
      },
      private: %{}
    }

    response.body["value"] |> IO.inspect()
  end
end
