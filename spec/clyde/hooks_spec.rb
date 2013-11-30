require "spec_helper"

shared_context :clyde_hooks do
  include Clyde::Hooks
end

describe Clyde::Hooks do
  include_context :clyde_hooks

  it "allows hook methods to be included" do
    expect do
      self.methods.includes? :add_before_hook,
                             :before_hooks,
                             :before_each_hooks,
                             :before_matched_hooks,
                             :unset_all_hooks
    end.to be_true
  end

  describe "#add_before_hook" do
    it "adds a before each hook with a block" do
      expect(before_each_hooks.length).to eql(0)

      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook

      expect(before_each_hooks.length).to eql(1)
      expect(before_each_hooks.first.proc).to eql(hook)
    end

    it "adds a before matched hook with a block" do
      expect(before_matched_hooks.length).to eql(0)

      hook = Proc.new { puts "foo" }
      add_before_hook /.+/, &hook

      expect(before_matched_hooks.length).to eql(1)
      expect(before_matched_hooks.first.proc).to eql(hook)
    end

    it "raises an exception on unsupported keys" do
      expect {
        add_before_hook :foo do
          puts ":foo is an unsupoorted key"
        end
      }.to raise_error(ArgumentError)
    end

    it "requires a block" do
      expect {
        add_before_hook(:each)
      }.to raise_error(ArgumentError)
    end
  end

  describe "#before_each_hooks" do
    it "returns [] if empty" do
      expect(before_each_hooks).to eql([])
    end

    it "returns a list of before_each_hooks" do
      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook

      expect(before_each_hooks.first.proc).to eql(hook)
    end

    it "returns [] after #unset_all_hooks is called" do
      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook

      expect(before_each_hooks.length).to eql(1)
      expect(before_each_hooks.first.proc).to eql(hook)

      unset_all_hooks
      expect(before_each_hooks.length).to eql(0)
    end
  end

  describe "#before_matched_hooks" do
    it "returns [] if empty" do
      expect(before_matched_hooks).to eql([])
    end

    it "returns a list of before_matched_hooks" do
      hook = Proc.new { puts "foo" }
      add_before_hook /.+/, &hook

      expect(before_matched_hooks.first.proc).to eql(hook)
    end

    it "returns [] after #unset_all_hooks is called" do
      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook

      expect(before_each_hooks.length).to eql(1)
      expect(before_each_hooks.first.proc).to eql(hook)

      unset_all_hooks
      expect(before_each_hooks.length).to eql(0)
    end
  end

  describe "#unset_all_hooks" do
    it "unsets all hooks" do
      hook = Proc.new { puts "foo" }
      add_before_hook :each, &hook
      add_before_hook /.+/, &hook

      expect(before_each_hooks.first.proc).to eql(hook)
      expect(before_matched_hooks.first.proc).to eql(hook)

      unset_all_hooks
      expect(before_each_hooks.length).to eql(0)
      expect(before_matched_hooks.length).to eql(0)
    end
  end
end

