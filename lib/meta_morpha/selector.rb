module MetaMorpha
  class Selector

    attr_accessor :doc

    def initialize(doc)
      raise "Not nokogiri doc" unless doc.is_a? Nokogiri::HTML::Document
      @doc = doc
    end

    def exact(selectors)
      find(selectors) do |query|
        "//meta[@*=\"#{query}\"]"
      end
    end

    def starts_with(selectors)
      find(selectors) do |q|
        "//meta[starts-with(@*, \"#{q}\")]"
      end
    end

    def ends_with(selectors)
      find(selectors) do |q|
        "//meta[contains(substring(@*, string-length(@*) - #{q.length}), \"#{q}\")]"
      end
    end

    def contains(selectors)
      find(selectors) do |q|
        "//meta[contains(@*, \"#{q}\")]"
      end
    end

    def find(selectors)
      raise "Find called without query block" unless block_given?
      selectors = [selectors] if selectors.is_a? String

      metas = []
      selectors.collect do |selector|
        query = yield selector
        metas = @doc.xpath(query)
        break unless metas.nil?
      end

      values = metas.collect do |meta|
        value = meta.attribute('content').to_s.strip
        value = meta.attribute('value').to_s.strip if value.empty?
        value
      end

      values
    end
  end
end
