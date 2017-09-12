module OdroidLCD
  class CLI

    def initialize
      @lcd = OdroidLCD::LCD.new
    end

    def run(argv)
      string = argv[0]

      rows = argv[0].lines.map{|l| l.chomp }
      if rows.length > 1
        @lcd.set_string(row: 0, string: rows[0])
        @lcd.set_string(row: 1, string: rows[1])
      else
        @lcd.set_string(row: 0, string: rows[0])
      end

    end

  end
end
