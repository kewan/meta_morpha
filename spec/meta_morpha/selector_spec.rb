require 'meta_morpha/selector'
require 'nokogiri'

describe MetaMorpha::Selector do

  before(:each) do
    file = File.read(File.expand_path('../../examples/metas.html', __FILE__))
    html = Nokogiri::HTML.parse(file)
    @selector = MetaMorpha::Selector.new(html)
  end

  it "should raise an exception if not nokogiri" do
    expect {
      MetaMorpha::Selector.new("monkey")
    }.to raise_error "Not nokogiri doc"
  end

  context "#exact" do

    it "should match exact for string" do
      expect(@selector.exact("og:title")).to eq "This is the title"
    end

    it "should match exact for array and select first match" do
      expect(@selector.exact(["one", "two"])).to eq "One"
      expect(@selector.exact(["two", "one"])).to eq "Two"
    end

    it "should not find not exact matches" do
      expect(@selector.exact("starts")).to be_nil
    end

  end

  context "#starts_with" do

    it "should find element with attribute starting with param" do
      expect(@selector.starts_with("starts")).to eq "Starts with"
    end

  end

  context "#ends_with" do

    it "should find element with attribute ending with param" do
      expect(@selector.ends_with("ends-with")).to eq "Ends with"
    end

  end

  context "#contains" do

    it "should find element with attribute containing param" do
      expect(@selector.contains("fuzzy")).to eq "This is contains fuzzy"
    end

  end
end
