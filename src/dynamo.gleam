import dynamo/builders/get.{
  exec, get_req, with_composite_key, with_consistent_read, with_projection,
}
import dynamo/client
import dynamo/types/error.{handle_error}
import gleam/bit_array
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

  let get_result =
    client
    |> get_req("gleam-test-table", "id", "test-user-123")
    |> with_composite_key("id", "test-user-123")
    |> with_consistent_read(True)
    |> with_projection("id, email")
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
