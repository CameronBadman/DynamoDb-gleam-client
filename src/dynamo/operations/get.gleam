import dynamo/attributes.{string_key_to_json}
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
import gleam/option
import gleam/result
import gleam/string

pub fn get_builder_to_json(request: GetBuilder) -> String {
  let base_object = [
    #("TableName", json.string(request.table_name)),
    #("Key", string_key_to_json(request.key_name, request.key_value)),
  ]

  let with_consistent_read = case request.consistent_read {
    option.Some(cr) -> [#("ConsistentRead", json.bool(cr)), ..base_object]
    option.None -> base_object
  }

  let with_projection = case request.projection_expression {
    option.Some(pe) -> [
      #("ProjectionExpression", json.string(pe)),
      ..with_consistent_read
    ]
    option.None -> with_consistent_read
  }

  json.object(with_projection)
  |> json.to_string
}

pub fn get_item(
  request: GetBuilder,
) -> Result(response.Response(BitArray), DynamoError) {
  let DynamoClient(access_key_id:, secret_access_key:, region:, domain:) =
    request.client
  let json_body = get_builder_to_json(request)

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
