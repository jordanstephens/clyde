
module Clyde
  module Hooks
    class Hook
      attr_reader :key, :proc
      def initialize(key, &block)
        raise ArgumentError, "Block required" unless block_given?

        unless key == :each || key.is_a?(Regexp)
          raise ArgumentError, "First arg should be a Regexp or `:each`"
        end

        @key = key
        @proc = block
      end
    end
  end
end
