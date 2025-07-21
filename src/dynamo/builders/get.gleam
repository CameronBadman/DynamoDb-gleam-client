import dynamo/internal/attributes/parser.{attribute_value_to_json, key}
import dynamo/operations/get.{get_item}
import dynamo/types/attributes.{type AttributeValue, String, Json}
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

pub fn put_req(
  client: DynamoClient,
  table_name: String,
  item: AttributeValue
) -> DynamoReq {
  let item_json = case item {
    Json(fields) -> {
      // Convert each field individually and build the object
      let field_list = dict.fold(fields, [], fn(acc, k, v) {
        [#(k, attribute_value_to_json(v)), ..acc]
      })
      json.object(field_list)
    }
    _ -> panic as "Item must be end in a Json for PutItem"
  }
  
  let base_json = dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Item", item_json)  // No outer "M" wrapper
  
  DynamoReq(
    client: client, 
    operation: Put,
    json_fields: base_json,
    metadata: dict.new()
  )
}


pub fn exec(
  req: DynamoReq,
) -> Result(response.Response(BitArray), DynamoError) {
  case req.operation {
    Get -> get_item(req)
    Put -> get_item(req)
    Update -> todo as "implement update_item(req)"
    Delete -> todo as "implement delete_item(req)"
    Query -> todo as "implement query(req)"
    Scan -> todo as "implement scan(req)"
  }
}
