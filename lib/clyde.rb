require "capybara"
require "capybara/poltergeist"
require "thread/pool"
require "optparse"

require "clyde/utils"
require "clyde/image_util"
require "clyde/clydefile"
require "clyde/dsl"
require "clyde/ghost"
require "clyde/hooks"
require "clyde/screenshot_runner"
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

      @screenshot_pairs = capture_screenshots
      compare_screenshot_pairs(@screenshot_pairs)
    end

    def set_defaults
      @hosts = []
      @paths = []
      @clydefile = "./Clydefile"
      @screenshots_path = "./tmp/clyde"
      @log_level = :standard # :quiet || :verbose
      @thread_count = 1
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

        opts.on("-t [COUNT]", "--threads [COUNT]", "Number of threads to use when comparing screenshots") do |thread_count|
          # gotta love a good thread count
          @thread_count = thread_count.to_i
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
        puts "No Clydefile found. Create one by running the following command:"
        puts
        puts "  clyde --init"
        puts
        exit_normal
      end
    end

    def capture_screenshots
      Clyde.paths.map do |path|
        Clyde::ScreenshotRunner.new(path).run
      end
    end

    def compare_screenshot_pairs(screenshot_pairs)
      pool = Thread.pool(@thread_count)

      screenshot_pairs.each do |screenshots|
        pool.process do
          url_path = screenshots.first.url_path

          if screenshots.length == Clyde.hosts.length
            notice "comparing \t#{url_path}"
            print_screenshot_difference(screenshots)
          else
            log "Error: #{screenshots.length} of #{Clyde.hosts.length} screenshots generated for #{url_path}", color: :red
          end
        end
      end

      pool.shutdown
    end

    def print_screenshot_difference(screenshots)
      begin
        difference = ImageUtil.pixel_difference(screenshots[0].file_path,
                                                screenshots[1].file_path)

        percentage = "#{difference * 100}%"
        color = difference > DIFF_THRESHOLD ? :red : :green
        log "#{percentage} - #{screenshots.first.url_path}", color: color
      rescue ChunkyPNG::OutOfBounds
        log "N/A (Images are of different dimensions)", color: :red
      end
    end
  end
end
