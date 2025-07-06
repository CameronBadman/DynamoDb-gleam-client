import dynamo/types/builders.{type GetBuilder}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError, HttpError, UriError}
import gleam/bit_array

// <--- Make sure this is imported!
import aws4_request
import gleam/http
import gleam/http/request.{type Request}
import gleam/json
import gleam/result
import gleam/string

pub fn build_url(region: String, domain: String) -> String {
  string.concat(["https://dynamodb.", region, ".", domain])
}

pub fn create_request(
  client: DynamoClient,
  target: String,
  body: json.Json,
) -> Result(Request(BitArray), String) {
  let url = build_url(client.region, client.domain)
  let body_string = json.to_string(body)

  let body_bit_array = bit_array.from_string(body_string)
  use req <- result.try(
    request.to(url)
    |> result.map_error(fn(_) { "Invalid URL: " <> url }),
  )

  let request_with_headers =
    req
    |> request.set_method(http.Post)
    |> request.set_header("Content-Type", "application/x-amz-json-1.0")
    |> request.set_header("X-Amz-Target", "DynamoDB_20120810." <> target)
    |> request.set_body(body_bit_array)

  let signer =
    aws4_request.signer(
      access_key_id: client.access_key_id,
      secret_access_key: client.secret_access_key,
      region: client.region,
      service: "dynamodb",
    )

  let signed_request = aws4_request.sign_bits(signer, request_with_headers)

  Ok(signed_request)
}
