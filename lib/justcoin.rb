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
  #   * `:raw` [true/false] – whether to return the raw Faraday::Response object instead of a parsed value
  #   * any other options are passed on to the Faraday client
  def initialize(key, options={})
    @key = key

    options[:url] ||= DEFAULT_URL
    options[:params] ||= {}
    options[:params][:key] ||= key
    @options = options

    @client = build_client
  end

  # List balances
  #
  # @return [Hash] a hash of current balances with the currencies as keys
  def balances
    response = client.get 'balances'
    parse_response(response, 'currency')
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

  def parse_response(response, key=nil)
    return response if options[:raw]
    parsed = symbolize_keys(response.body)
    parsed = items_by_key(parsed, key.to_sym) if key
    parsed
  end

  def items_by_key(array_of_hashes, key)
    array_of_hashes.each_with_object({}) do |item, hash|
      hash[item.delete(key).to_sym] = item
    end
  end

  def symbolize_keys(value)
    case value
    when Array
      value.map { |item| symbolize_keys(item) }
    when Hash
      value.each_with_object({}) do |(key, val), hash|
        hash[(key.to_sym rescue key) || key] = symbolize_keys(val)
      end
    else
      value
    end
  end

end
