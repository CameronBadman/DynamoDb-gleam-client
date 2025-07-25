import dynamo/types/attributes.{
  type AttributeValue, Binary, BinarySet, Bool, Json, List, Map, Null, Number,
  NumberSet, String, StringSet,
}
import gleam/bit_array
import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/result
import gleam/string

// Convert AttributeValue to JSON
pub fn attribute_value_to_json(value: AttributeValue) -> json.Json {
  case value {
    String(s) -> json.object([#("S", json.string(s))])
    Number(n) -> json.object([#("N", json.string(n))])
    Binary(_) -> json.object([#("NULL", json.bool(True))])
    Bool(b) -> json.object([#("BOOL", json.bool(b))])
    Null -> json.object([#("NULL", json.bool(True))])
    StringSet(ss) -> json.object([#("SS", json.array(ss, json.string))])
    NumberSet(ns) -> json.object([#("NS", json.array(ns, json.string))])
    BinarySet(bs) ->
      json.object([
        #(
          "BS",
          json.array(bs, fn(b) {
            json.string(bit_array.base64_encode(b, False))
          }),
        ),
      ])
    List(items) ->
      json.object([#("L", json.array(items, attribute_value_to_json))])
    Map(map) -> {
      let map_json =
        map
        |> dict.to_list
        |> list.map(fn(pair) {
          let #(key, value) = pair
          #(key, attribute_value_to_json(value))
        })
        |> json.object
      json.object([#("M", map_json)])
    }
    Json(dict) -> {
      dict
      |> dict.to_list
      |> list.map(fn(pair) {
        let #(key, value) = pair
        #(key, attribute_value_to_json(value))
      })
      |> json.object
      // No outer wrapper - direct JSON object!
    }
  }
}

pub fn key(key_name: String, key_value: String) -> json.Json {
  json.object([#(key_name, attribute_value_to_json(String(key_value)))])
}

// Pretty print JSON with indentation
pub fn pretty_print_json(json_value: json.Json) -> String {
  json_value
  |> json.to_string
  |> format_json_string(0)
}

// Simple JSON formatter (basic indentation)
fn format_json_string(json_str: String, indent: Int) -> String {
  let indent_str = string.repeat(" ", indent)
  json_str
  |> string.replace("{", "{\n" <> string.repeat(" ", indent + 2))
  |> string.replace("}", "\n" <> indent_str <> "}")
  |> string.replace(",", ",\n" <> string.repeat(" ", indent + 2))
  |> string.replace(":", ": ")
}
