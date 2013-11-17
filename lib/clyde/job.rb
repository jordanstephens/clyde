require "capybara"
require "clyde/image_util"
require "clyde/screenshot"

module Clyde
  class Job
    include Capybara::DSL

    def initialize(path)
      @screenshots = []
      Clyde.hosts.each do |host|

        set_capybara_host(host)
        visit path
        run_before_hooks
        save_screenshot(host, path, page, {})
      end

      if @screenshots.length == 2
        diff = ImageUtil.pixel_difference(@screenshots[0].file_path,
                                          @screenshots[1].file_path)

        puts "#{diff} - #{path}"
      end
    end

    def set_capybara_host(host)
      Capybara.app_host = "http://#{host}"
    end

    def run_before_hooks
      return if Clyde.before_hooks.empty? || Clyde.before_hooks[:each].nil?
      Clyde.before_hooks[:each].each do |hook|
        instance_eval &hook
      end
    end

    def save_screenshot(host, path, page, opts = {})
      @screenshots << Screenshot.new(host, path, page, {})
    end
  end
end
