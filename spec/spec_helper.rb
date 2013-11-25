require "rspec"
require "billy/rspec"
require "clyde"

# override Clyde's Capybara driver for specs so we can use a proxy for remote requests
Capybara.current_driver = :poltergeist_billy

RSpec.configure do |config|
  config.before(:each) do
    Clyde.set_defaults
  end

  config.after(:each) do
    FileUtils.rm_rf("./tmp")
  end
end

