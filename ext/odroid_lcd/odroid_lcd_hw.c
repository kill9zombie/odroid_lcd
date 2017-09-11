//------------------------------------------------------------------------------------------------------------
// An LCD display wiringPi wrapper for the Hardkernel Odroid C2.
//
// Based on: https://dn.odroid.com/source_peripherals/16x2lcdio/example-lcd.c
//------------------------------------------------------------------------------------------------------------

#include "ruby.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include <unistd.h>
#include <string.h>
#include <time.h>

#include <wiringPi.h>
#include <wiringPiI2C.h>
#include <wiringSerial.h>
#include <lcd.h>


//------------------------------------------------------------------------------------------------------------
//
// WiringPi LCD defines
//
//------------------------------------------------------------------------------------------------------------
#define LCD_ROW             2   // 16 Char
#define LCD_COL             16  // 2 Line
#define LCD_BUS             4   // Interface 4 Bit mode

#define PORT_LCD_RS     7
#define PORT_LCD_E      0
#define PORT_LCD_D4     2
#define PORT_LCD_D5     3
#define PORT_LCD_D6     1
#define PORT_LCD_D7     4
 

//-----------------
// Odroidlcd.new
//
// Initialize the LCD screen.
//-----------------
static VALUE odlcd_init(VALUE self) {
  VALUE lcd_handle;

  // Initialize the LCD, raises a RuntimeError if we fail.
  wiringPiSetup();
  lcd_handle = rb_funcall(self, rb_intern("system_init"), 0);

  // We store the wiringPi lcdHandle in an instance variable.
  rb_iv_set(self, "@lcd_handle", lcd_handle);

  return self;
}

static VALUE odlcd_max_column(VALUE self) {
  return INT2FIX(LCD_COL);
}

static VALUE odlcd_max_row(VALUE self) {
  return INT2FIX(LCD_ROW);
}

//---------------
// Clear the lcd screen.
//---------------
static VALUE odlcd_clear(VALUE self) {
  lcdClear(FIX2INT(rb_iv_get(self, "@lcd_handle")));
  return Qnil;
}

//------------------
// Update a character on the LCD screen
//
// lcd = Odroidlcd.new
// lcd.set_character(0, 0, "A")
//
// Note that row must be lower than LCD_ROW and column must be lower than LCD_COL.
// Raises a RuntimeError if the row or column is too large.
//------------------
static VALUE odlcd_set_character(VALUE self, VALUE row, VALUE column, VALUE character) {
  int lcdHandle;

  if (FIX2INT(row) >= LCD_ROW) {
    rb_raise(rb_eRuntimeError, "Invalid row \"%i\", should be less than %i", FIX2INT(row), LCD_ROW);
  }

  if (FIX2INT(column) >= LCD_COL) {
    rb_raise(rb_eRuntimeError, "Invalid column \"%i\", should be less than %i", FIX2INT(column), LCD_COL);
  }

  lcdHandle = FIX2INT(rb_iv_get(self, "@lcd_handle"));

  lcdPosition(lcdHandle, FIX2INT(column), FIX2INT(row));
  rb_iv_set(self, "@lcd_handle", INT2FIX(lcdHandle));

  lcdPutchar(lcdHandle, NUM2CHR(character));
  return Qnil;
}

//------------------------------------------------------------------------------------------------------------
//
// system init
//
//------------------------------------------------------------------------------------------------------------
static VALUE odlcd_system_init(VALUE self) {
    int lcdHandle = 0;

    // LCD Init
    lcdHandle = lcdInit (LCD_ROW, LCD_COL, LCD_BUS,
                         PORT_LCD_RS, PORT_LCD_E,
                         PORT_LCD_D4, PORT_LCD_D5, PORT_LCD_D6, PORT_LCD_D7, 0, 0, 0, 0);

    if(lcdHandle < 0)   {
        rb_raise(rb_eRuntimeError, "%s : lcdInit failed!\n", __func__);
    }
    return INT2FIX(lcdHandle);
}

//------------------------------------------------------------------------------------------------------------

void Init_odroid_lcd_hw() {
  VALUE mOdroidLCD;
  VALUE cOdroidLCD;

  mOdroidLCD = rb_define_module("OdroidLCD");
  cOdroidLCD_HW = rb_define_class_under(mOdroidLCD, "HW", rb_cObject);
  rb_define_method(cOdroidLCD_HW, "initialize", odlcd_init, 0);
  rb_define_method(cOdroidLCD_HW, "clear", odlcd_clear, 0);
  rb_define_method(cOdroidLCD_HW, "max_column", odlcd_max_column, 0);
  rb_define_method(cOdroidLCD_HW, "max_row", odlcd_max_row, 0);
  rb_define_method(cOdroidLCD_HW, "set_character", odlcd_set_character, 3);
  rb_define_private_method(cOdroidLCD_HW, "system_init", odlcd_system_init, 0);
}

//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
