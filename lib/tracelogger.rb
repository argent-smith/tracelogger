require 'tracelogger/version'
require 'optparse'
require 'log4r'
require 'log4r/outputter/syslogoutputter'

# Author:: Pavel Argentov (mailto:argentoff@gmail.com)
# License:: MIT (See README)
#
# This module contains all the classes needed by Tracelogger.
module Tracelogger

  # Tracelogger's Configuration: used when running the app.
  class Configuration
    attr_accessor :options, :host
  end

  # This class wraps Log4r's Syslog logic.
  # == Usage
  #   mylog = Log.new
  #   mylog.info "Some Message"
  class Log

    # @private
    def initialize # :nodoc:
      @log = Log4r::Logger.new "main"
      @log.outputters = Log4r::SyslogOutputter.new("tracelogger", :facility => "LOG_DAEMON")
    end

    # @private
    def method_missing(meth, *args, &block) # :nodoc:
      @log.send meth, *args, &block
    end
  end

  # Wraps `traceroute` run.
  class Traceroute

    # Finds the system's traceroute executable.
    def initialize
      @command = `/usr/bin/env PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin which traceroute`.chomp
    end

    # Runs the found traceroute with the specified address and returns the
    # result.
    def trace host
      p @command
      `#{@command} #{host} 2>&1`
    end
  end

  # Application run scenario.
  class App

    # Initializes the app's settings and parses the CLI options.
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

    # Logs the message.
    def log message # :nodoc:
      @log.info message
    end

    # Executed right after the start.
    def start # :nodoc:
      log "Starting"
    end

    # Executed right before the end.
    def wrapup # :nodoc:
      log "Finishing"
    end

    # Logs the underlying traceroute's result.
    def trace # :nodoc:
      log Traceroute.new.trace @config.host
    end

    # Runs the app scenario.
    def run
      start
      trace
      wrapup
    end
  end
end
