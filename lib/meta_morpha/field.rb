module MetaMorpha
  class Field

    attr_accessor :to

    VALID_TYPES = {
      :string  => :to_s,
      :integer => :to_i,
      :float   => :to_f
    }

    def initialize(to, from=nil, type=nil, default=nil, &conversion)
      @to = to.to_s
      @from = from
      @type = type
      @default = default
      @conversion = conversion
    end

    def map(html)
      @html = html

      if(@conversion)
        return @conversion.call(@html)
      elsif(@from)
        return convert_value(@from)
      else
        return @default;
      end

    end

    private

      def find_meta_value(raw_value)
        meta = @html.at("meta[property=\"#{raw_value}\"]")
        meta ? meta.attribute('content').to_s : @default
      end

      def convert_value(raw_value)
        value = find_meta_value(raw_value)
        if VALID_TYPES.has_key?(@type)
          value.send(VALID_TYPES[@type])
        end
        value
      end

  end
end
