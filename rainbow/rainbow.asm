    processor 6502

    include "vsc.h"
    include "macro.h"

    seg code
    org $F000

Start:
    CLEAN_START     ; macro to safely clear memory and TIA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Start a new frame by turning on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame:
    lda #2      ; same as binary value %00000010
    sta VBLANK  ; turn on the VBLANK
    sta VSYNC   ; turn on VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Generate the three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    sta WSYNC   ; first scanline
    sta WSYNC   ; second scanline
    sta WSYNC   ; third scanline

    lda #0
    sta VSYNC ; turn off VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Let the TIA output the recommended 37 scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldx #37     ; X = 37 (to count 37 scanlines)

LoopVBLANK:
    sta WSYNC   ; hit WSYNC and wait for the next scanline
    dex         ; X--
    bne LoopVBLANK ; loop while X!=0

    lda #0
    sta VBLANK     ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Draw 192 visible scanlines (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldx #192        ;counter for 192 visible scanlines
LoopVisible:
    stx COLUBK      ; set the badckground color
    sta WSYNC       ; wait for the next scanline
    dex             ; X--
    bne LoopVisible    ; loop while X != 0;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Output 30 more VBLANK lines (overscan) to complete our frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2          ; hit and turn on VBLANK again
    sta VBLANK

    ldx #30         ; counter for 30 scanlines
LoopOverscan:
    sta WSYNC       ; wait for the next scanline
    dex             ; X--
    bne LoopOverscan; loop while X != 0

    jmp NextFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Complete my ROM size to 4 KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    .word Start
    .word Start