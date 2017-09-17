
require_relative '../../lib/odroid_lcd'
require_relative '../../lib/odroid_lcd/hw_mock'

describe "OdroidLCD::CLI" do

  it "sets a string" do
    hw_mock = OdroidLCD::HWMock.new
    mocks = {odroidlcd_hw: hw_mock}
    cli = OdroidLCD::CLI.new(["alice", "bob"], mocks)
    cli.run

    expect(hw_mock.get(row: 0)).to eq ["a", "l", "i", "c", "e", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    expect(hw_mock.get(row: 1)).to eq ["b", "o", "b", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
  end

end
