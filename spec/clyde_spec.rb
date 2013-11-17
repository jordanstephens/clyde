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
  end

  describe ".distribute_paths" do
    # it "distributes a job for each path" do
    #   Clyde.hosts = ["jordanstephens.net", "staging.jordanstephens.net"]
    #   Clyde.paths = ["/"]
    #   Clyde.distribute_paths
    # end
  end
end

