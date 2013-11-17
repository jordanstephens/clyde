
module Clyde
  module Clydefile
    class << self
      attr_accessor :path

      def evaluate(path)
        @path = path
        @clydefile_contents = File.read(@path)
        Clyde::Dsl.instance_eval @clydefile_contents
      end
    end
  end
end
