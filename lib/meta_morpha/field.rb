require 'meta_morpha/selector'

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
      @selector = MetaMorpha::Selector.new(html)

      if(@conversion)
        return @conversion.call(@selector)
      elsif(@from)
        return convert_value(@from)
      else
        return @default;
      end

    end

    private

      def convert_value(raw_value)
        values = @selector.exact(raw_value)
        value = values.empty? ? @default : values.first
        if VALID_TYPES.has_key?(@type)
          value.send(VALID_TYPES[@type])
        end
        value
      end

  end
end
