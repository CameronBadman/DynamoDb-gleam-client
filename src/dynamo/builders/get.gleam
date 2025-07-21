import dynamo/internal/attributes/parser.{attribute_value_to_json, key}
import dynamo/operations/get.{get_item}
import dynamo/types/attributes.{type AttributeValue, String}
import dynamo/types/builders.{type DynamoReq, DynamoReq}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError}
import dynamo/types/operations.{
  type Operation, Delete, Get, Put, Query, Scan, Update, type Metadata, CompositeKey
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
  let key_dict = dict.new()
    |> dict.insert(key_name, attribute_value_to_json(String(key_value)))
  
  let json_key = json.object(dict.to_list(key_dict))

  let metadata =
  dict.new()
  |> dict.insert("CompositeKey", CompositeKey(key_dict))
  
  let base_json = dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Key", json_key)
    
  DynamoReq(client: client, operation: Get, json_fields: base_json, metadata: metadata)
}

pub fn exec(
  builder: DynamoReq,
) -> Result(response.Response(BitArray), DynamoError) {
  case builder.operation {
    Get -> get_item(builder)
    Put -> todo as "implement put_item(builder)"
    Update -> todo as "implement update_item(builder)"
    Delete -> todo as "implement delete_item(builder)"
    Query -> todo as "implement query(builder)"
    Scan -> todo as "implement scan(builder)"
  }
}
