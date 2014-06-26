require "rest_client"
require "nokogiri"
require "meta_morpha/version"
require "meta_morpha/module_inheritable_attributes"
require "meta_morpha/field"

module MetaMorpha

  def self.fetch(uri)
    parse(RestClient.get(uri).body)
  rescue RestClient::Exception, SocketError
    false
  end

  def parse(html)
    doc = Nokogiri::HTML.parse(html)
    fields = self.class.instance_variable_get(:@mapped_fields)
    fields.each_value do |field|
      send("#{field.to}=", field.map(doc))
    end
    self
  end

  def to_hash
    fields = self.class.instance_variable_get(:@mapped_fields)
    values = Hash.new
    fields.each_value do |field|
      values[field.to.to_sym] = send("#{field.to}")
    end
    values
  end

  def self.included(base)
    base.extend ClassMethods
    base.send :include, MetaMorpha::ModuleInheritableAttributes
    base.send(:mattr_inheritable, :mapped_fields)
    base.instance_variable_set "@mapped_fields", {}
  end

  module ClassMethods
    def field(to, options={}, &block)
      from    = options[:property]
      type    = options[:type]
      default = options[:default]

      # create a getter/setter
      attr_accessor to

      # Add to class instance variable
      @mapped_fields[to] = Field.new(to, from, type, default, &block)
    end

  end

end

# rails hook app/mats dir
require 'meta_morpha/rails' if defined?(::Rails::Engine)
