import dynamo/internal/attributes/parser.{attribute_value_to_json, key}
import dynamo/operations/get.{get_item}
import dynamo/types/attributes.{
  type AttributeValue, Bool, List, Map, Number, NumberSet, String, StringSet,
}
import dynamo/types/builders.{type DynamoReq, DynamoReq}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError}
import gleam/dict.{type Dict}
import gleam/http/response
import gleam/int
import gleam/json
import gleam/list

pub fn add(
  attrs: Dict(String, AttributeValue),
  key: String,
  value: AttributeValue,
) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, value)
}
