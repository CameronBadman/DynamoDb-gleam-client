import dynamo/client
import dynamo/types/error.{handle_error}
import gleam/io
import gleam/int
import gleam/bit_array
import dynamo/builders/get.{get_req, with_consistent_read, exec}

pub fn main() {
  let access_key = ""
  let secret_key = ""
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
  
  let get_req = client 
    |> get_req("gleam-test-table", "id", "test-user-123")
    |> with_consistent_read(True)
    |> exec()
  
  case get_req {
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
