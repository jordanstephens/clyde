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
    it "defines before each hooks" do
      hook = Proc.new { puts "before" }
      expect(Clyde.before_each_hooks.length).to eql(0)
      Clyde::Dsl.before :each, &hook
      expect(Clyde.before_each_hooks.length).to eql(1)
      expect(Clyde.before_each_hooks.first.proc).to eql(hook)
    end

    it "defines before matched hooks" do
      hook = Proc.new { puts "before" }
      expect(Clyde.before_matched_hooks.length).to eql(0)
      Clyde::Dsl.before /.+/, &hook
      expect(Clyde.before_matched_hooks.length).to eql(1)
      expect(Clyde.before_matched_hooks.first.proc).to eql(hook)
    end
  end
end
