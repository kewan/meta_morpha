require 'morpha/field'
require 'nokogiri'

describe Morpha::Field do

  before(:each) do
    file = File.read(File.expand_path('../../examples/opengraph.html', __FILE__))
    @html = Nokogiri::HTML.parse(file)
  end

  describe "map" do

    it "maps to a meta tag property" do
      field = Morpha::Field.new(:name, 'og:title', :string, "")
      field.map(@html).should eq "This is the open graph title"
    end

    it "maps using block" do
      field = Morpha::Field.new(:title, 'title', :string, '') { |doc| doc.at("title").content }
      field.map(@html).should eq "Title from html"
    end

    it "maps using a complex block" do
      field = Morpha::Field.new(:prices) do |doc|
        amounts = doc.css('meta[property="og:price:amount"]').map {|m| m.attribute('content').to_s }
        currencies = doc.css('meta[property="og:price:currency"]').map {|m| m.attribute('content').to_s }

        prices = []
        amounts.count.times do |i|
          prices[i] = Hash[currency: currencies[i], amount: amounts[i]]
        end

        prices
      end
      field.map(@html).should eq [
          {:currency=>"GBP", :amount=>"319.99"},
          {:currency=>"USD", :amount=>"369.99"}
      ]
    end

    it "maps to default if not found" do
      field = Morpha::Field.new(:name, 'somejunkmeta', :string, "notfound")
      field.map(@html).should eq "notfound"
    end
  end

end
