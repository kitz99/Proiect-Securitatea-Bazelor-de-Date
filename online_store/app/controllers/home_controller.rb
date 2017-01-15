class HomeController < ApplicationController
  skip_before_action :check_login_user, only: [:index]
  def index
    @products = Product.all.paginate(:page => params[:page], :per_page => 15)
  end
end