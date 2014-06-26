require 'morpha/field'

describe Morpha::Field do

  before(:each) do
    @data = {
      'SomeName'   => 'SomeValue',
      'product_id' => '1234',
      'ImageUrl'   => 'http://www.example.com/this.jpg'
    }
  end

  describe "map" do

    it "maps to a field that exists in the supplied data" do
      field = Morpha::Field.new(:name, 'SomeName', :string, "")
      field.map(@data).should eq @data['SomeName']
    end

    it "maps to default if not supplied in data" do
      field = Morpha::Field.new(:currency, 'Currency', :string, 'GBP')
      field.map(@data).should eq 'GBP'
    end

    it "maps to the supplied type" do
      field = Morpha::Field.new(:id, 'product_id', :integer)
      field.map(@data).should eq @data['product_id'].to_i
    end

    it "maps to the suppied field using a block to determine value" do
      field = Morpha::Field.new(:image_url, 'ImageUrl', :string, '') { |url| url.gsub!(/example/, 'monkey') }
      field.map(@data).should eq 'http://www.monkey.com/this.jpg'
    end

  end

end
