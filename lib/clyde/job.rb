require "capybara"
require "clyde/image_util"
require "clyde/screenshot"

module Clyde
  class Job
    include Clyde::Utils
    include Capybara::DSL

    attr_reader :path, :screenshots

    def initialize(path)
      @path = path
      @screenshots = []
      @screenshot_opts = Clyde::Screenshot.default_opts
    end

    def run
      Clyde.hosts.each do |host|
        fetch_page_from_host(host)
        run_before_hooks
        @screenshots << Screenshot.new(host, @path, page, @screenshot_opts)
      end

      screenshot_count = @screenshots.length
      expected_count = Clyde.hosts.length
      if screenshot_count == Clyde.hosts.length
        print_screenshot_difference
      else
        log "Error: #{screenshot_count} of #{expected_count} screenshots generated for #{@path}", color: :red
      end
    end

    def fetch_page_from_host(host)
      set_capybara_host(host)
      notice "#{host}#{@path}"
      visit @path
    end

    def print_screenshot_difference
      begin
        difference = ImageUtil.pixel_difference(@screenshots[0].file_path,
                                                @screenshots[1].file_path)

        percentage = "#{difference * 100}%"
        color = difference > DIFF_THRESHOLD ? :red : :green
        log "#{percentage} - #{@path}", color: color
      rescue ChunkyPNG::OutOfBounds
        log "N/A (Images are of different dimensions)", color: :red
      end
    end

    def set_capybara_host(host)
      Capybara.app_host = "http://#{host}"
    end

    def run_before_hooks
      Clyde.before_each_hooks.each do |hook|
        instance_exec(page, @screenshot_opts, &(hook.proc))
      end

      Clyde.before_matched_hooks.each do |hook|
        instance_exec(page, @screenshot_opts, &(hook.proc)) if !!hook.key.match(@path)
      end
    end
  end
end
