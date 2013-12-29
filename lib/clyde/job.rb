require "capybara"
require "clyde/screenshot"

module Clyde
  class Job
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
        notice "visiting \t#{host}#{@path}"
        visit_page_at_host(host)
        notice "running hooks \t#{host}#{@path}"
        run_before_hooks
        notice "capturing \t#{host}#{@path}"
        Screenshot.new(host, @path, page, @screenshot_opts)
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
