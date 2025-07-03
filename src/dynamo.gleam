import dynamo/client
import dynamo/attributes.{string_key}
import dynamo/operations/get.{new_get_item_request, get_item}
import dynamo/types/error.{handle_error}
import gleam/io
import gleam/int
import gleam/bit_array

pub fn main() {
  let secret_key = ""
  let access_key = ""
  
  let client_result = 
    client.build(access_key, secret_key)
    |> client.with_region("us-east-1")
  
  let client = case client_result {
    Ok(client) -> client
    Error(msg) -> {
      io.println("❌ Client creation failed: " <> msg)
      panic
    }
  }
  
  // Now client is guaranteed to be valid - no more Result handling needed
  let get_request = new_get_item_request(
    "gleam-test-table",
    string_key("id", "test-user-123")
  )
  
  case get_item(client, get_request) {
    Ok(response) -> {
      io.println("Status: " <> int.to_string(response.status))
      case bit_array.to_string(response.body) {
        Ok(body_string) -> io.println("Response body: " <> body_string)
        Error(_) -> io.println("Could not convert response body to string")
      }
    }
    Error(err) -> {
      io.println(handle_error(err))
    }
  }
}
