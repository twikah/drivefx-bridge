# frozen_string_literal: true

# Methods used to access Shopify API
class ShopifyService
  def set_shopify_session
    @shop = Shop.find_by(shopify_domain: 'drivefx-dev.myshopify.com')
    @session = ShopifyAPI::Session.new(
      domain: 'drivefx-dev.myshopify.com',
      token: @shop.shopify_token,
      api_version: '2020-04'
    )
    ShopifyAPI::Base.activate_session(@session)
  end

  def get_shopify_variants
    ShopifyAPI::Variant.find(:all)
  end

  def save_shopify_ids
    puts 'Fetching products from Shopify...'
    @variants = get_shopify_variants

    @variants.each do |variant|
      sfy_existing_product = Product.where(dfx_ref: variant.sku).first

      product_variant = {
        sfy_variant_id: variant.id,
        sfy_variant_sku: variant.sku,
        sfy_variant_prod_id: variant.product_id,
        sfy_variant_inventory_id: variant.inventory_item_id,
        sfy_variant_inventory_qty: variant.inventory_quantity,
        sft_variant_inventory_old_qty: variant.sft_variant_inventory_old_qty
      }

      if sfy_existing_product.present?
        puts "Product with sku #{variant.sku} exists, updating..."
        sfy_existing_product.update(product_variant)
      else
        puts "Product with sku #{variant.sku} does not exist, creating..."
        dfx_update = {
          dfx_ref: variant.sku
        }
        product_variant.merge!(dfx_update)
        Product.create!(product_variant)
      end
    end
  end
end
