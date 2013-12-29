require "spec_helper"

describe Clyde do
  describe ".run" do
    it "allows you to set the Clydefile path with --clydefile" do
      clydefile_path = "spec/data/empty_clydefile"
      Clyde.run(["--clydefile", clydefile_path])
      expect(Clyde.clydefile).to eql(clydefile_path)
    end

    it "allows you to set the Clydefile path with -C" do
      clydefile_path = "spec/data/empty_clydefile"
      Clyde.run(["-C", clydefile_path])
      expect(Clyde.clydefile).to eql(clydefile_path)
    end

    it "allows you to set the screenshots path with --screenshots" do
      screenshots_path = "tmp/screenshots"
      clydefile_path = "spec/data/empty_clydefile"
      Clyde.run(["--screenshots", screenshots_path, "-C", clydefile_path])
      expect(Clyde.screenshots_path).to eql(screenshots_path)
    end

    it "allows you to set the screenshots path with -S" do
      screenshots_path = "tmp/screenshots"
      clydefile_path = "spec/data/empty_clydefile"
      Clyde.run(["-S", screenshots_path, "-C", clydefile_path])
      expect(Clyde.screenshots_path).to eql(screenshots_path)
    end

    it "runs verbosely with --verbose" do
      clydefile_path = "spec/data/empty_clydefile"
      Clyde.run(["--verbose", "-C", clydefile_path])
      expect(Clyde.log_level).to eql(:verbose)
    end
  end

  describe ".set_log_level" do
    context "with valid params" do
      it "sets the log level" do
        Clyde.set_log_level(:verbose)
        expect(Clyde.instance_variable_get("@log_level")).to eql(:verbose)
      end
    end

    context "with invalid params" do
      it "raises an exception" do
        expect(Clyde.instance_variable_get("@log_level")).to eql(:standard)
        expect {
          Clyde.set_log_level(:foobar)
        }.to raise_error(ArgumentError)
        expect(Clyde.instance_variable_get("@log_level")).to eql(:standard)
      end
    end
  end

  describe ".capture_screenshots" do
    it "captures a screenshot from each host for each path" do
      Clyde.set_log_level(:quiet)

      Clyde.hosts = ["localhost:30001", "localhost:30002"]
      Clyde.paths = ["/"]

      Clyde.hosts.each do |host|
        Clyde.paths.each do |path|
          proxy.stub("http://#{host}#{path}")
               .and_return(text: "stub that shit")
        end
      end

      screenshots = Clyde.capture_screenshots
      expect(screenshots.length).to eql(1)

      # screenshots is a list where each row is a pair of Screenshot objects
      expect(screenshots.first.length).to eql(2)
      screenshots.first.each do |screenshot|
        expect(screenshot.is_a?(Clyde::Screenshot)).to be_true
      end
    end
  end
end

