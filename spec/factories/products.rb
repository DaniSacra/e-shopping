FactoryBot.define do
  factory :product do
    price { Faker::Commerce.price(range: 100.0..400.0) }
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/product_image.png")) }

    after :build do |product|
      product.productable = create(:game)
    end
  end
end
