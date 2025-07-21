import aws4_request
import dynamo/types/builders.{type DynamoReq}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/operations.{
  type Metadata, type Operation, CompositeKey, Delete, Get, Put, Query, Scan,
  Update,
}
import gleam/bit_array
import gleam/dict
import gleam/http
import gleam/http/request.{type Request}
import gleam/json
import gleam/result
import gleam/string

pub fn build_url(region: String, domain: String) -> String {
  string.concat(["https://dynamodb.", region, ".", domain])
}

pub fn create_request(
  dynamo_req: DynamoReq,
) -> Result(Request(BitArray), String) {
  let url = build_url(dynamo_req.client.region, dynamo_req.client.domain)

  let body_bit_array =
    dynamo_req.json_fields
    |> dict.to_list
    |> json.object
    |> json.to_string
    |> bit_array.from_string

  use req <- result.try(
    request.to(url)
    |> result.map_error(fn(_) { "Invalid URL: " <> url }),
  )

  let request_with_headers =
    req
    |> request.set_method(http.Post)
    |> request.set_header("Content-Type", "application/x-amz-json-1.0")
    |> request.set_header(
      "X-Amz-Target",
      "DynamoDB_20120810." <> to_string(dynamo_req.operation),
    )
    |> request.set_body(body_bit_array)

  let signer =
    aws4_request.signer(
      access_key_id: dynamo_req.client.access_key_id,
      secret_access_key: dynamo_req.client.secret_access_key,
      region: dynamo_req.client.region,
      service: "dynamodb",
    )

  let signed_request = aws4_request.sign_bits(signer, request_with_headers)
  Ok(signed_request)
}

pub fn to_string(operation: Operation) -> String {
  case operation {
    Get -> "GetItem"
    Put -> "PutItem"
    Update -> "UpdateItem"
    Delete -> "DeleteItem"
    Query -> "Query"
    Scan -> "Scan"
  }
}
