require "bigdecimal"

class Justcoin
  class ResponseParser < Faraday::Middleware

    def call(env)
      response = @app.call(env)
      parse_response response.env[:body]
    end

    private

    def parse_response(value)
      case value
      when Array
        value.map! {|v| parse_response(v)}
      when Hash, Hashie::Mash
        value.each do |k, v|
          value[k] = parse_response(v)
        end
      when /^\s*\d*\.\d+/
        value = BigDecimal.new(value)
      end
      value
    end

  end
end
