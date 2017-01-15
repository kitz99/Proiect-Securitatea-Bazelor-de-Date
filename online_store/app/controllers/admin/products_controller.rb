class Admin::ProductsController < ::ApplicationController
  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_update_params)
      redirect_to('/dashboard')
    else
      render 'edit'
    end
  end

  private 

  def product_update_params
    params.require(:product).permit(:name, :price, :image)
  end
end