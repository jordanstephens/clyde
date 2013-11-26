require "colored"

module Clyde
  module Utils

    def exit_normal
      Kernel.exit(0)
    end

    def log(str)
      puts str.yellow unless Clyde.quiet
    end
  end
end
