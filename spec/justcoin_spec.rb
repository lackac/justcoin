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
      expect(justcoin.balances).to eq({
        USD: {balance: "0.00000", hold: "0.00000", available: "0.00000"},
        STR: {balance: "5000.00000000", hold: "0.00000000", available: "5000.00000000"},
        BTC: {balance: "0.00000840", hold: "0.00000000", available: "0.00000840"},
        EUR: {balance: "0.00000", hold: "0.00000", available: "0.00000"},
        NOK: {balance: "0.00000", hold: "0.00000", available: "0.00000"},
        LTC: {balance: "0.00000000", hold: "0.00000000", available: "0.00000000"},
        XRP: {balance: "0.114568", hold: "0.000000", available: "0.114568"}
      })
    end

    context "with raw: true" do
      let(:justcoin) { Justcoin.new("somekey", raw: true) }

      it "returns the raw Faraday::Response object" do
        response = justcoin.balances
        expect(response).to be_a(Faraday::Response)
        expect(response).to be_success
        expect(response.status).to eq(200)
        expect(response.body).to eq([
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
      expect(justcoin.markets).to eq({
        BTCEUR: {last: "376.777", high: "427.000", low: "371.112", bid: "371.760", ask: "385.410", volume: "16.88278", scale: 3},
        BTCLTC: {last: "110.999", high: "111.000", low: "86.001", bid: "92.001", ask: "110.999", volume: "2.81474", scale: 3},
        BTCNOK: {last: "3072.001", high: "3275.149", low: "3072.000", bid: "3075.034", ask: "3110.850", volume: "7.82705", scale: 3},
        BTCSTR: {last: "210987.890", high: "212303.000", low: "201016.000", bid: "209090.100", ask: "210987.890", volume: "75.07222", scale: 3},
        BTCUSD: {last: "500.714", high: "533.620", low: "488.501", bid: "495.751", ask: "513.999", volume: "3.92299", scale: 3},
        BTCXRP: {last: "96800.000", high: "102762.000", low: "93100.000", bid: "93700.714", ask: "96800.000", volume: "7.71935", scale: 3}
      })
    end
  end

end
