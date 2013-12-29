require "spec_helper"

describe Clyde::ScreenshotRunner do
  describe ".new" do
    it "defines a new ScreenshotRunner" do
      runner = Clyde::ScreenshotRunner.new("/foo")
      expect(runner.path).to eql("/foo")
    end
  end

  describe "#run" do
    it "runs a ScreenshotRunner for each Clyde host" do
      Clyde.set_log_level(:quiet)
      Clyde.hosts = ["localhost:30001", "localhost:30002"]

      Clyde.hosts.each do |host|
        proxy.stub("http://#{host}/foo")
             .and_return(text: "stub that shit")
      end

      runner = Clyde::ScreenshotRunner.new("/foo")
      runner.run
    end
  end

  describe "#fetch_page_from_host" do
    it "fetches a page from a host" do
      Clyde.set_log_level(:quiet)

      Clyde.hosts = ["localhost:30001", "localhost:30002"]

      Clyde.hosts.each do |host|
        proxy.stub("http://#{host}/foo")
             .and_return(text: "stub that shit")
      end

      runner = Clyde::ScreenshotRunner.new("/foo")
      runner.run
    end
  end

  describe "#run_before_hooks" do
    it "runs before hooks" do
      Clyde.set_log_level(:quiet)

      Clyde.hosts = ["localhost:30001", "localhost:30002"]

      Clyde.hosts.each do |host|
        proxy.stub("http://#{host}/foo")
             .and_return(text: "stub that shit")
      end

      Clyde.add_before_hook(:each) { foo = :bar }
      Clyde.add_before_hook(/.+/) { baz = :qux }
      Clyde.add_before_hook(:each) do |page, opts|
        opts[:foo] = :bar
      end

      runner = Clyde::ScreenshotRunner.new("/foo")

      screenshot_opts = runner.instance_variable_get("@screenshot_opts")
      expect(screenshot_opts[:foo]).to eql(nil)

      runner.run_before_hooks

      screenshot_opts = runner.instance_variable_get("@screenshot_opts")
      expect(screenshot_opts[:foo]).to eql(:bar)
    end
  end
end

