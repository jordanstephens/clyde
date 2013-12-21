require "spec_helper"

describe Clyde::Clydefile do
  describe ".generate" do
    it "generates an example Clydefile" do
      clydefile_path = "tmp/Clydefile"
      Clyde::Clydefile.generate(clydefile_path)
      expect(File.exists?(clydefile_path)).to be_true
      expect(File.read(clydefile_path)).to eql(File.read(Clyde::Clydefile::TEMPLATE_PATH))
    end
  end

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
      expect(Clyde.before_each_hooks.length).to eql(1)
    end
  end
end

