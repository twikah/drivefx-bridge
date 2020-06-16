require 'net/http'
require 'uri'
require 'json'

class FetchDriveFxService
  # Generate DriveFx API access token
  def generate_access_token
    uri = URI.parse('https://interface.phcsoftware.com/v3/generateAccessToken')
    header = { 'Content-Type': 'application/json' }
    credentials =
      { "credentials": {
          "backendUrl": ENV['DFX_BEND_URL'],
          "appId": ENV['DFX_APP_ID'],
          "userCode": ENV['DFX_USERCODE'],
          "password": ENV['DFX_PASSWORD'],
          "company": '',
          "tokenLifeTime": 'Never'
      } }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = credentials.to_json

    # Send the request
    response = http.request(request)
    token_serialized = JSON.parse response.read_body
    token = token_serialized["token"]
  end
end
