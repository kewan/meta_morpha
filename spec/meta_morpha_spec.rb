require 'meta_morpha'

# Example implimentation
module Shop
  class Product
    include MetaMorpha

    field :title, source: "og:title", type: :string
    field :not_found, source: 'somejunk', type: :string, default: 'nothingfound'
    field :example do |doc|
      doc.at("#example").text.to_s
    end

  end
end


describe MetaMorpha do

  before(:each) do
    @product = Shop::Product.new
    file = File.read(File.expand_path('../examples/opengraph.html', __FILE__))

    @product.parse(file)
  end

  describe "field" do

    it "maps the field" do
      fields = @product.class.instance_variable_get(:@mapped_fields)
      expect(fields.count).to eq 3
      expect(fields).to have_key(:title)
      expect(fields).to have_key(:not_found)
      expect(fields).to have_key(:example)
    end

  end

  describe "parse" do

    it "finds meta using source" do
      expect(@product.title).to eq "This is the open graph title"
    end

    it "uses default if meta not found" do
      expect(@product.not_found).to eq "nothingfound"
    end

    it "uses gets value from block" do
      expect(@product.example).to eq "This is the example"
    end

  end

  describe "to_hash" do

    it "converst mapped fileds to hash" do
      product_hash = @product.to_hash
      expect(product_hash.count).to eq 3
      expect(product_hash[:title]).to eq @product.title
      expect(product_hash[:not_found]).to eq @product.not_found
      expect(product_hash[:example]).to eq @product.example
    end

  end

end
