require "spec_helper"

describe Clyde::Screenshot do
  describe ".file_path_from_host_and_url_path" do
    it "defines a file path for a given host and url path" do
      host = "foo.com"
      url_path = "/bar"
      file_path = Clyde::Screenshot.file_path_from_host_and_url_path(host, url_path)
      expect(file_path).to eql("./tmp/clyde/foo.com/%2Fbar.png")
    end
  end

  describe ".attrs_from_file_path" do
    it "extracts screenshot attrs from file path" do
      file_path = "./tmp/clyde/foo.com/%2Fbar.png"
      attrs = Clyde::Screenshot.attrs_from_file_path(file_path)
      expect(attrs.is_a?(Hash)).to be_true
      expect(attrs[:host]).to eql("foo.com")
      expect(attrs[:url_path]).to eql("/bar")
    end
  end

  describe ".from_file" do
    SPEC_SCREENSHOT_PATH = "tmp/clyde-screenshot-spec"

    before(:all) do
      Clyde.screenshots_path = SPEC_SCREENSHOT_PATH
      host = "localhost:30001"
      path = "/foo"

      cp_src = "spec/data/images/blue.png"
      cp_dest = Clyde::Screenshot.file_path_from_host_and_url_path(host, path)

      FileUtils.mkdir_p(File.dirname(cp_dest))
      FileUtils.cp(cp_src, cp_dest)
    end

    after(:all) do
      FileUtils.rm_rf(SPEC_SCREENSHOT_PATH)
    end

    it "creates a Screenshot from a file" do
      host_dirs = Dir.glob(File.join(SPEC_SCREENSHOT_PATH, "*"))
      host_path = host_dirs.first
      image_path = Dir.glob(File.join(host_path, "*")).first
      screenshot = Clyde::Screenshot.from_file(image_path)
      expect(screenshot.is_a?(Clyde::Screenshot)).to be_true
      expect(screenshot.host).to eql("localhost:30001")
      expect(screenshot.url_path).to eql("/foo")
    end
  end
end

