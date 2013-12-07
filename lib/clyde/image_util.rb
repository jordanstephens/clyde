require "chunky_png"

module Clyde
  module ImageUtil
    def self.pixel_difference(path_a, path_b)
      images = [path_a, path_b].map do |path|
        ChunkyPNG::Image.from_file(path)
      end

      # compare hashes first to see if the images are identical
      # if they are not identical, use a more detailed (and much
      # slower) diff method to obtain the degree of difference
      return 0.0 if identical?(*images)

      different_pixel_count = 0
      images.first.height.times do |y|
        images.first.row(y).each_with_index do |pixel, x|
          different_pixel_count += 1 unless pixel == images.last[x, y]
        end
      end

      (different_pixel_count.to_f / images.first.pixels.length).round(3)
    end

    def self.identical?(image_a, image_b)
      image_a.hash == image_b.hash
    end
  end
end
