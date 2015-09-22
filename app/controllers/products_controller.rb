class ProductsController < AuthenticatedController

  respond_to :html, :js
  include Reports
  include Send

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @products = Product.all
    @product = Product.create(product_params)
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @products = Product.all
    @product = Product.find(params[:id])
    @merchant = @product.merchant
    @product.update_attributes(product_params)
    redirect_to merchant_path(@merchant)
  end

  def delete
    @product = Product.find(params[:product_id])
  end

  def destroy
    @product = Product.find(params[:id])
    @merchant = @product.merchant
    @product.destroy

  end

  def push_to_shopify
    domain = Rails.cache.read("domain")
    shop = Shop.find_by(shopify_domain: domain)
    token = shop.shopify_token
    sesh = ShopifyAPI::Session.new(domain, token)
    SessionStorage.store(sesh)
    Product.push_it(params[:sellersku], domain, token)
    redirect_to merchant_path(shop.merchant_id)
  end

    private
      def product_params
        params.require(:product).permit(:title, :asin, :price, :sellersku, :id, :merchant_identifier)
      end
end