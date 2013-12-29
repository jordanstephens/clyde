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
end

