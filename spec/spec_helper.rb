$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'justcoin'

require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
end

def a_delete(path)
  a_request(:delete, Justcoin::DEFAULT_URL + path)
end

def a_get(path)
  a_request(:get, Justcoin::DEFAULT_URL + path)
end

def a_post(path)
  a_request(:post, Justcoin::DEFAULT_URL + path)
end

def a_put(path)
  a_request(:put, Justcoin::DEFAULT_URL + path)
end

def stub_delete(path)
  stub_request(:delete, Justcoin::DEFAULT_URL + path)
end

def stub_get(path)
  stub_request(:get, Justcoin::DEFAULT_URL + path)
end

def stub_post(path)
  stub_request(:post, Justcoin::DEFAULT_URL + path)
end

def stub_put(path)
  stub_request(:put, Justcoin::DEFAULT_URL + path)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def bd(number)
  BigDecimal.new(number)
end

def t(time_string)
  Time.parse(time_string)
end
