import dynamo/types/client.{type DynamoClient}
import gleam/dict.{type Dict}
import gleam/json
import gleam/option.{type Option}

pub type GetBuilder {
  GetBuilder(
    client: DynamoClient,
    keys: Dict(String, json.Json),
    json_fields: Dict(String, json.Json),
  )
}
