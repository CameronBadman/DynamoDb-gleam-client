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


pub type DynamoClient {
  DynamoClient(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    domain: String,
)
}

pub opaque type DynamoClientOptions {
  DynamoClientOptions(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    domain: String, // for custom endpoints
  )
}

pub fn new_options() -> DynamoClientOptions {
  DynamoClientOptions(
    access_key_id: "",
    secret_access_key: "",
    region: "",
    domain: "amazonaws.com",
  )
}

pub fn with_credentials(
  options: DynamoClientOptions,
  access_key_id: String,
  secret_access_key: String) -> DynamoClientOptions {
    DynamoClientOptions(..options, access_key_id:, secret_access_key:)
  }

pub fn with_region(options: DynamoClientOptions, region: String) -> DynamoClientOptions {
  DynamoClientOptions(..options, region:)
}

pub fn with_domain(options: DynamoClientOptions, domain: String) -> DynamoClientOptions {
  DynamoClientOptions(..options, domain:)
}

pub fn build_client(options: DynamoClientOptions) -> Result(DynamoClient, String) {
 case options.access_key_id, options.secret_access_key, options.region {
   "", _, _ -> Error("access key ID is required")
   _, "", _ -> Error("secret access key is required")
   _, _, "" -> Error("region is required")
   access_key_id, secret_access_key, region ->
     Ok(DynamoClient(
       access_key_id:,
       secret_access_key:,
       region:,
       domain: options.domain,
     ))
 }
}








