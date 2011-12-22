require "tracelogger/version"
require "optparse"
require 'log4r'
require 'log4r/outputter/syslogoutputter'

module Tracelogger

  class Configuration
    attr_accessor :options, :host
  end

  class Log
    def initialize
      @log = Log4r::Logger.new "main"
      @log.outputters = Log4r::SyslogOutputter.new("dumb_tracer", :facility => "LOG_DAEMON")
    end

    def method_missing(meth, *args, &block)
      @log.send meth, *args, &block
    end
  end

  class Traceroute
    def initialize
      @command = `which traceroute`.chomp
    end

    def trace host
      `env #{@command} #{host} 2>&1`
    end
  end

  class App

    # Initializes the app's settings
    def initialize
      @config = Configuration.new
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: dumb_tracer [options] host\n" +
          "  Traces the route to destination host and sends\n" +
          "  the traceroute result to SYSLOG's 'daemon' facility"

        opts.separator ""
        opts.separator "Optional parameters:"

        opts.on_tail "-h", "--help", "Show this message" do
          puts opts.help
        end

      end.parse!

      @config.options = options
      @config.host    = ARGV.first

      @log = Log.new
    end

    def log message
      @log.info message
    end

    def start
      log "Starting"
    end

    def wrapup
      log "Finishing"
    end

    def trace
      log Traceroute.new.trace @config.host
    end

    # Runs the app
    def run
      start
      trace
      wrapup
    end
  end
end
