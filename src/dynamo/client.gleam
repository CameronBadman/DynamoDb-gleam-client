import dynamo/types.{type DynamoClient, DynamoClient}
import gleam/result 

pub fn build(access_key_id: String, secret_access_key: String) -> Result(DynamoClient, String)  {
  case access_key_id, secret_access_key {
    "", _ -> Error("access_key_id is not valid")
    _, "" -> Error("access_key_id is not valid")
    _, _ -> Ok(DynamoClient(
      access_key_id:,
      secret_access_key:,
      region: "us-east-1",
      domain: "amazonaws.com",
    )) 
  }
}

pub fn with_region(client_result: Result(DynamoClient, String), region: String) -> Result(DynamoClient, String) {
  result.map(client_result, fn(client) { DynamoClient(..client, region:) })
}

pub fn with_domain(client_result: Result(DynamoClient, String), domain: String) -> Result(DynamoClient, String) {
  result.map(client_result, fn(client) { DynamoClient(..client, domain:) })
}
