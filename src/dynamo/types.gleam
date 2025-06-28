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
  //httpc errors
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




pub opaque type DynamoClientOptions {
  DynamoClientOptions(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    timeout: Int,
    domain: Option(String), // for custom endpoint
  )
}

pub fn new_options() -> DynamoClientOptions {
  DynamoClientOptions(
    access_key_id: "",
    secret_access_key: "",
    region: "",
    domain: None,
  )
}

pub fn with_credentials(
  options: DynamoClientOptions,
  access_key_id: String,
  secret_access_key: String)
  -> DynamoClientOptions(..options, access_key_id:, secret_access_key:) {
    DynamoClientOptions(..options, access_key_id, secret_access_key)
  }

pub fn with_region(options: DynamoClientOptions, region: String) {
  DynamoClientOptions(options, region)
}

pub fn with_domain(otpions: DynamoClientOptions, domain) {



}










