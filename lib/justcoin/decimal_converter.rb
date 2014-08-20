require "bigdecimal"

class Justcoin
  class DecimalConverter < Faraday::Middleware

    def call(env)
      convert_decimals(env.body) if env.body
      response = @app.call(env)
      parse_response response.env[:body]
      response
    end

    private

    def convert_decimals(body)
      %i(price amount).each do |key|
        case body[key]
        when BigDecimal
          body[key] = body[key].to_s("F")
        when Numeric
          body[key] = Float(body[key]).to_s
        end
      end
    end

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
