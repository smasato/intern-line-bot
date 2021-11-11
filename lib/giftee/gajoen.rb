require 'json'
require 'net/http'
require 'uri'
require 'active_support/core_ext/hash/except.rb'

module Giftee
  module Gajoen
    class Client
      attr_accessor :domain, :token

      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def http
        http = Net::HTTP.new(domain, 443)
        http.use_ssl = true
        http
      end

      # @param [Hash] params
      def get(params)
        return nil if params.key?('brand_id') && params.key?('request_code')
        return nil unless valid_request_code?(params[:request_code])

        req = Net::HTTP::Get.new(File.join('/brands', params[:brand_id].to_s, 'tickets', params[:request_code]))
        req.initialize_http_header(headers)

        res = http.request(req)
        JSON.parse(res.body)
      end

      # @param [Hash] params
      def post(params)
        return nil if params.key?('brand_id') && params.key?('item_id') && params.key?('request_code')
        return nil unless valid_request_code?(params[:request_code])

        req = Net::HTTP::Post.new(File.join('/brands', params[:brand_id].to_s, 'tickets'))
        req.body = params.except(:brand_id).to_json
        req.initialize_http_header(headers)

        res = http.request(req)
        JSON.parse(res.body)
      end

      def headers
        {
          'X-Giftee' => 1.to_s,
          'Authorization' => "Bearer #{token}",
          'Content-Type' => 'application/json',
        }
      end

      def valid_request_code?(request_code)
        re = /[a-zA-Z0-9_-]{1,50}/
        re.match?(request_code)
      end
    end
  end
end
