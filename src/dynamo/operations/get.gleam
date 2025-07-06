import dynamo/types/client.{DynamoClient}
import dynamo/types/error.{type DynamoError, HttpError, UriError}
import aws4_request
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


pub fn get_item(
  request: GetBuilder,
) -> Result(response.Response(BitArray), DynamoError) {
  let DynamoClient(access_key_id:, secret_access_key:, region:, domain:) =
    request.client
  let json_body = request.json_fields
  |> dict.to_list
  |> json.object
  |> json.to_string
  
  use req <- result.try(
    request.to(string.concat(["https://dynamodb.", region, ".", domain]))
    |> result.map_error(fn(_) { UriError }),
  )

  let request_with_headers =
    req
    |> request.set_header(
      "content-type",
      "application/x-amz-json-1.0; charset=utf-8",
    )
    |> request.set_header("X-Amz-Target", "DynamoDB_20120810.GetItem")
    |> request.set_method(http.Post)
    |> request.set_body(bit_array.from_string(json_body))
  let signer =
    aws4_request.signer(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      region: region,
      service: "dynamodb",
    )

  let signed_request = aws4_request.sign_bits(signer, request_with_headers)

  httpc.send_bits(signed_request)
  |> result.map_error(HttpError)
}
