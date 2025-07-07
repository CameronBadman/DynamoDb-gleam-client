import dynamo/types/client.{type DynamoClient}
import dynamo/types/attributes.{type AttributeValue}
import gleam/dict.{type Dict}
import gleam/json



pub type GetBuilder {
  GetBuilder(
    client: DynamoClient,
    keys: Dict(String, json.Json),
    json_fields: Dict(String, json.Json),
  )
}

pub type PutBuilder {
  PutBuilder(
    client: DynamoClient,
    item_attributes: Dict(String, AttributeValue),
    json: Dict(String, json.Json)
  )
}


