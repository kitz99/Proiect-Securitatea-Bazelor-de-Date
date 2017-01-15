class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_buyer_role

  def user_name
    email.split('@').first
  end

  def is_admin
    user.has_role?(:admin)
  end

  private

  def assign_buyer_role
    self.add_role(:buyer) if self.roles.blank?
  end
end
