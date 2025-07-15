import dynamo/internal/attributes/parser.{attribute_value_to_json, key}
import dynamo/operations/get.{get_item}
import dynamo/types/attributes.{type AttributeValue, String}
import dynamo/types/builders.{type DynamoReq, DynamoReq}
import dynamo/types/client.{type DynamoClient}
import dynamo/types/error.{type DynamoError}
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
  let json_key = key(key_name, key_value)
  let base_json =
    dict.new()
    |> dict.insert("TableName", json.string(table_name))
    |> dict.insert("Key", json_key)

  DynamoReq(client: client, keys: key_dict, json_fields: base_json)
}

pub fn with_composite_key(
  builder: DynamoReq,
  key_name: String,
  key_value: String,
) -> DynamoReq {
  let updated_keys =
    dict.insert(
      builder.keys,
      key_name,
      attribute_value_to_json(String(key_value)),
    )
  let json_key = json.object(dict.to_list(updated_keys))
  let updated_json = dict.insert(builder.json_fields, "Key", json_key)

  DynamoReq(
    client: builder.client,
    keys: updated_keys,
    json_fields: updated_json,
  )
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

pub fn exec(
  builder: DynamoReq,
) -> Result(response.Response(BitArray), DynamoError) {
  get_item(builder)
}
