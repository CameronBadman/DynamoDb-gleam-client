import dynamo/builders/get.{exec, get_req, put_req, del_req}
import dynamo/client
import dynamo/internal/attributes/parser.{attribute_value_to_json, pretty_print_json}
import dynamo/options/options.{with_composite_key}
import dynamo/types/attributes.{Bool, Json, Map, Number, NumberSet, String}

import dynamo/builders/dynamo_json.{add}

import dynamo/types/error.{handle_error}
import gleam/bit_array
import gleam/dict
import gleam/int
import gleam/io

pub fn main() {
  let access_key = ""
  let secret_key = ""

  let client_result =
    client.build(access_key, secret_key)
    |> client.with_region("us-east-1")

  let client = case client_result {
    Ok(client) -> client
    Error(err) -> {
      io.println(handle_error(err))
      panic
    }
  }
  let object1 =
    dict.new()
    |> add("id", String("test2"))
    |> add("active", Bool(False))
    |> add("age", Number("20"))
    |> add("email", String("test@test.com"))
    |> add("name", String("testingtest"))
    |> Json

  let object =
    dict.new()
    |> add("id", String("test1"))
    |> add("test1", NumberSet(["1", "2", "3", "4"]))
    |> add(
      "map",
      dict.new()
        |> add("test", Number("1"))
        |> add("mapping_test", NumberSet(["1", "2", "3", "4"]))
        |> Map,
    )
    |> Json

  

  let get_result =
    client
    |> put_req("gleam-test-table", object1)
    |> exec()

  case get_result {
    Ok(response) -> {
      io.println("Status: " <> int.to_string(response.status))
      case bit_array.to_string(response.body) {
        Ok(body_string) -> io.println(body_string)
        Error(_) -> io.println("failed")
      }
    }
    Error(err) -> {
      io.println(handle_error(err))
    }
  }
}
