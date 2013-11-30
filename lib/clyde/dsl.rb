
module Clyde
  class Dsl
    class << self
      def hosts(*args)
        Clyde.hosts = args
      end

      def paths(args)
        Clyde.paths = args
      end

      def before(matcher = :each, &block)
        Clyde.add_before_hook(:each, &block) if matcher == :each
      end
    end
  end
end

