import aws4_request
import dynamo/types/client.{type DynamoClient, DynamoClient}
import gleam/result

pub fn build(
  access_key_id: String,
  secret_access_key: String,
) -> Result(DynamoClient, String) {
  case access_key_id, secret_access_key {
    "", _ -> Error("access_key_id is not valid")
    _, "" -> Error("access_key_id is not valid")
    _, _ ->
      Ok(DynamoClient(
        signer: generate_signer(access_key_id, secret_access_key, "us-east-1"),
        access_key_id:,
        secret_access_key:,
        region: "us-east-1",
        domain: "amazonaws.com",
      ))
  }
}

pub fn with_region(
  client_result: Result(DynamoClient, String),
  region: String,
) -> Result(DynamoClient, String) {
  result.map(client_result, fn(client) {
    DynamoClient(
      ..client,
      region:,
      signer: generate_signer(
        client.access_key_id,
        client.secret_access_key,
        region,
      ),
    )
  })
}

pub fn with_domain(
  client_result: Result(DynamoClient, String),
  domain: String,
) -> Result(DynamoClient, String) {
  result.map(client_result, fn(client) { DynamoClient(..client, domain:) })
}

pub fn generate_signer(
  access_key_id: String,
  secret_access_key: String,
  region: String,
) -> aws4_request.Signer {
  aws4_request.signer(
    access_key_id: access_key_id,
    secret_access_key: secret_access_key,
    region: region,
    service: "dynamodb",
  )
}
