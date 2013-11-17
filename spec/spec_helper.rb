require "rspec"
require "clyde"

RSpec.configure do |config|
  config.before(:each) do
    Clyde.set_defaults
  end

  config.after(:each) do
    FileUtils.rm_rf("./tmp")
  end
end

