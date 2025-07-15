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

pub fn new() -> Dict(String, AttributeValue) {
  dict.new()
}

pub fn add_string(attrs: Dict(String, AttributeValue), key: String, value: String) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, String(value))
}

pub fn add_number(attrs: Dict(String, AttributeValue), key: String, value: Int) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, value |> int.to_string |> Number)
}

pub fn add_bool(attrs: Dict(String, AttributeValue), key: String, value: Bool) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, Bool(value))
}

pub fn add_number_set(
  attrs: Dict(String, AttributeValue),
  key: String,
  values: List(Int),
) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, values |> list.map(int.to_string) |> NumberSet)
}

pub fn add_string_set(
  attrs: Dict(String, AttributeValue),
  key: String,
  values: List(String),
) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, StringSet(values))
}

pub fn add_list(
  attrs: Dict(String, AttributeValue),
  key: String,
  values: List(AttributeValue),
) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, List(values))
}

pub fn add_map(
  attrs: Dict(String, AttributeValue),
  key: String,
  values: Dict(String, AttributeValue),
) -> Dict(String, AttributeValue) {
  dict.insert(attrs, key, Map(values))
}

