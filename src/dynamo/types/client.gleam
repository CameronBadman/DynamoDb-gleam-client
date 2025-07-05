import aws4_request

pub type DynamoClient {
  DynamoClient(
    signer: aws4_request.Signer,
    access_key_id: String,
    secret_access_key: String,
    region: String,
    domain: String,
  )
}
