require "spec_helper"

describe Clyde::Clydefile do
  describe ".evaluate" do

    before :all do
      @clydefile_path = "spec/data/sample_clydefile"
      File.open(@clydefile_path, "w") do |f|
        f << <<-EOS
          hosts "foo.com", "bar.com"

          before :each do
            puts "i'm a before hook"
          end

          paths %w(
            /pathone.html
            /pathtwo.html
          )
        EOS
      end
    end

    it "uses a DSL to define hosts" do
      Clyde::Clydefile.evaluate(@clydefile_path)
      expect(Clyde.hosts).to eql(["foo.com", "bar.com"])
    end

    it "uses a DSL to define hosts" do
      Clyde::Clydefile.evaluate(@clydefile_path)
      expect(Clyde.paths).to eql(["/pathone.html", "/pathtwo.html"])
    end

    it "uses a DSL to define before hooks" do
      Clyde::Clydefile.evaluate(@clydefile_path)
      expect(Clyde.before_hooks[:each].length).to eql(1)
    end
  end
end

