require "minitest/spec"
require "minitest/autorun"
require_relative "../lib/ancient_mock"

describe AncientMock do
  it "allows an object to receive a message, returning a value" do
    warehouse = Object.new

    allow(warehouse).to receive(:full?).and_return(true)

    warehouse.full?.must_equal true
  end

  it "removes stubbed methods after tests finish" do
    warehouse = Object.new

    allow(warehouse).to receive(:full?).and_return(true)

    AncientMock.reset

    assert_raises(NoMethodError) { warehouse.full? }
  end

  it "preserves methods that originally existed" do
    warehouse = Object.new
    def warehouse.full?; false; end

    allow(warehouse).to receive(:full?).and_return(true)

    AncientMock.reset

    warehouse.full?.must_equal false
  end

  it "expects that a message will be received" do
    warehouse = Object.new

    expect(warehouse).to receive(:empty)
    # warehouse.empty not called!

    assert_raises(AncientMock::ExpectationNotSatisfied) do
      AncientMock.reset
    end
  end

  it "does not raise an error if expectations are satisfied" do
    warehouse = Object.new

    expect(warehouse).to receive(:empty)
    warehouse.empty

    AncientMock.reset
  end

  it "allows objects to receive messages with arguments" do
    warehouse = Object.new

    allow(warehouse).to receive(:include?).with(1234).and_return(true)
    allow(warehouse).to receive(:include?).with(9876).and_return(false)

    warehouse.include?(1234).must_equal true
    warehouse.include?(9876).must_equal false
  end
end
