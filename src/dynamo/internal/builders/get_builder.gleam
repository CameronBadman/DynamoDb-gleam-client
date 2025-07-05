import dynamo/types/client.{type DynamoClient, DynamoClient}
import gleam/option.{type Option}

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

pub fn new_get_builder(
  client: DynamoClient,
  table_name: String,
  key_name: String,
  key_value: String,
) -> GetBuilder {
  GetBuilder(
    client: client,
    table_name: table_name,
    key_name: key_name,
    key_value: key_value,
    consistent_read: option.None,
    projection_expression: option.None,
  )
}

pub fn with_consistent_read(
  builder: GetBuilder,
  consistent_read: Bool,
) -> GetBuilder {
  GetBuilder(..builder, consistent_read: option.Some(consistent_read))
}

pub fn with_projection_expression(
  builder: GetBuilder,
  projection_expression: String,
) -> GetBuilder {
  GetBuilder(
    ..builder,
    projection_expression: option.Some(projection_expression),
  )
}
