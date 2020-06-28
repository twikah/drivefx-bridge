# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# Methods used to access and fetch records from DriveFx API
class FetchDriveFxService
  def initialize
    @token = nil
    @token_lock = Mutex.new
  end

  # Gets all the products on 'armazem 1'
  def fetch_warehouse_products
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
          }]
        }
      }

    # Calls the fetch method to call the API and fetches products
    response_serialized = fetch(search_params)
    response_serialized['entities']
  end

  # Gets the product details for a specific product reference
  def fetch_product_details(product_ref)
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
          'limit': 20
        }
      }

    # Calls the fetch method to call the API and fetches specific product
    response_serialized = fetch(search_params)
    # Returns the details of the specific product or nil if response_serialized
    # is nil
    response_serialized && response_serialized['entities']
  end

  # Method that fetches records from the DriveFx API
  def fetch(search_params)
    token = fetch_auth_token
    # Raises an error if the API token is missing
    raise 'Missing API access token' if token.empty?

    # POST request details
    uri = URI.parse('https://interface.phcsoftware.com/v3/searchEntities')
    header =
      { 'Content-Type': 'application/json',
        'Authorization': token }

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
    JSON.parse response.read_body
  end

  private

  # Generates DriveFx API Access Token
  def fetch_auth_token
    @token_lock.synchronize {
      return @token unless @token.nil?
      @token ||= generate_auth_token
    }
  end

  def generate_auth_token
    # Raises an error if any of the required credentials are missing
    env_vars = [
      ENV['DFX_BEND_URL'], ENV['DFX_APP_ID'], ENV['DFX_USERCODE'], ENV['DFX_PASSWORD']
    ]

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

    # Calls the API
    response_serialized = api_call(uri, header, credentials)
    # Returns the Access Token
    response_serialized['token']
  end
end
