require 'net/http'
require 'uri'
require 'json'

class FetchDriveFxService
  # Generate DriveFx API access token
  def generate_access_token
    # Raise error if any of the required credentials are missing
    env_vars = [ENV['DFX_BEND_URL'], ENV['DFX_APP_ID'], ENV['DFX_USERCODE'],
                ENV['DFX_PASSWORD']]
    raise 'Missing credentials' if env_vars.any? { |var| var.empty? }

    # POST request details
    uri = URI.parse('https://interface.phcsoftware.com/v3/generateAccessToken')
    header = { 'Content-Type': 'application/json' }
    credentials =
      { 'credentials': {
          'backendUrl': ENV['DFX_BEND_URL'],
          'appId': ENV['DFX_APP_ID'],
          'userCode': ENV['DFX_USERCODE'],
          'password': ENV['DFX_PASSWORD'],
          'company': '',
          'tokenLifeTime': 'Never'
      } }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = credentials.to_json

    # Send the request
    response = http.request(request)
    token_serialized = JSON.parse response.read_body

    # Return token as string
    token_serialized['token']
  end

  # Get all the products on 'armazem 1'
  def fetch_warehouse_products(generate_access_token)
    # Raise an error if the API token is missing
    raise 'Missing API access token' if generate_access_token.empty?

    # POST request details
    uri = URI.parse('https://interface.phcsoftware.com/v3/searchEntities')
    header =
      { 'Content-Type': 'application/json',
        'Authorization': generate_access_token }
    search_params =
      {
        'queryObject': {
          'distinct': false,
          'entityName': 'Sa',
          'filterCod': '',
          'filterItems': [{
            'filterItem': 'armazem',
            'comparison': 0,
            'valueItem': 1,
            'groupItem': 0
          }],
        'offset': 0,
        'orderByItems': [],
        'SelectItems': []
        }
      }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = search_params.to_json

    # Send the request
    response = http.request(request)
    warehouse_serialized = JSON.parse response.read_body

    # Return array of all products on 'armazem 1'
    warehouse_serialized['entities']
  end
end
