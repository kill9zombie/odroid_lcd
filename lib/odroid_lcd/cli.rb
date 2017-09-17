
require 'optparse'

module OdroidLCD
  class CLI

    def initialize(argv, mocks = {})
      @options = parse_arguments(argv)
      @argv = argv

      # If we're testing via the command line, set the mock rather than LCD.
      @lcd = if @options[:test]
        @hw_mock = OdroidLCD::HWMock.new
        mock_hw = mocks.merge({odroidlcd_hw: @hw_mock})
        OdroidLCD::LCD.new(mocks: mock_hw)
      else
        OdroidLCD::LCD.new(mocks: mocks)
      end

      # set the default text alignment
      @align = @options[:align] || "left"

      freeze()
    end


    def run
      lines = if @options.has_key?(:file)
        read_file(@options[:file])
      else
        @argv[0,2].map {|line| line.chomp }
      end

      @lcd.set_lines(lines: lines, align: @align)

      if @options[:test]
        show_mocked_lcd()
      end
    end

    def show_mocked_lcd
      puts "[#{@hw_mock.get(row: 0).join}]"
      puts "[#{@hw_mock.get(row: 1).join}]"
    end


    def parse_arguments(argv)
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: odroid-lcd [options] [first line] [second line]"

        opts.on("-f", "--file=FILE", String, "Read content from a file") do |x|
          if x == nil
            puts opts
            exit 2
          end
          options[:file] = x
        end

        opts.on("--test", "Dry run test (does not update the screen)") do |x|
          options[:test] = x
        end

        opts.on("--align=ALIGN", String, "Align text: left, right, center") do |x|
          if x == nil
            puts opts
            exit 2
          end
          options[:align] = x
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end

      end.parse!
      options
    end

    def read_file(filename)
      file = if (filename == '-')
        $stdin
      else
        File.open(filename, "r")
      end

      file.readlines.map {|line| line.chomp }
    end


  end
end
