require 'mkmf'

have_library('pthread')
have_library('wiringPi')
have_library('wiringPiDev')

create_makefile('odroid_lcd/odroid_lcd_hw')
