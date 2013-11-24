require "chunky_png"

module Clyde
  module ImageUtil
    def self.pixel_difference(path_a, path_b)

      # try an md5 hash first to see if the files are identical
      # if they are not identical, use a more detailed (slower) diff method
      image_hashes = [path_a, path_b].map { |path| Digest::MD5.file(path) }
      return "0.0%" if image_hashes[0] == image_hashes[1]

      images = [path_a, path_b].map do |path|
        ChunkyPNG::Image.from_file(path)
      end

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
