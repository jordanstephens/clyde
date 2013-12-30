require "capybara"
require "clyde/screenshot"

module Clyde
  class ScreenshotRunner
    include Clyde::Utils
    include Capybara::DSL

    attr_reader :path

    def initialize(path)
      @path = path
      @screenshot_opts = Clyde::Screenshot.default_opts
    end

    def run
      notice "running \t#{@path}"
      Clyde.hosts.map do |host|
        file_path = Clyde::Screenshot.file_path_from_host_and_url_path(host, @path)

        if File.exists?(file_path)
          notice "using cache for\t#{host}#{@path}"
          Clyde::Screenshot.from_file(file_path)
        else
          notice "visiting \t#{host}#{@path}"
          visit_page_at_host(host)
          notice "running hooks \t#{host}#{@path}"
          run_before_hooks
          notice "capturing \t#{host}#{@path}"
          Clyde::Screenshot.new(host, @path, page, @screenshot_opts)
        end
      end
    end

    def visit_page_at_host(host)
      visit "http://#{host}#{@path}"
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
