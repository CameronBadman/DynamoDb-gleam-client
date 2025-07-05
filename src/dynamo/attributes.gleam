import gleam/dict.{type Dict}
import gleam/json
import gleam/bit_array
import gleam/list

pub type AttributeValue {
  String(String)
  Number(String)
  Binary(String)
  Bool(Bool)
  Null
  StringSet(List(String))
  NumberSet(List(String))
  BinarySet(List(BitArray))
  List(List(AttributeValue))
  Map(Dict(String, AttributeValue))
}

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
    BinarySet(bs) -> json.object([#("BS", json.array(bs, fn(b) { 
      json.string(bit_array.base64_encode(b, False))}))])
    List(items) -> json.object([#("L", json.array(items, attribute_value_to_json))])
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
  }
}

pub fn string_key_to_json(name: String, value: String) -> json.Json {
  [#(name, attribute_value_to_json(String(value)))]
  |> json.object
}
