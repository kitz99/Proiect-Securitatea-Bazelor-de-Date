namespace :import do
  desc "Create products"
  task :produts => [:environment] do
    products = JSON.parse(File.open(Rails.root.join('lib', 'assets', 'products.json'), 'r').read)
    products.each do |prod|
      p = Product.new(name: prod['name'], price: prod['price'])
      p.remote_image_url = prod['image_url']
      p.save
    end
  end
end