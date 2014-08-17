require 'spec_helper'

describe Justcoin do

  it "should have a version number" do
    expect(Justcoin::VERSION).to_not be_nil
  end

  describe '#initialize' do
    it "builds a client" do
      justcoin = Justcoin.new("somekey")
      expect(justcoin.client).to respond_to(:get)
    end
  end

end
