
module OdroidLCD

  class LCDError < StandardError; end

  class LCD
    # The main interface to the LCD screen.

    attr_reader :max_column
    attr_reader :max_row

    def initialize(mocks: {})
      @hw = if mocks[:odroidlcd_hw]
              mocks[:odroidlcd_hw]
            else
              require 'odroid_lcd/hw'
              OdroidLCD::HW.new
            end

      @max_column = @hw.max_column
      @max_row = @hw.max_row
      freeze()
    end

    # Clear the display
    def clear
      @hw.clear
    end

    # set_character
    #
    # Sets a single character at a particular position on the display.
    #
    # Note that the display uses a Japanese display driver, so
    # the following quirks / features are present:
    #
    # "\" is displayed as the yen character
    # "~" is displayed as a right arrow
    # delete (or rubout) is displayed as a left arrow
    #
    # Row 0 is the top row, row 1 is the bottom row.
    #
    def set_character(row:, column:, character:)
      begin
        # It's a Japanese display, seemingly using Windows-31J
        #
        # Note that \ displays as a yen sign, ~ displays as a right arrow, DEL displays as a left arrow
        chr = character.encode("Windows-31J")
        @hw.set_character(row, column, chr)
      rescue Encoding::UndefinedConversionError => e
        raise OdroidLCD::LCDError, "Could not display character: #{character}, the display uses Japanese Windows-31J"
      end
    end

    # set_string
    #
    # Sets a string on the display.
    #
    # +::row::+
    #   Which row of the display to update.
    #   Row 0 is the top row, row 1 is the bottom row.
    #
    # +::string::+
    #   The string to send to the display.
    #
    # +::align::+
    #   Optional, either "left", "right", or "center"
    #   Defaults to: "left"
    #
    def set_string(row: 0, string:, align: "left")
      column = 0
      str = case align
            when "left"   then string[0, @max_column].ljust(@max_column)
            when "right"  then string[0, @max_column].rjust(@max_column)
            when "center" then string[0, @max_column].center(@max_column)
            else string[0, @max_column].ljust(@max_column)
            end

      str.chars do |chr|
        set_character(row: row, column: column, character: chr)
        column += 1
      end
    end

    # +::lines::+
    #   ["line one", "line two"]
    #   ["line one", "line two", "line three"]
    #
    # +::align::+
    #   Optional, either "left", "right", or "center"
    #   Defaults to: "left"
    #
    def set_lines(lines:, align: "left")
      if lines.length >= @max_row
        set_string(row: 0, string: lines[0].to_s, align: align)
        set_string(row: 1, string: lines[1].to_s, align: align)
      else
        set_string(row: 0, string: lines[0].to_s, align: align)
      end
    end

  end
end
