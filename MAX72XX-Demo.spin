{
---------------------------------------------------------------------------------------------------
    Filename:       MAX72XX-Demo.spin
    Description:    Demo of the MAX72XX driver
        * 7-segment display output
    Author:         Jesse Burt
    Started:        Dec 30, 2024
    Updated:        Dec 30, 2024
    Copyright (c) 2024 - See end of file for terms of use.
---------------------------------------------------------------------------------------------------
}
' Uncomment the two lines below to use the bytecode-based SPI engine in the driver
'#define MAX72XX_SPI_BC
'#pragma exportdef(MAX72XX_SPI_BC)

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    time:   "time"
    str:    "string"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    led:    "display.led.max72xx" | CS=0, SCK=1, MOSI=2


PUB main() | i

    setup()

    led.brightness(4)                           ' 0..15
    led.clear()

    repeat
        repeat i from 0 to 1234_5678
            led.pos_xy(0, 0)
            led.puts(str.decpads(i, 8))


PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( led.start() )
        ser.strln(@"MAX7219 driver started")
        led.defaults()
    else
        ser.strln(@"MAX7219 driver failed to start - halting")
        repeat


DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

