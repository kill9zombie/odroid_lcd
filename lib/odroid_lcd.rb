class OdroidLCD
  require_relative '../ext/odroidlcd/Odroidlcd'
  VERSION = "0.0.1"

  def initialize
    @lcd = Odroidlcd.new
  end

  def clear
    @lcd.clear
  end

  def set_character(row:, column:, character:)
    @lcd.set_character(row, column, character)
  end

  def set_string(row: 0, string:)
    column = 0
    if string.length < @lcd.max_column
      string.ljust(@lcd.max_column - 1).chars do |chr|
        set_character(row: row, column: column, character: chr)
        column += 1
      end
    end
  end
      
end
