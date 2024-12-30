{
---------------------------------------------------------------------------------------------------
    Filename:       display.led.max72xx.spin
    Description:    Driver for the MAX72xx LED/7-segment display driver
    Author:         Jesse Burt
    Started:        Jul 24, 2022
    Updated:        Dec 30, 2024
    Copyright (c) 2024 - See end of file for terms of use.
---------------------------------------------------------------------------------------------------
}

CON

    CS      = 0
    SCK     = 1
    MOSI    = 2
    WIDTH   = 8


    { decimal point bit }
    DPNT    = (1 << 7)


VAR

    long _CS

    byte _disp_buffer[WIDTH], _ptr


OBJ

{ decide: Bytecode SPI engine, or PASM? Default is PASM if BC isn't specified }
#ifdef MAX72XX_SPI_BC
    spi:    "com.spi.25khz.nocog"               ' BC SPI engine
#else
    spi:    "com.spi.4mhz"                      ' PASM SPI engine
#endif
    core:   "core.con.max72xx"                  ' hw-specific constants
    time:   "time"                              ' timing functions


PUB null()
' This is not a top-level object


PUB start(): status
' Start the driver using default I/O settings
    return startx(CS, SCK, MOSI)


PUB startx(CS_PIN, SCK_PIN, MOSI_PIN): status
' Start using custom IO pins
'   CS_PIN:     SPI chip select, 0..31
'   SCK_PIN:    serial clock, 0..31
'   MOSI_PIN:   master-out slave-in, 0..31
    if ( lookdown(CS_PIN: 0..31) and lookdown(SCK_PIN: 0..31) and lookdown(MOSI_PIN: 0..31) )
        if ( status := spi.init(SCK_PIN, MOSI_PIN, -1, core.SPI_MODE) )
            time.msleep(core.T_POR)             ' wait for device startup
            _CS := CS_PIN                       ' copy i/o pin to hub var
            outa[_CS] := 1
            dira[_CS] := 1
            disp_sz(WIDTH)
            return
    ' if this point is reached, something above failed
    ' Re-check I/O pin assignments, bus speed, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE


PUB stop()
' Stop the driver
    spi.deinit()
    _CS := _ptr := 0
    bytefill(@_disp_buffer, 0, WIDTH)


PUB defaults()
' Set factory defaults
    powered(false)
    disp_sz(8)
    decode_mode(%00000000)
    powered(true)


PUB brightness(l)
' Set the display brightness
'   l:  level, 0..15
    writereg(core.INTENS, (0 #> l <# 15))


PUB clear() | i
' Clear the display
    _ptr := 0
    bytefill(@_disp_buffer, 0, WIDTH)
    repeat i from 0 to WIDTH-1
        writereg(core.DIG_0+i, 0)


PUB decode_mode(m)
' Set decode mode mask for digit display
'   mode:   bitmask b7..0
'       (set bits enable BCD decoding for the corresponding digit)
    writereg(core.DECOD_MD, m)


PUB disp_sz(d)
' Limit number of displayed digits
'   d:  number of digits, 1..8
    writereg(core.SCAN_LIM, (1 #> d <# 8)-1)


pub pos_xy(x, y)
' Set display cursor position
'   (y is currently unused)
    _ptr := x


PUB powered(s)
' Enable display power
'   s:
'       TRUE (non-zero values): power on
'       FALSE (0): power off
    if ( s )
        writereg(core.SHUTDN, 1)
    else
        writereg(core.SHUTDN, 0)


PUB putchar(ch) | cmap, d
' Display a single character
    case ch
        " ", "-":
            ch := byte[@_charmap][lookdownz(ch: " ", "-")]
        "0".."9":
            cmap := lookdownz(ch: "0".."9")
            ch := byte[@_charmap][cmap+2]
        other:
            return

    _disp_buffer[_ptr] := ch

    repeat d from 0 to WIDTH-1
        outa[_CS] := 0
            spi.wr_byte(core.DIG_7-d)
            spi.wr_byte(_disp_buffer[d])
        outa[_CS] := 1

    _ptr++
    if ( _ptr > WIDTH-1 )
        _ptr := WIDTH-1


PUB test_mode(s)
' Enable test mode
    writereg(core.DISP_TEST, s)


PRI writereg(reg_nr, val)
' Write nr_bytes to the device from ptr_buff
    if ( lookdown(reg_nr: core.NO_OP..core.DISP_TEST) )
        outa[_CS] := 0
            spi.wr_byte(reg_nr)
            spi.wr_byte(val)
        outa[_CS] := 1


DAT

_charmap    byte    %000_0000   ' <space>
            byte    %000_0001   ' -
_digits     byte    %111_1110   ' 0
            byte    %011_0000
            byte    %110_1101
            byte    %111_1001
            byte    %011_0011
            byte    %101_1011
            byte    %101_1111
            byte    %111_0000
            byte    %111_1111
            byte    %111_1011   ' 9


#include "terminal.common.spinh"


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

