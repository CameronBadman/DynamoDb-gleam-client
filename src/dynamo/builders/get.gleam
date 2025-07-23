import dynamo/internal/attributes/parser.{attribute_value_to_json, key}
import dynamo/operations/get.{get_item}
import dynamo/types/attributes.{type AttributeValue, Json, String}
import dynamo/types/builders.{type DynamoReq, DynamoReq}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError}
import dynamo/types/operations.{
  type Metadata, type Operation, CompositeKey, Delete, Get, Put, Query, Scan,
  Update,
}
import gleam/dict.{type Dict}
import gleam/http/response

import gleam/json

pub fn get_req(
  client: DynamoClient,
  table_name: String,
  key_name: String,
  key_value: String,
) -> DynamoReq {
  let key_dict =
    dict.new()
    |> dict.insert(key_name, attribute_value_to_json(String(key_value)))

  let json_key = json.object(dict.to_list(key_dict))

  let metadata =
    dict.new()
    |> dict.insert("CompositeKey", CompositeKey(key_dict))

  let base_json =
    dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Key", json_key)

  DynamoReq(
    client: client,
    operation: Get,
    json_fields: base_json,
    metadata: metadata,
  )
}

pub fn put_req(
  client: DynamoClient,
  table_name: String,
  item: AttributeValue,
) -> DynamoReq {
  let item_json = attribute_value_to_json(item)

  let base_json =
    dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Item", item_json)

  DynamoReq(
    client: client,
    operation: Put,
    json_fields: base_json,
    metadata: dict.new(),
  )
}

pub fn del_req(
  client: DynamoClient,
  table_name: String,
  key_name: String,
  key_value: String,
) -> DynamoReq {
  let key_dict =
    dict.new()
    |> dict.insert(key_name, attribute_value_to_json(String(key_value)))

  let json_key = json.object(dict.to_list(key_dict))

  let metadata =
    dict.new()
    |> dict.insert("CompositeKey", CompositeKey(key_dict))

  let base_json =
    dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Key", json_key)

  DynamoReq(
    client: client,
    operation: Delete,
    json_fields: base_json,
    metadata: metadata,
  )
}

pub fn update_req(
  client: DynamoClient,
  table_name: String,
  key_name: String,
  key_value: String,
  expression: String,
  item: AttributeValue,
) -> DynamoReq {
  let key_dict =
    dict.new()
    |> dict.insert(key_name, attribute_value_to_json(String(key_value)))

  let json_key = json.object(dict.to_list(key_dict))

  let metadata =
    dict.new()
    |> dict.insert("CompositeKey", CompositeKey(key_dict))

  let base_json =
    dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Key", json_key)
    |> dict.insert("UpdateExpression", json.string(expression))

  DynamoReq(
    client: client,
    operation: Delete,
    json_fields: base_json,
    metadata: metadata,
  )
}

pub fn exec(req: DynamoReq) -> Result(response.Response(BitArray), DynamoError) {
  case req.operation {
    Get -> get_item(req)
    Put -> get_item(req)
    Update -> todo as "implement update_item(req)"
    Delete -> get_item(req)
    Query -> todo as "implement query(req)"
    Scan -> todo as "implement scan(req)"
  }
}
