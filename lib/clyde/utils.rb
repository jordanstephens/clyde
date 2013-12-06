require "colorize"

module Clyde
  module Utils

    def exit_normal
      Kernel.exit(0)
    end

    def log(str, opts = {})
      opts[:color] ||= :default
      puts str.colorize(opts[:color]) unless Clyde.quiet
    end
  end
end
