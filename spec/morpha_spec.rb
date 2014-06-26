require 'morpha'

# Example implimentation
module Shop
  class Product
    include Morpha

    field :title, source: "og:title", type: :string
    field :not_found, source: 'somejunk', type: :string, default: 'nothingfound'
    field :example do |doc|
      doc.at("#example").text.to_s
    end

  end
end


describe Morpha do

  before(:each) do
    @product = Shop::Product.new
    file = File.read(File.expand_path('../examples/opengraph.html', __FILE__))

    @product.parse(file)
  end

  describe "field" do

    it "maps the field" do
      fields = @product.class.instance_variable_get(:@mapped_fields)
      fields.count.should eq 3
      fields.should have_key(:title)
      fields.should have_key(:not_found)
      fields.should have_key(:example)
    end

  end

  describe "parse" do

    it "finds meta using source" do
      @product.title.should eq "This is the open graph title"
    end

    it "uses default if meta not found" do
      @product.not_found.should eq "nothingfound"
    end

    it "uses gets value from block" do
      @product.example.should eq "This is the example"
    end

  end

  describe "to_hash" do

    it "converst mapped fileds to hash" do
      product_hash = @product.to_hash
      product_hash.count.should eq 3
      product_hash[:title].should eq @product.title
      product_hash[:not_found].should eq @product.not_found
      product_hash[:example].should eq @product.example
    end

  end

end
