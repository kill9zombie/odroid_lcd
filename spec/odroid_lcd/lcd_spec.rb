
require_relative '../../lib/odroid_lcd'
require_relative '../../lib/odroid_lcd/hw_mock'

describe "OdroidLCD::LCD" do

  it "uses a valid mock" do
    hw_mock = OdroidLCD::HWMock.new

    lcd = OdroidLCD::LCD.new(mocks: {odroidlcd_hw: hw_mock})
    lcd.set_string(row: 0, string: "/test\\")

    # The Hitachi LCD display displays backslashes as the yen sign.
    expect(hw_mock.get(row: 0)).to eq ["/", "t", "e", "s", "t", "¥", " ", " ", " ", " ", " ", " ", " ", " ", " "]

  end

  it "sets a string" do
    hw_mock = OdroidLCD::HWMock.new

    lcd = OdroidLCD::LCD.new(mocks: {odroidlcd_hw: hw_mock})

    lcd.clear
    expect(hw_mock.get(row: 0)).to eq []
    expect(hw_mock.get(row: 1)).to eq []

    lcd.set_string(row: 0, string: "alice")
    expect(hw_mock.get(row: 0)).to eq ["a", "l", "i", "c", "e", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    expect(hw_mock.get(row: 1)).to eq []

    lcd.set_string(row: 1, string: "bob")
    expect(hw_mock.get(row: 0)).to eq ["a", "l", "i", "c", "e", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    expect(hw_mock.get(row: 1)).to eq ["b", "o", "b", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
  end
end
