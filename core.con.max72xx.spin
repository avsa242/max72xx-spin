{
---------------------------------------------------------------------------------------------------
    Filename:       core.con.max72xx.spin
    Description:    MAX72xx-specific constants
    Author:         Jesse Burt
    Started:        Jul 24, 2022
    Updated:        Dec 30, 2024
    Copyright (c) 2024 - See end of file for terms of use.
---------------------------------------------------------------------------------------------------
}

CON

    { SPI Configuration }
    SPI_MAX_FREQ    = 10_000_000                ' device max SPI bus freq
    SPI_MODE        = 0                         ' 0..3
    T_POR           = 0                         ' startup time (usecs)


    { Register definitions }
    NO_OP           = $00
    DIG_0           = $01
    DIG_1           = $02
    DIG_2           = $03
    DIG_3           = $04
    DIG_4           = $05
    DIG_5           = $06
    DIG_6           = $07
    DIG_7           = $08
    DECOD_MD        = $09
    INTENS          = $0A
    SCAN_LIM        = $0B
    SHUTDN          = $0C
    DISP_TEST       = $0F


PUB null()
' This is not a top-level object


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

