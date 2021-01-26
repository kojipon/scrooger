# frozen_string_literal: true

require 'scrooger'
require 'scrooger/config'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'date'
require 'fileutils'

module Scrooger
  class Calendar
    attr_reader :calendar_id, :start_mins_ago, :stop_mins_later

    def initialize(calendar_id, opts = {})
      @config = opts[:config] || Scrooger::CONFIG['calendar']
      @calendar_id = calendar_id
      @start_mins_ago ||= @config['start_mins_ago'] || 5
      @stop_mins_later ||= @config['stop_mins_later'] || 5
    end

    def released?
      resources.empty?
    end

    def reserved?
      !resources.empty?
    end

    private

      def resources
        response = api.list_events(@calendar_id,
                                   max_results: 5,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: time_min,
                                   time_max: time_max)
        response.items || []
      end

      def api
        serv = Google::Apis::CalendarV3::CalendarService.new
        serv.client_options.application_name = @config['application_name']
        serv.authorization = authorize
        serv
      end

      def authorize
        credentials_path = @config['credentials_path']
        auth = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(credentials_path),
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR
        )
        auth.fetch_access_token!
        auth
      end

      def time_min
        (Time.now.localtime - (60 * @start_mins_ago)).iso8601
      end

      def time_max
        (Time.now.localtime + (60 * @stop_mins_later)).iso8601
      end
  end
end
