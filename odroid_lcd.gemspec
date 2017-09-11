require_relative "lib/odroid_lcd"

Gem::Specification.new do |s|
  s.name        = 'odroid_lcd'
  s.version     = OdroidLCD::VERSION
  s.summary     = "LCD screen utils for the Hardkernel Odroid C2"
  s.description = "Allows writing strings to the LCD screen accessory, see: https://wiki.odroid.com/accessory/display/16x2_lcd_io_shield/c/start"
  s.authors     = ["Phil Helliwell"]
  s.email       = 'phil.helliwell@gmail.com'
  s.files       = `git ls-files -z`.split("\x0")
  s.required_ruby_version = '~> 2.0'
  s.homepage    = 'http://github.com/kill9zombie/odroid_lcd'
  s.license       = 'MIT'
  s.executables << 'odroid-lcd'
  s.extensions = %w[ext/odroid_lcd/extconf.rb]
  s.requirements << 'WiringPi patched by Hardkernel, see: https://wiki.odroid.com/accessory/display/16x2_lcd_io_shield/c/start'
end
