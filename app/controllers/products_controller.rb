class ProductsController < AuthenticatedController

  respond_to :html, :js
  include Reports

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
    redirect_to merchant_path(@merchant)
  end

  def push_to_shopify
    #push the products to shopify..
    redirect_to root_path
  end

    private
      def product_params
        params.require(:product).permit(:title, :asin, :price, :sellersku, :id, :merchant_identifier)
      end
end