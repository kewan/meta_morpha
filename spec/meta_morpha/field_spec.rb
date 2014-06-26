require 'meta_morpha/field'
require 'nokogiri'

describe MetaMorpha::Field do

  before(:each) do
    file = File.read(File.expand_path('../../examples/opengraph.html', __FILE__))
    @html = Nokogiri::HTML.parse(file)
  end

  describe "map" do

    it "maps to a meta tag property" do
      field = MetaMorpha::Field.new(:name, 'og:title', :string, "")
      expect(field.map(@html)).to eq "This is the open graph title"
    end

    it "maps using block" do
      field = MetaMorpha::Field.new(:title, 'title', :string, '') { |doc| doc.at("title").content }
      expect(field.map(@html)).to eq "Title from html"
    end

    it "maps using a complex block" do
      field = MetaMorpha::Field.new(:prices) do |doc|
        amounts = doc.css('meta[property="og:price:amount"]').map {|m| m.attribute('content').to_s }
        currencies = doc.css('meta[property="og:price:currency"]').map {|m| m.attribute('content').to_s }

        prices = []
        amounts.count.times do |i|
          prices[i] = Hash[currency: currencies[i], amount: amounts[i]]
        end

        prices
      end
      expect(field.map(@html)).to eq [
          {:currency=>"GBP", :amount=>"319.99"},
          {:currency=>"USD", :amount=>"369.99"}
      ]
    end

    it "maps to default if not found" do
      field = MetaMorpha::Field.new(:name, 'somejunkmeta', :string, "notfound")
      expect(field.map(@html)).to eq "notfound"
    end

    it "maps to nil if not found with no default" do
      field = MetaMorpha::Field.new(:name, 'somejunkmeta')
      expect(field.map(@html)).to be_nil
    end
  end

end
