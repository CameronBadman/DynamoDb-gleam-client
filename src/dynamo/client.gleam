import dynamo/types/client.{type DynamoClient, DynamoClient}
import dynamo/types/error.{type DynamoError, ValidationError}
import gleam/result

pub fn build(
  access_key_id: String,
  secret_access_key: String,
) -> Result(DynamoClient, DynamoError) {
  case access_key_id, secret_access_key {
    "", _ -> Error(ValidationError("access_key_id cannot be empty"))
    _, "" -> Error(ValidationError("secret_access_key cannot be empty"))

    access_key_id, secret_access_key ->
      Ok(DynamoClient(
        access_key_id: access_key_id,
        secret_access_key: secret_access_key,
        region: "us-east-1",
        domain: "amazonaws.com",
      ))
  }
}

pub fn with_region(
  client_result: Result(DynamoClient, DynamoError),
  region: String,
) -> Result(DynamoClient, DynamoError) {
  result.map(client_result, fn(client) { DynamoClient(..client, region:) })
}

pub fn with_domain(
  client_result: Result(DynamoClient, DynamoError),
  domain: String,
) -> Result(DynamoClient, DynamoError) {
  result.map(client_result, fn(client) { DynamoClient(..client, domain:) })
}
