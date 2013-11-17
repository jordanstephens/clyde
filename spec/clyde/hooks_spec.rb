require "spec_helper"

shared_context :clyde_hooks do
  include Clyde::Hooks
end

describe Clyde::Hooks do
  include_context :clyde_hooks

  it "includes methods" do
    expect(self.methods).to include(:before_hooks, :add_before_hook, :unset_all_hooks)
  end

  describe "#add_before_hook" do
    it "adds a before hook with a block" do
      expect(before_hooks.length).to eql(0)

      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook

      expect(before_hooks.length).to eql(1)
      expect(before_hooks[:each].first).to eql(hook)
    end
  end

  describe "#before_hooks" do
    it "returns [] if empty" do
      expect(before_hooks).to eql([])
    end

    it "returns a list of before_hooks by key" do
      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook
      expect(before_hooks[:each].first).to eql(hook)
    end
  end

  describe "#unset_all_hooks" do
    it "unsets all hooks" do
      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook
      expect(before_hooks[:each].first).to eql(hook)
      unset_all_hooks
      expect(before_hooks.length).to eql(0)
    end
  end
end

