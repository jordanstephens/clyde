require "capybara"
require "clyde/image_util"
require "clyde/screenshot"

module Clyde
  class Job
    include Clyde::Utils
    include Capybara::DSL

    def initialize(path)
      @screenshots = []
      Clyde.hosts.each do |host|

        set_capybara_host(host)
        log "#{host}#{path}"
        visit path
        run_before_hooks
        save_screenshot(host, path, page, {})
      end

      if @screenshots.length == 2
        diff = ImageUtil.pixel_difference(@screenshots[0].file_path,
                                          @screenshots[1].file_path)

        log "#{diff} - #{path}"
      end
    end

    def set_capybara_host(host)
      Capybara.app_host = "http://#{host}"
    end

    def run_before_hooks
      Clyde.before_each_hooks.each do |hook|
        instance_eval &(hook.proc)
      end
    end

    def save_screenshot(host, path, page, opts = {})
      @screenshots << Screenshot.new(host, path, page, {})
    end
  end
end
