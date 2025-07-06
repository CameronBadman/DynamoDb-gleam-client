import dynamo/types/client.{DynamoClient}
import dynamo/types/error.{type DynamoError, HttpError, UriError, RequestBuildError}
import dynamo/types/builders.{type GetBuilder}
import gleam/bit_array
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/json
import gleam/result
import gleam/string
import gleam/dict
import dynamo/operations/helpers.{create_request}

pub fn get_item(
  builder: GetBuilder,
) -> Result(response.Response(BitArray), DynamoError) {
  let json_body = json.object(dict.to_list(builder.json_fields))

  use request <- result.try(
    create_request(builder.client, "GetItem", json_body)
    |> result.map_error(fn(err) -> DynamoError {
        RequestBuildError
    })
  )

  use response <- result.try(
    httpc.send_bits(request)
    |> result.map_error(fn(err) -> DynamoError {
      HttpError(err)
    })
  )

  Ok(response)
}
