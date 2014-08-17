# Justcoin

An API client for [Justcoin](https://justcoin.com/?r=VLM7U).

## Installation

Add this line to your application's Gemfile:

    gem 'justcoin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install justcoin

## Usage

``` ruby
client = Justcoin.new(ENV['JUSTCOIN_KEY'])
client.balances # => { USD: { balance: 40.0, hold: 0.0, available: 40.0 }, STR: ... }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
