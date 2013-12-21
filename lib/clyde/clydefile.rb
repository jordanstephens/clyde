
module Clyde
  module Clydefile
    TEMPLATE_PATH = File.expand_path("../templates/Clydefile", __FILE__)
    class << self

      attr_accessor :path

      def evaluate(path)
        @path = path
        @clydefile_contents = File.read(@path)
        Clyde::Dsl.instance_eval @clydefile_contents
      end

      def generate(path = nil)
        path ||= Clyde.clydefile
        unless File.exists?(path)
          FileUtils.mkdir_p(File.dirname(path))
          FileUtils.cp(TEMPLATE_PATH, path)
        end
      end
    end
  end
end
