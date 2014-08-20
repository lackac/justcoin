require 'spec_helper'

describe Justcoin do

  let(:justcoin) { Justcoin.new("somekey") }

  it "should have a version number" do
    expect(Justcoin::VERSION).to_not be_nil
  end

  describe '#initialize' do
    it "builds a client" do
      expect(justcoin.client).to respond_to(:get)
    end
  end

  describe '#balances' do
    before do
      stub_get('/balances').with(query: {key: "somekey"}).to_return(fixture("balances.json"))
    end

    it "returns the current balances in a hash of currencies" do
      response = justcoin.balances
      str = response.detect {|x| x.currency == "STR"}
      expect(str.balance).to eq(bd("5000.0"))
      expect(response.map(&:to_hash)).to eq([
        {'currency' => "USD", 'balance' => bd("0.0"), 'hold' => bd("0.0"), 'available' => bd("0.0")},
        {'currency' => "STR", 'balance' => bd("5000.0"), 'hold' => bd("0.0"), 'available' => bd("5000.0")},
        {'currency' => "BTC", 'balance' => bd("0.0000084"), 'hold' => bd("0.0"), 'available' => bd("0.0000084")},
        {'currency' => "EUR", 'balance' => bd("0.0"), 'hold' => bd("0.0"), 'available' => bd("0.0")},
        {'currency' => "NOK", 'balance' => bd("0.0"), 'hold' => bd("0.0"), 'available' => bd("0.0")},
        {'currency' => "LTC", 'balance' => bd("0.0"), 'hold' => bd("0.0"), 'available' => bd("0.0")},
        {'currency' => "XRP", 'balance' => bd("0.114568"), 'hold' => bd("0.0"), 'available' => bd("0.114568")}
      ])
    end

    context "with raw: true" do
      let(:justcoin) { Justcoin.new("somekey", raw: true) }

      it "returns the raw Faraday::Response object" do
        response = justcoin.balances
        expect(response).to be_a(Faraday::Response)
        expect(response).to be_success
        expect(response.status).to eq(200)
        expect(response.body.first).to be_a(Hashie::Mash)
        expect(response.body.map(&:to_hash)).to eq([
          {"currency"=>"USD", "balance"=>"0.00000", "hold"=>"0.00000", "available"=>"0.00000"},
          {"currency"=>"STR", "balance"=>"5000.00000000", "hold"=>"0.00000000", "available"=>"5000.00000000"},
          {"currency"=>"BTC", "balance"=>"0.00000840", "hold"=>"0.00000000", "available"=>"0.00000840"},
          {"currency"=>"EUR", "balance"=>"0.00000", "hold"=>"0.00000", "available"=>"0.00000"},
          {"currency"=>"NOK", "balance"=>"0.00000", "hold"=>"0.00000", "available"=>"0.00000"},
          {"currency"=>"LTC", "balance"=>"0.00000000", "hold"=>"0.00000000", "available"=>"0.00000000"},
          {"currency"=>"XRP", "balance"=>"0.114568", "hold"=>"0.000000", "available"=>"0.114568"}
        ])
      end
    end
  end

  describe '#markets' do
    before do
      stub_get('/markets').with(query: {key: "somekey"}).to_return(fixture("markets.json"))
    end

    it "returns the current market statistics" do
      response = justcoin.markets
      expect(response.first.high).to eq(bd("427.0"))
      expect(response.map(&:to_hash)).to eq([
        {'id' => "BTCEUR", 'last' => bd("376.777"), 'high' => bd("427.0"), 'low' => bd("371.112"), 'bid' => bd("371.76"), 'ask' => bd("385.41"), 'volume' => bd("16.88278"), 'scale' => 3},
        {'id' => "BTCLTC", 'last' => bd("110.999"), 'high' => bd("111.0"), 'low' => bd("86.001"), 'bid' => bd("92.001"), 'ask' => bd("110.999"), 'volume' => bd("2.81474"), 'scale' => 3},
        {'id' => "BTCNOK", 'last' => bd("3072.001"), 'high' => bd("3275.149"), 'low' => bd("3072.0"), 'bid' => bd("3075.034"), 'ask' => bd("3110.85"), 'volume' => bd("7.82705"), 'scale' => 3},
        {'id' => "BTCSTR", 'last' => bd("210987.89"), 'high' => bd("212303.0"), 'low' => bd("201016.0"), 'bid' => bd("209090.1"), 'ask' => bd("210987.89"), 'volume' => bd("75.07222"), 'scale' => 3},
        {'id' => "BTCUSD", 'last' => bd("500.714"), 'high' => bd("533.62"), 'low' => bd("488.501"), 'bid' => bd("495.751"), 'ask' => bd("513.999"), 'volume' => bd("3.92299"), 'scale' => 3},
        {'id' => "BTCXRP", 'last' => bd("96800.0"), 'high' => bd("102762.0"), 'low' => bd("93100.0"), 'bid' => bd("93700.714"), 'ask' => bd("96800.0"), 'volume' => bd("7.71935"), 'scale' => 3}
      ])
    end
  end

  describe '#market_depth' do
    before do
      stub_get('/markets/BTCSTR/depth').with(query: {key: "somekey"}).to_return(fixture("market_depth.json"))
    end

    it "returns the current orders for the given market as arrays of bids and asks" do
      response = justcoin.market_depth(:btcstr)
      expect(response.bids).to eq([
        [bd("226244.0"),  bd("0.0702")],
        [bd("225502.26"), bd("0.3")],
        [bd("225500.0"),  bd("0.01651")],
        [bd("225392.26"), bd("0.002")]
      ])
      expect(response.asks).to eq([
        [bd("226697.0"),  bd("0.88946")],
        [bd("226698.0"),  bd("3.3")],
        [bd("226800.0"),  bd("0.59715")],
        [bd("226900.0"),  bd("1.53781")]
      ])
    end
  end

  describe '#orders' do
    before do
      stub_get('/orders').with(query: {key: "somekey"}).to_return(fixture("orders.json"))
    end

    it "returns the user's active orders" do
      response = justcoin.orders
      expect(response.map(&:to_hash)).to eq([
        {'id' => 4054198, 'market' => "BTCSTR", 'type' => "ask", 'price' => bd("229494.0"), 'amount' => bd("0.00436"), 'remaining' => bd("0.00436"), 'matched' => bd("0.0"), 'cancelled' => bd("0.0"), 'createdAt' => t("2014-08-19T10:18:55.582Z")}, 
        {'id' => 4054182, 'market' => "BTCSTR", 'type' => "bid", 'price' => bd("216777.0"), 'amount' => bd("0.00459"), 'remaining' => bd("0.00459"), 'matched' => bd("0.0"), 'cancelled' => bd("0.0"), 'createdAt' => t("2014-08-19T10:17:55.622Z")}
      ])
    end
  end

  describe '#order' do
    before do
      stub_get('/orders/3901787').with(query: {key: "somekey"}).to_return(fixture("order.json"))
    end

    it "returns information about a specific order" do
      response = justcoin.order(3901787)
      expect(response.to_hash).to eq({
        'id' => 3901787,
        'createdAt' => t("2014-08-13T09:44:14.093Z"),
        'market' => "BTCSTR",
        'type' => "ask",
        'price' => bd("197999.0"),
        'original' => bd("0.0803"),
        'matched' => bd("0.0803"),
        'canceled' => bd("0.0"),
        'remaining' => bd("0.0"),
        'matches' => [
          {'id' => 186158, 'createdAt' => t("2014-08-13T09:44:53.274Z"), 'price' => bd("197999.0"), 'amount' => bd("0.00522")},
          {'id' => 186159, 'createdAt' => t("2014-08-13T09:45:00.747Z"), 'price' => bd("197999.0"), 'amount' => bd("0.07508")}
        ]
      })
    end
  end

  describe '#create_order' do
    it "accepts only :bid or :ask for the type argument" do
      expect(-> { justcoin.create_order(:btcstr, :foo, 0, 0) }).to raise_error(ArgumentError)
    end

    it "converts amount and price to string and returns the id of the created order" do
      request = stub_post('/orders').with(
        query: {key: "somekey"},
        body: {
          market: "BTCSTR",
          type: "bid",
          price: "202020.0",
          amount: "0.002462689"
        }
      ).to_return(fixture("create_order.json"))
      response = justcoin.create_order(:btcstr, :bid, 202020, bd("0.002462689"))
      expect(request).to have_been_requested
      expect(response.id).to eq(4089635)
    end
  end

  describe '#cancel_order' do
    before do
      stub_delete('/orders/4094455').with(query: {key: "somekey"}).to_return(fixture("cancel_order.json"))
    end

    it "returns true if cancelling was successful" do
      response = justcoin.cancel_order(4094455)
      expect(response).to be(true)
    end
  end

end
