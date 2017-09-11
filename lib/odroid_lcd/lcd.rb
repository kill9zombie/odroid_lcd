
module OdroidLCD
  class LCD

    attr_reader @max_column
    attr_reader @max_row

    def initialize(mocks: {})
      @hw = mocks[:odroidlcd_hw] || OdroidLCD::HW.new
      @max_column = @hw.max_column
      @max_row = @hw.max_row
      freeze()
    end

    def clear
      @hw.clear
    end

    def set_character(row:, column:, character:)
      @hw.set_character(row, column, character)
    end

    def set_string(row: 0, string:)
      column = 0
      string[0, @max_column].ljust(@max_column - 1).chars do |chr|
        set_character(row: row, column: column, character: chr)
        column += 1
      end
    end
  end
end
