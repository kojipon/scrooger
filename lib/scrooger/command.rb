# frozen_string_literal: true

require 'scrooger'
require 'thor'
require 'logger'

module Scrooger
  class Command < Thor
    desc 'exec', 'Check the schedule on the calendar and start/stop machines.'
    def exec
      Scrooger::Job.new.start
    end

    desc 'dryrun', 'Show what should start/stop machines.'
    def dryrun
      Scrooger::Job.new(dryrun: true).start
    end

    default_task :dryrun
  end
end
