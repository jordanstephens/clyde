require "capybara"
require "capybara/poltergeist"
require "optparse"

require "clyde/utils"
require "clyde/clydefile"
require "clyde/dsl"
require "clyde/ghost"
require "clyde/hooks"
require "clyde/job"
require "clyde/version"

module Clyde

  Capybara.run_server = false
  Capybara.current_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {
      js_errors: false,
      timeout: 60
    })
  end

  SCREENSHOT_EXTENSION = "png"
  DIFF_THRESHOLD = 0.01

  class << self
    include Hooks
    include Utils

    attr_reader :log_level
    attr_accessor :hosts, :paths,
                  :clydefile, :screenshots_path

    def run(args)
      @args = args

      set_defaults

      # override defaults with user options
      parse_options(@args)

      # read user inputs from Clydefile
      evaluate_clydefile

      distribute_paths
    end

    def set_defaults
      @hosts = []
      @paths = []
      @clydefile = "./Clydefile"
      @screenshots_path = "./tmp/clyde"
      @log_level = :standard # :quiet || :verbose
      unset_all_hooks
    end

    def parse_options(args)
      args.extend(::OptionParser::Arguable)

      options = args.options do |opts|
        opts.on("--init") do
          expanded_path = File.expand_path(Clyde.clydefile)
          if File.exists?(expanded_path)
            puts "#{expanded_path} already exists"
          else
            puts "Generating Clydefile at #{expanded_path}"
            Clyde::Clydefile.generate
          end
          exit_normal
        end
        opts.on("-C [PATH]", "--clydefile [PATH]", "Path to Clydefile") do |path|
          @clydefile = path
        end

        opts.on("-S [PATH]", "--screenshots [PATH]", "Path to screenshots directory") do |path|
          @screenshots_path = path
        end

        opts.on("--verbose", "Get loud!") do
          set_log_level(:verbose)
        end

        opts.on("-h", "--help", "This is it") do
          puts opts.help
          exit_normal
        end

        opts.on("-v", "--version", "Show version") do
          puts Clyde::VERSION
          exit_normal
        end
      end
      options.parse!
    end

    def set_log_level(val)
      if ([:quiet, :standard, :verbose].include?(val))
        @log_level = val
      else
        raise ArgumentError, "log_level must be :quiet, :standard, or :verbose"
      end
    end

    def evaluate_clydefile
      begin
        Clyde::Clydefile.evaluate(@clydefile)
      rescue Errno::ENOENT
        puts "clyde aborted!"
        puts "No Clydefile found. (looking for #{@clydefile})"
        exit_normal
      end
    end

    def distribute_paths
      Clyde.paths.each do |path|
        Clyde::Job.new(path).run
      end
    end
  end
end
