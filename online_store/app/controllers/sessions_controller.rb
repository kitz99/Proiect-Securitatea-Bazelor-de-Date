class SessionsController < Devise::SessionsController
  skip_before_action :check_login_user
end