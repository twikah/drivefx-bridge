# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# Methods used to save records provenient from DriveFx API calls
class DriveFxRepoService
  def initialize
    @fetch_service = FetchDriveFxService.new
  end

  def save_products
    puts 'Fetching products from warehouse 1...'

    warehouse_products = @fetch_service.fetch_warehouse_products
    wh_products_lock = Mutex.new

    wh_product_threads = (0..3).collect do |tid|
      Thread.new do
        begin
          wh_product = nil

          loop do
            wh_products_lock.synchronize {
              wh_product = warehouse_products.pop
            }

            break if wh_product.nil?

            puts "Thread #{tid} fetching details for ref #{wh_product['ref']}..."

            existing_product = Product.where(dfx_ref: wh_product['ref']).first

            next if existing_product.present? &&
                    existing_product.dfx_family != 'Artigos de Padel'

            product = {
              dfx_ref: wh_product['ref'],
              dfx_stock: wh_product['stock']
            }

            product_detail = @fetch_service.fetch_product_details(wh_product['ref'])

            next if product_detail.nil? || product_detail.empty?

            details = {
              dfx_color: product_detail[0]['u6525_cores_tamanhos']['cor'],
              dfx_size: product_detail[0]['u6525_cores_tamanhos']['tamanho'],
              dfx_gender: product_detail[0]['u6526_extra_campos_paddel']['genero'],
              dfx_origin_ref: product_detail[0]['u6525_cores_tamanhos']['ref_principal'],
              dfx_title: product_detail[0]['design'],
              dfx_vendor: product_detail[0]['usr1'],
              dfx_type: product_detail[0]['usr2'],
              dfx_price_1: product_detail[0]['epv1comiva'],
              dfx_price_2: product_detail[0]['epv2comiva'],
              dfx_vat_included_1: product_detail[0]['iva1incl'],
              dfx_vat_included_2: product_detail[0]['iva2incl'],
              dfx_cost_price: product_detail[0]['epcusto'],
              dfx_family: product_detail[0]['faminome'],
              dfx_barcode: product_detail[0]['codigo'],
              dfx_net_weight: product_detail[0]['pluni'],
              dfx_description: product_detail[0]['desctec']
            }

            product.merge!(details)

            if existing_product.present?
              puts "Product with ref #{wh_product['ref']} exists, updating..."
              existing_product.update(product)
            else
              puts "Product with ref #{wh_product['ref']} does not exist, creating..."
              Product.create!(product)
            end
          end
        rescue Net::ReadTimeout => e
          puts "error: #{e} for ref #{wh_product['ref']}"
        end
      end
    end

    puts 'All products fetched and saved.'
    wh_product_threads.each(&:join)
  end
end
