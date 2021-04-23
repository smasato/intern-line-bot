require 'google/apis/calendar_v3'
require 'googleauth'
require "googleauth/stores/file_token_store"
require "date"
require 'fileutils'
require 'json'



class Calendar
  def initialize
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = ENV['APPLICATION_NAME']
    @service.authorization = authorize
    @calendar_id = ENV['MY_CALENDAR_ID']
  end

  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(ENV['CLIENT_SECRET_PATH']),
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR)
    authorizer.fetch_access_token!
    authorizer
  end

  # 実際にスケジュールを取得するメソッド
  # 今から丁度1週間後までのスケジュールを取ってくれる
  def get_schedule(time_min = Time.now.iso8601, time_max = (Time.now + 24*60*60*7*0).iso8601, max_results = 256)
    response = @service.list_events(@calendar_id,
                                    max_results: max_results,
                                    single_events: true,
                                    order_by: 'startTime',
                                    time_min: Time.now.iso8601)
    response.items
  end
end