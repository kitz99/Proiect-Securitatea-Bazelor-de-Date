class Product < ActiveRecord::Base
  mount_uploader :image, ProductUploader
end