import dynamo/types/attributes.{type AttributeValue}
import dynamo/types/client.{type DynamoClient}

import gleam/dict.{type Dict}
import gleam/json

pub type Operation {
  Get
  Put
  Update
  Delete
  Query
  Scan
}


pub type Metadata {
  CompositeKey(Dict(String, json.Json))
}
