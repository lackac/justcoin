# Justcoin

API client for [Justcoin](https://justcoin.com/?r=VLM7U).

[![Gem Version](http://img.shields.io/gem/v/justcoin.svg)](https://rubygems.org/gems/justcoin)
[![Build Status](http://img.shields.io/travis/lackac/justcoin.svg)](https://travis-ci.org/lackac/justcoin)
[![Code Climate](http://img.shields.io/codeclimate/github/lackac/justcoin.svg)](https://codeclimate.com/github/lackac/justcoin)

## Installation

Add this line to your application's Gemfile:

    gem 'justcoin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install justcoin

## Usage

* [Documentation](http://rubydoc.info/github/lackac/justcoin)

### Example

``` ruby
client = Justcoin.new(ENV['JUSTCOIN_KEY'])

# fetch current BTC balance
btc = client.balances.detect {|b| b.currency == "BTC"}

# fetch market stats for BTCSTR
btcstr = client.markets.detect {|m| m.id == "BTCSTR"}

# sell half of available BTC for STR in a limit order
client.place_order(:btcstr, :ask, btcstr.ask-0.001, btc.available/2)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
