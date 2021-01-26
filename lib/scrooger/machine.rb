# frozen_string_literal: true

require 'scrooger'
require 'scrooger/config'
require 'aws-sdk-ec2'

module Scrooger
  class Machine
    attr_reader :instance_id

    def initialize(instance_id, opts = {})
      @config = opts[:config] || Scrooger::CONFIG['machine']
      @instance_id = instance_id
    end

    def start
      p 'DEBUG: startting a machine.'
      # @instance.start
    end

    def stop
      p 'DEBUG: stopping a machine.'
      # @instance.stop
    end

    def started?
      state_code == 16
    end

    def stopped?
      state_code == 80
    end

    private

      def instance
        api.instance(@instance_id)
      end

      def api
        Aws::EC2::Resource.new(region: @config['region'])
      end

      def state_code
        instance.state.code
      end
  end
end
