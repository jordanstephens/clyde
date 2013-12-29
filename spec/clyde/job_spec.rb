require "spec_helper"

describe Clyde::Job do
  describe "Job.new" do
    it "defines a new job" do
      job = Clyde::Job.new("/foo")
      expect(job.path).to eql("/foo")
    end
  end

  describe "Job#run" do
    it "runs a job for each Clyde host" do
      Clyde.set_log_level(:quiet)
      Clyde.hosts = ["localhost:30001", "localhost:30002"]

      Clyde.hosts.each do |host|
        proxy.stub("http://#{host}/foo")
             .and_return(text: "stub that shit")
      end

      job = Clyde::Job.new("/foo")
      job.run
    end
  end

  describe "Job#fetch_page_from_host" do
    it "fetches a page from a host" do
      Clyde.set_log_level(:quiet)

      Clyde.hosts = ["localhost:30001", "localhost:30002"]

      Clyde.hosts.each do |host|
        proxy.stub("http://#{host}/foo")
             .and_return(text: "stub that shit")
      end

      job = Clyde::Job.new("/foo")
      job.run
    end
  end

  describe "Job#run_before_hooks" do
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

      job = Clyde::Job.new("/foo")

      screenshot_opts = job.instance_variable_get("@screenshot_opts")
      expect(screenshot_opts[:foo]).to eql(nil)

      job.run_before_hooks

      screenshot_opts = job.instance_variable_get("@screenshot_opts")
      expect(screenshot_opts[:foo]).to eql(:bar)
    end
  end
end

