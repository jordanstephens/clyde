require "colored"

module Clyde
  module Utils

    def exit_normal
      Kernel.exit(0)
    end

    def log(str, opts = {})
      opts[:color] ||= :yellow
      puts str.send(opts[:color]) unless Clyde.quiet
    end
  end
end
