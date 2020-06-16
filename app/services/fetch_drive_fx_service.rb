require 'net/http'
require 'uri'
require 'json'

class FetchDriveFxService
  # Generates DriveFx API Access Token
  def generate_access_token
    # Raises an error if any of the required credentials are missing
    env_vars = [ENV['DFX_BEND_URL'], ENV['DFX_APP_ID'], ENV['DFX_USERCODE'],
                ENV['DFX_PASSWORD']]
    raise 'Missing credentials' if env_vars.any?(&:empty?)

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

    # Calls the API and returns the Access Token
    api_call(uri, header, credentials)
  end

  # Gets all the products on 'armazem 1'
  def fetch_warehouse_products(generate_access_token)
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

    # Calls the fetch method to call the API and fetches products
    fetch(generate_access_token, search_params)
  end

  # Gets the product details for a specific product reference
  def fetch_product_details(generate_access_token, product_ref)
    search_params =
      {
        'queryObject': {
          'distinct': false,
          'entityName': 'St',
          'filterCod': '',
          'filterItems': [{
            'filterItem': 'ref',
            'comparison': 0,
            'valueItem': product_ref,
            'groupItem': 0
          }],
          'limit': 20,
          'offset': 0,
          'orderByItems': [],
          'SelectItems': []
        }
      }

    # Calls the fetch method to call the API and fetches specific product
    fetch(generate_access_token, search_params)
  end

  # Method that fetches records from the DriveFx API
  def fetch(generate_access_token, search_params)
    # Raises an error if the API token is missing
    raise 'Missing API access token' if generate_access_token.empty?

    # POST request details
    uri = URI.parse('https://interface.phcsoftware.com/v3/searchEntities')
    header =
      { 'Content-Type': 'application/json',
        'Authorization': generate_access_token }

    api_call(uri, header, search_params)
  end

  # Method that calls the DriveFx API
  def api_call(uri, header, search_params)
    # Creates the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = search_params.to_json

    # Sends the request
    response = http.request(request)
    response_serialized = JSON.parse response.read_body

    # Returns the elements of the last key-value pair of response's body
    response_serialized.values.last
  end
end
