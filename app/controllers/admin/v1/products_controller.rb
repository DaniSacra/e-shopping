module Admin::V1
  class ProductsController < ApiController
    before_action :load_product, only: %i(update destroy)
    
    def index
      @products = load_products
    end

    def create
      @product = Product.new
      @product.attributes = product_params
    end

    def update
      @product.attributes = product_params
      save_product!
    end

    def destroy
      @product.destroy!
    rescue
      render_error(fields: @product.errors.messages)
    end

    private

    def load_product
      @product = Product.find(params[:id])
    end

    def save_product!
      @product.save!
      render :show
    rescue
      render_error(fields: @product.errors.messages)
    end

    def load_products
      Product.all
    end

    def run_service
      @saving_service = Admin::ProductSavingService.new(product_params.to_h, @product)
      @saving_service.call
      @product = @saving_service.product
      render :show
    end

    def product_params
      return {} unless params.has_key?(:product)
      permitted_params = params.require(:product).permit(:id, :name, :description, :image, :price, :productable)
      permitted_params.merge(productable_params)
    end

    def productable_params
      productable_type = params[:product][:productable] || @product&.productable_type&.underscore
      return unless productable_type.present?
      productable_attributes = send("#{productable_type}_params")
      { productable_attributes: productable_attributes }
    end

    def game_params
      params.require(:product).permit(:mode, :release_date, :developer, :system_requirement_id)
    end
  end
end