import gleam/option.{type Option}
import dynamo/types/client.{type DynamoClient}

pub type GetBuilder {
  GetBuilder(
    client: DynamoClient,
    table_name: String,
    key_name: String,
    key_value: String,
    consistent_read: Option(Bool),
    projection_expression: Option(String),
  )
}
