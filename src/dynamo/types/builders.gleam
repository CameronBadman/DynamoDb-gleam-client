import dynamo/types/attributes.{type AttributeValue}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/operations.{type Metadata, type Operation}
import gleam/dict.{type Dict}
import gleam/json

pub type DynamoReq {
  DynamoReq(
    operation: Operation,
    client: DynamoClient,
    json_fields: Dict(String, json.Json),
    metadata: Dict(String, Metadata),
  )
}

pub type MapBuilder {
  MapBuilder(attrs: dict.Dict(String, AttributeValue))
}
