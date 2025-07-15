import dynamo/types/attributes.{type AttributeValue}
import dynamo/types/client.{type DynamoClient}
import gleam/dict.{type Dict}
import gleam/json

pub type DynamoReq {
  DynamoReq(
    client: DynamoClient,
    keys: Dict(String, json.Json),
    json_fields: Dict(String, json.Json),
  )
}

pub type MapBuilder {
  MapBuilder(attrs: dict.Dict(String, AttributeValue))
}
