require "colorize"

module Clyde
  class Ghost
    def self.to_s
      n = " "
      y = " ".colorize(background: :yellow)
      w = " ".colorize(background: :white)
      b = " ".colorize(background: :blue)
      l = "\n"

      art = [
        n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, l,
        n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, l,
        n, n, n, n, n, n, n, n, n, n, n, n, n, n, y, y, y, y, y, y, y, y, n, n, n, n, n, n, n, n, n, n, l,
        n, n, n, n, n, n, n, n, n, n, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, n, n, n, n, n, n, l,
        n, n, n, n, n, n, n, n, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, n, n, n, n, l,
        n, n, n, n, n, n, y, y, w, w, w, w, y, y, y, y, y, y, y, y, w, w, w, w, y, y, y, y, y, y, n, n, l,
        n, n, n, n, n, n, w, w, w, w, w, w, w, w, y, y, y, y, w, w, w, w, w, w, w, w, y, y, y, y, n, n, l,
        n, n, n, n, n, n, b, b, b, b, w, w, w, w, y, y, y, y, b, b, b, b, w, w, w, w, y, y, y, y, n, n, l,
        n, n, n, n, y, y, b, b, b, b, w, w, w, w, y, y, y, y, b, b, b, b, w, w, w, w, y, y, y, y, y, y, l,
        n, n, n, n, y, y, y, y, w, w, w, w, y, y, y, y, y, y, y, y, w, w, w, w, y, y, y, y, y, y, y, y, l,
        n, n, n, n, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, l,
        n, n, n, n, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, l,
        n, n, n, n, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, l,
        n, n, n, n, y, y, y, y, n, n, y, y, y, y, y, y, n, n, n, n, y, y, y, y, y, y, n, n, y, y, y, y, l,
        n, n, n, n, y, y, n, n, n, n, n, n, y, y, y, y, n, n, n, n, y, y, y, y, n, n, n, n, n, n, y, y, l,
        n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, l,
        n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, l]

      art.join("")
    end
  end
end


