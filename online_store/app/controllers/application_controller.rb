class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def check_login_user
    unless current_user.present?
      redirect_to "/"
    end
  end
end
