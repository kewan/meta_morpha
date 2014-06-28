require 'meta_morpha'

# Example implimentation
module Shop
  class Product
    include MetaMorpha

    field :title, property: "og:title", type: :string
    field :not_found, property: 'somejunk', type: :string, default: 'nothingfound'
    field :example do |selector|
      selector.doc.at("#example").text.to_s
    end
    field :no_type, property: 'og:image'
    field :no_default, property: 'somethingthatdoesnotexist'

  end
end


describe MetaMorpha do

  before(:each) do
    @product = Shop::Product.new
    file = File.read(File.expand_path('../examples/opengraph.html', __FILE__))

    @doc = Nokogiri::HTML.parse(file)
    @product.parse(@doc)
  end

  describe "field" do

    it "maps the field" do
      fields = @product.class.instance_variable_get(:@mapped_fields)
      expect(fields.count).to eq 5
      expect(fields).to have_key(:title)
      expect(fields).to have_key(:not_found)
      expect(fields).to have_key(:example)
      expect(fields).to have_key(:no_type)
      expect(fields).to have_key(:no_default)
    end

  end

  describe "parse" do

    it "finds meta using property" do
      expect(@product.title).to eq "This is the open graph title"
    end

    it "uses default if meta not found" do
      expect(@product.not_found).to eq "nothingfound"
    end

    it "uses gets value from block" do
      expect(@product.example).to eq "This is the example"
    end

    it "finds meta even when no type is set" do
      expect(@product.no_type).to eq "http://example.com/prod.jpg"
    end

    it "returns nil for unfound meta if no default" do
      expect(@product.no_default).to be_nil
    end

    it "will only parse selected fields if supplied" do
      prod = Shop::Product.new
      prod.parse(@doc, [:title])
      expect(prod.title).to eq "This is the open graph title"
      [:not_found, :example, :no_type, :no_default].each do |m|
        expect(prod.send(m)).to be_nil
      end
    end

    it "will ignore supplied fields that do not exist" do
      prod = Shop::Product.new
      prod.parse(@doc, [:title, :monkey])
      expect(prod.title).to eq "This is the open graph title"
    end
  end

  describe "to_hash" do

    it "converst mapped fileds to hash" do
      product_hash = @product.to_hash
      expect(product_hash.count).to eq 5
      expect(product_hash[:title]).to eq @product.title
      expect(product_hash[:not_found]).to eq @product.not_found
      expect(product_hash[:example]).to eq @product.example
      expect(product_hash[:no_type]).to eq @product.no_type
      expect(product_hash[:no_default]).to eq @product.no_default
    end

  end

end
