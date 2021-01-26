# frozen_string_literal: true

require 'scrooger/config'
require 'scrooger/machine'
require 'scrooger/calendar'

module Scrooger
  class Job
    def initialize(opts = {})
      @dryrun = opts[:dryrun]
      @logger = logger(opts[:output])
      @target = opts[:target] || Scrooger::CONFIG['target']
    end

    def start
      all do |label, cal, mc|
        if cal.reserved? && mc.stopped?
          @logger.debug("Starting #{mc.instance_id} for #{label}.")
          mc.start unless @dryrun
        elsif !cal.reserved? && mc.started?
          @logger.debug("Stopping #{mc.instance_id} for #{label}.")
          mc.stop unless @dryrun
        end
      end
    end

    def all
      @target.each do |t|
        next if t['calendar_id'].nil? || t['instance_ids'].nil?

        cal = Scrooger::Calendar.new(t['calendar_id'])
        t['instance_ids'].each do |id|
          mc = Scrooger::Machine.new(id)
          yield(t['label'], cal, mc)
        end
      end
    end

    def logger(output = nil)
      output ||= $stdout
      logger = Logger.new(output)
      if output == $stdout
        logger.formatter = proc do |_severity, _datetime, _progname, message|
          "#{@dryrun ? '[DRYRUN] ' : ''}#{message}\n"
        end
      end
      logger
    end
  end
end
