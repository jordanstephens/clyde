require "cgi"

module Clyde
  class Screenshot
    attr_accessor :host, :url_path

    def initialize(host, url_path, capybara_page, opts = {})
      @host = host
      @url_path = url_path

      default_opts = {
        full: true
      }

      opts = default_opts.merge(opts)

      # can't use :full and :selector at the same time,
      # so if :selector is defined, remove :full
      if [:full, :selector].all? { |k| opts.key?(k) }
        opts.delete(:full)
      end

      capybara_page.driver.save_screenshot(file_path, opts)
    end

    def file_path
      filename = [CGI.escape(@url_path),
                  Clyde::SCREENSHOT_EXTENSION].join(".")
      File.join(Clyde.screenshots_path, @host, filename)
    end
  end
end
