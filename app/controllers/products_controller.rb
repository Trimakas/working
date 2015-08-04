class ProductsController < AuthenticatedController

respond_to :html, :js
  
  def index
    @products = Product.search(params[:search]).paginate(page: params[:page], per_page: 4)
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
    #binding.pry
  end

  def update
    @products = Product.all
    @product = Product.find(params[:id])
    @product.update_attributes(product_params)
    redirect_to root_path
  end

  def delete
    @product = Product.find(params[:product_id])
  end

  def destroy
    @products = Product.all
    @product = Product.find(params[:id])
    @product.destroy
  end

    private
      def product_params
        params.require(:product).permit(:title, :asin, :price, :sellersku)
      end
end