class AdminController < ApplicationController
  @total_orders = Order.count

  def index
  end
end
