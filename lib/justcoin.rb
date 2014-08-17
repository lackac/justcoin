require "faraday"
require "faraday_middleware"

require "justcoin/version"

class Justcoin

  DEFAULT_URL = "https://justcoin.com/api/v1".freeze

  attr_reader :key, :options, :client

  # Creates a new Justcoin client.
  #
  # @param key the API key, get it from
  #   https://justcoin.com/client/#settings/apikeys
  # @param options the client can receive the following options
  #   * `:log` [true/false] – whether to log requests and responses
  #   * `:logger` [Logger] – a custom logger instance, implies `log: true`
  #   * any other options are passed on to the Faraday client
  def initialize(key, options={})
    @key = key

    options[:url] ||= DEFAULT_URL
    options[:params] ||= {}
    options[:params][:key] ||= key
    @options = options

    @client = build_client
  end

  private

  def client_options
    options.select { |k,v| Faraday::ConnectionOptions.members.include?(k) }
  end

  def build_client
    Faraday.new(client_options) do |f|
      f.request :json

      f.response :json, content_type: /\bjson$/
      f.response :logger, options[:logger] if options[:logger] || options[:log]
      f.response :raise_error

      f.adapter Faraday.default_adapter
    end
  end

end
