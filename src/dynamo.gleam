import dynamo/client
import dynamo/attributes.{string_key}
import dynamo/operations/get.{new_get_item_request, get_item}
import dynamo/types.{handle_error}
import gleam/io
import gleam/int
import gleam/bit_array

pub fn main() {
  // Replace with your actual secret key
  let secret_key = ""
  
  let client_result = 
    client.new_options()
    |> client.with_credentials("", secret_key)
    |> client.with_region("us-east-1")
    |> client.build_client()

  case client_result {
    Ok(client) -> {
      io.println("✅ Client created successfully!")
      
      // Test getting the sample item
      let get_request = new_get_item_request(
        "gleam-test-table",
        string_key("id", "test-user-123")
      )
      
      io.println("🔍 Attempting to get item with id: test-user-123")
      
      case get_item(client, get_request) {
        Ok(response) -> {
          io.println("Status: " <> int.to_string(response.status))
          io.println("Body length: " <> int.to_string(bit_array.byte_size(response.body)))
          
          // Try to convert body to string to see the response
          case bit_array.to_string(response.body) {
            Ok(body_string) -> io.println("Response body: " <> body_string)
            Error(_) -> io.println("Could not convert response body to string")
          }
        }
        Error(err) -> {
          io.println("❌ Error occurred:")
          io.println(handle_error(err))
        }
      }
    }
    Error(msg) -> {
      io.println("❌ Client creation failed: " <> msg)
    }
  }
}
