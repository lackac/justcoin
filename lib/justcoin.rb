require "faraday"
require "faraday_middleware"

require "justcoin/version"

class Justcoin

  DEFAULT_URI = "https://justcoin.com/api/v1"

  attr_reader :key, :options, :client

  def initialize(key, options={})
    @key = key
    @options = options
    @client = build_client
  end

  private

  def build_client
    Faraday.new options[:uri] || DEFAULT_URI do |f|
      f.request :json
      f.response :json, content_type: /\bjson$/
      f.response :logger, options[:logger] if options[:logger] || options[:log]
      f.response :raise_error
    end
  end

end
