require "faraday"
require "faraday_middleware"

require "justcoin/version"
require "justcoin/response_parser"

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
  #   * `:raw` [true/false] – whether to return the raw Faraday::Response object instead of a parsed value
  #   * any other options are passed on to the Faraday client
  def initialize(key, options={})
    @key = key

    options[:url] ||= DEFAULT_URL
    options[:params] ||= {}
    options[:params][:key] ||= key
    options[:headers] ||= {}
    options[:headers][:user_agent] ||= "Justcoin ruby client v#{Justcoin::VERSION}"
    @options = options

    @client = build_client
  end

  # List balances
  #
  # @return [Array] an array of current balances
  def balances
    client.get "balances"
  end

  # List markets
  #
  # @return [Array] an array of markets with current statistics
  def markets
    client.get "markets"
  end

  private

  def client_options
    options.select { |k,v| Faraday::ConnectionOptions.members.include?(k) }
  end

  def build_client
    Faraday.new(client_options) do |f|
      f.request :json

      # This extracts the body and discards all other data from the
      # Faraday::Response object. It should be placed here in the middle
      # of the stack so that it runs as the last one.
      f.use Justcoin::ResponseParser unless options[:raw]

      f.response :mashify
      f.response :json, content_type: /\bjson$/
      f.response :logger, options[:logger] if options[:logger] || options[:log]
      f.response :raise_error

      f.adapter Faraday.default_adapter
    end
  end

end
