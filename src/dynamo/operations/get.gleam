import aws4_request
import dynamo/types.{
  type DynamoClient, 
  type DynamoError, 
  UriError, 
  HttpError
}
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/result
import gleam/string

pub fn get_item(client: DynamoClient) -> Result(response.Response(BitArray), DynamoError) {
  use req <- result.try(
    request.to(string.concat([
      "https://dynamodb.", client.region, ".amazonaws.com"
    ]))
    |> result.map_error(fn(_) { UriError })
  )
  
  let request_with_headers =
    req
    |> request.set_header("content-type", "application/x-amz-json-1.0; charset=utf-8")
    |> request.set_method(http.Get)
    |> request.set_body(<<>>)
  
  let signer =
    aws4_request.signer(
      access_key_id: client.access_ke_id,
      secret_access_key: client.secret_access_key,
      region: client.region,
      service: "dynamodb",
    )
  
  let signed_request = aws4_request.sign_bits(signer, request_with_headers)
  
  httpc.send_bits(signed_request)
  |> result.map_error(HttpError)
}
