require "cgi"

module Clyde
  class Screenshot
    attr_accessor :host, :url_path

    def initialize(host, url_path, capybara_page, opts = {})
      @host = host
      @url_path = url_path

      opts = self.class.default_opts.merge(opts)

      # can't use :full and :selector at the same time,
      # so if :selector is defined, remove :full
      if [:full, :selector].all? { |k| opts.key?(k) }
        opts.delete(:full)
      end

      capybara_page.driver.save_screenshot(file_path, opts)
    end

    def file_path
      self.class.file_path_from_host_and_url_path(@host, @url_path)
    end

    def self.file_path_from_host_and_url_path(host, url_path)
      filename = [CGI.escape(url_path),
                  Clyde::SCREENSHOT_EXTENSION].join(".")
      File.join(Clyde.screenshots_path, host, filename)
    end

    def self.attrs_from_file_path(path)
      attrs = {}
      path_components = path.split("/").last(2)
      attrs[:host] = path_components.first
      attrs[:url_path] = CGI::unescape(path_components.last)
                           .sub(".#{Clyde::SCREENSHOT_EXTENSION}", "")
      attrs
    end

    def self.default_opts
      { full: true }
    end
  end
end
