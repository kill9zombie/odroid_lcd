
require 'optparse'

module OdroidLCD
  class CLI

    def initialize(argv, mocks = {})
      @options = parse_arguments(argv)
      @argv = argv

      # If we're testing via the command line, set the mock rather than LCD.
      @lcd = if @options[:test]
        mock_hw = mocks.merge({odroidlcd_hw: OdroidLCD::HWMock.new})
        OdroidLCD::LCD.new(mocks: mock_hw)
      else
        mocks[:lcd] || OdroidLCD::LCD.new(mocks: mocks)
      end

      freeze()
    end

    def run
      lines = if @options.has_key?(:file)
        read_file(@options[:file])
      else
        @argv[0,2].map {|line| line.chomp }
      end

      mode = @options[:split] == true ? :split : :trim
      @lcd.set_lines(lines: lines, mode: mode)


      string = @argv[0]

      rows = @argv[0].lines.map{|l| l.chomp }
      if rows.length > 1
        @lcd.set_string(row: 0, string: rows[0])
        @lcd.set_string(row: 1, string: rows[1])
      else
        @lcd.set_string(row: 0, string: rows[0])
      end

    end

    def parse_arguments(argv)
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: odroid-lcd [options] [first line] [second line]"

        opts.on("--file [FILE]", String, "Read content from a file") do |x|
          options[:file] = x
        end

        opts.on("--test", "Test (not on an odroid)") do |x|
          options[:test] = x
        end

        # opts.on("--split", "Split long lines rather than trimming.") do |x|
        #   options[:split] = x
        # end

        # opts.on("-l", "--loading [PHRASE]", String, "Display a loading screen") do |x|
        #   options[:loading_phrase] = x
        # end

        # opts.on("-p", "--percent [PERCENT]", Integer, "While loading, display a percent complete.") do |x|
        #   options[:loading_percent] = x
        # end

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
