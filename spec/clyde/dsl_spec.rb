require "spec_helper"

describe Clyde::Dsl do
  describe ".hosts" do
    it "sets clyde hosts" do
      Clyde::Dsl.hosts("foo.com", "bar.com")
      expect(Clyde.hosts).to eql(["foo.com", "bar.com"])
    end
  end

  describe ".paths" do
    it "sets clyde paths" do
      Clyde::Dsl.paths(["/pathone.html", "/pathtwo.html"])
      expect(Clyde.paths).to eql(["/pathone.html", "/pathtwo.html"])
    end
  end

  describe ".before" do
    it "defines before hooks" do
      hook = Proc.new { puts "before" }
      Clyde::Dsl.before :each, &hook
      expect(Clyde.before_each_hooks.first.proc).to eql(hook)
    end
  end
end
