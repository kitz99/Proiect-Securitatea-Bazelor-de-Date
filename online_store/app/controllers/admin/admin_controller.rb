class Admin::AdminController < ::ApplicationController
  before_action :check_is_admin

  private
  def check_is_admin
    unless current_user.is_admin?
      redirect_to '/'
    end
  end
end