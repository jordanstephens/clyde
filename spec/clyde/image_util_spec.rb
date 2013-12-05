require "spec_helper"

describe Clyde::ImageUtil do
  describe ".pixel_difference" do
    before(:all) do
      @red = "spec/data/images/red.png"
      @blue = "spec/data/images/blue.png"
      @half_red = "spec/data/images/half_red.png"
    end

    it "identifies identical images" do
      percentage = Clyde::ImageUtil.pixel_difference(@red, @red)
      expect(percentage).to eql(0.0)
    end

    it "identifies partially different images" do
      percentage = Clyde::ImageUtil.pixel_difference(@red, @half_red)
      expect(percentage).to eql(0.5)
    end

    it "identifies completely different images" do
      percentage = Clyde::ImageUtil.pixel_difference(@red, @blue)
      expect(percentage).to eql(1.0)
    end
  end
end
