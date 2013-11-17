
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
        if matcher == :each
          before_each(&block)
        end
      end

      def before_each(&block)
        Clyde.add_before_hook(:each, &block)
      end
    end
  end
end
