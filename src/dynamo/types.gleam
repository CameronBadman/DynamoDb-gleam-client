import gleam/httpc

pub type AttributeValue {
  String(String)
  Number(String)
  Boolean(Bool)
  Null
}

pub type DynamoError {
  ValidationError(String)
  ResourceNotFoundError(String)
  UnknownError(String)
  HttpError(httpc.HttpError)
  UriError
  RequestBuildError
}

pub fn handle_error(error: DynamoError) -> String {
  case error {
    ValidationError(msg) -> "Validation error: " <> msg
    ResourceNotFoundError(msg) -> "Resource not found: " <> msg
    UnknownError(msg) -> "Unknown error: " <> msg
    HttpError(httpc.InvalidUtf8Response) -> "Invalid UTF-8 in response"
    HttpError(httpc.FailedToConnect(_, _)) -> "Failed to connect"
    UriError -> "Invalid URI"
    RequestBuildError -> "Failed to build request"
  }
}

pub type DynamoClient {
  DynamoClient(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    domain: String,
  )
}





