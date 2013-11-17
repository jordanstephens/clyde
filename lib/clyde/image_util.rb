require "chunky_png"

module Clyde
  module ImageUtil
    def self.pixel_difference(path_a, path_b)
      images = [path_a, path_b].map { |path| ChunkyPNG::Image.from_file(path) }

      diff = []

      begin
        images.first.height.times do |y|
          images.first.row(y).each_with_index do |pixel, x|
            diff << [x, y] unless pixel == images.last[x, y]
          end
        end

        percentage = ((diff.length.to_f / images.first.pixels.length) * 100).round(2)
        "#{percentage}%"
      rescue ChunkyPNG::OutOfBounds
        "N/A (Images are of different dimensions)"
      end
    end
  end
end
