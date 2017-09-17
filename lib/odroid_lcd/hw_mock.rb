module OdroidLCD
  class HWMock

    attr_reader :max_column
    attr_reader :max_row

    def initialize
      @max_column = 16
      @max_row = 2

      @display = [
        [],
        []
      ]

    end

    def clear
      @display = [
        [],
        []
      ]
    end

    #
    # See: https://en.wikipedia.org/wiki/Hitachi_HD44780_LCD_controller
    def set_character(row, column, character)
      chr = case character
            when "\u005c" then "\u00a5"
            when "\u007e" then "\u2192"
            when "\u007f" then "\u2190"
            else character
            end

      @display[row][column] = chr
    end

    # Extra methods for use as a mock
    #

    def get(row: 0)
      @display[row]
    end

  end
end
