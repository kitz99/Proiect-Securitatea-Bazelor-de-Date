class Admin::DashboardController < ::ApplicationController
  before_action :check_login_user
  def index
    @users = User.all
    @products = Product.all.order(:id)
  end
end