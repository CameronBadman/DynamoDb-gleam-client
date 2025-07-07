import gleam/bit_array
import gleam/dict.{type Dict}
import gleam/json
import gleam/list

pub type AttributeValue {
  // Basic types - compile imediatly to json
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



