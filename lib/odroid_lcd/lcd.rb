
module OdroidLCD

  class LCDError < StandardError; end

  class LCD

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

    def clear
      @hw.clear
    end

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

    def set_string(row: 0, string:)
      column = 0
      string[0, @max_column].ljust(@max_column - 1).chars do |chr|
        set_character(row: row, column: column, character: chr)
        column += 1
      end
    end

    # +::lines::+
    #   ["line one", "line two"]
    #   ["line one", "line two", "line three"]
    def set_lines(lines:, mode: :trim)
      if lines.length >= @max_row
        set_string(row: 0, string: lines[0].to_s)
        set_string(row: 1, string: lines[1].to_s)
      else
        set_string(row: 0, string: lines[0].to_s)
      end
    end

  end
end
