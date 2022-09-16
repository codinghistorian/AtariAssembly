    processor 6502
    seg Code ; Define a new segment named "Code"
    org $F000 ; Define the origin of the ROM code at memory address $F000
Start:
    ; TODO:
    LDA #1            ; Load the A register with the decimal value 1
    LDX #2            ; Load the X register with the decimal value 2
    LDY #3            ; Load the Y register with the decimal value 3
    INX            ; Increment X
    INY            ; Increment Y
    clc
    ADC #1            ; Increment A
    dex            ; Decrement X
    dey            ; Decrement Y

    sec
    sbc #1            ; Decrement A
    org $FFFC ; End the ROM by adding required values to memory position $FFFC
    .word Start ; Put 2 bytes with the reset address at memory position $FFFC
    .word Start ; Put 2 bytes with the break address at memory position $FFFE