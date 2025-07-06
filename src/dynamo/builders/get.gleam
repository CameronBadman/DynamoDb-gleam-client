import dynamo/operations/get.{get_item}
import dynamo/types/builders.{type GetBuilder, GetBuilder}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError}
import gleam/http/response
import gleam/option.{None, Some}

pub fn get_req(
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
    consistent_read: None,
    projection_expression: None,
  )
}

pub fn with_consistent_read(builder: GetBuilder, val: Bool) -> GetBuilder {
  GetBuilder(..builder, consistent_read: Some(val))
}

pub fn with_projection_expression(
  builder: GetBuilder,
  val: String,
) -> GetBuilder {
  GetBuilder(..builder, projection_expression: Some(val))
}

pub fn exec(
  builder: GetBuilder,
) -> Result(response.Response(BitArray), DynamoError) {
  get_item(builder)
}
