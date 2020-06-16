# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    # @inventory = ShopifyAPI::Inventory.find(:all)
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end
end
