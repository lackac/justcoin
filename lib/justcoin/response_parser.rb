class Justcoin
  class ResponseParser < Faraday::Middleware

    def call(env)
      response = @app.call(env)
      parse_response response.env[:body]
    end

    private

    def parse_response(body)
      body
    end

  end
end
