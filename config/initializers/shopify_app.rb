ShopifyApp.configure do |config|
  config.application_name = "DriveFx Bridge"
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.old_secret = ""
  # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.scope = "read_products, write_products, read_product_listings, read_orders, write_orders, read_inventory, write_inventory, read_locations, read_checkouts, write_checkouts, read_reports, write_reports" # Consult this page for more scope options:
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2020-04"
  config.shop_session_repository = 'Shop'
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known
