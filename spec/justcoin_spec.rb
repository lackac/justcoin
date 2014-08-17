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

end
