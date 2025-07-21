import dynamo/internal/attributes/parser.{attribute_value_to_json, key}
import dynamo/operations/get.{get_item}
import dynamo/types/attributes.{type AttributeValue, String, Binary, Number}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError}
import dynamo/types/builders.{type DynamoReq, DynamoReq}
import dynamo/types/operations.{
  type Operation, Delete, Get, Put, Query, Scan, Update, type Metadata, CompositeKey
}
import gleam/dict.{type Dict}
import gleam/http/response
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import gleam/io
import gleam/dynamic/decode

pub fn with_composite_key(
  builder: DynamoReq,
  key_name: String,
  key_value: AttributeValue
) -> DynamoReq {
  case builder.operation {
    Get | Update | Delete -> {
      case key_value {
        String(_) | Number(_) | Binary(_) -> {
          // Add to metadata
          let key_to_add = attribute_value_to_json(key_value)
          let updated_metadata = case dict.get(builder.metadata, "CompositeKey") {
            Ok(CompositeKey(existing_keys)) -> 
              dict.insert(builder.metadata, "CompositeKey", 
                CompositeKey(dict.insert(existing_keys, key_name, key_to_add)))
            Error(_) -> 
              dict.insert(builder.metadata, "CompositeKey", 
                CompositeKey(dict.new() |> dict.insert(key_name, key_to_add)))
          }
          
          // Rebuild the Key field in json_fields
          let key_dict = case dict.get(updated_metadata, "CompositeKey") {
            Ok(CompositeKey(keys)) -> keys
            Error(_) -> dict.new()
          }
          
          let json_key = json.object(dict.to_list(key_dict))
          let updated_json_fields = dict.insert(builder.json_fields, "Key", json_key)
          
          DynamoReq(
            client: builder.client,
            operation: builder.operation,
            json_fields: updated_json_fields,
            metadata: updated_metadata
          )
        }
        _ -> builder  // Invalid key type, return unchanged
      }
    }
    _ -> builder
  }
}

pub fn with_consistent_read(builder: DynamoReq, val: Bool) -> DynamoReq {
  let updated_json =
    dict.insert(builder.json_fields, "ConsistentRead", json.bool(val))
  DynamoReq(..builder, json_fields: updated_json)
}

pub fn with_projection(builder: DynamoReq, val: String) -> DynamoReq {
  let updated_json =
    dict.insert(builder.json_fields, "ProjectionExpression", json.string(val))
  DynamoReq(..builder, json_fields: updated_json)
}

pub fn with_return_consumed_capacity(builder: DynamoReq, val: String) -> DynamoReq {
  let updated_json =
    dict.insert(builder.json_fields, "ReturnConsumedCapacity", json.string(val))
  DynamoReq(..builder, json_fields: updated_json)
}
