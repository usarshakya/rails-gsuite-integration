require 'google/api_client'

class GoogleServiceAccount  
  def initialize(person:nil, scopes:)
    @person = person
    @scopes = scopes
  end

  def authorized_client
    @client = Google::APIClient.new(application_name: "receptionist")
    authorizer = Signet::OAuth2::Client.new(client_secret)
    @client.authorization = authorizer
    @client.authorization.fetch_access_token!
    @client
  end

  private  

  attr_reader :person

  def signing_key
    @signing_key = Google::APIClient::KeyUtils.load_from_pkcs12(ENV['GSA_KEY_FILE'], ENV['GSA_KEY_SECRET'])
  end

  def client_secret
    {
      signing_key: signing_key,
      token_credential_uri: "https://accounts.google.com/o/oauth2/token",
      audience: "https://accounts.google.com/o/oauth2/token",
      issuer: ENV["GSA_CLIENT_EMAIL"],
      person: person,
      scope: @scopes
    }
  end
end  