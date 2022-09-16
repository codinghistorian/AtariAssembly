    processor 6502

    include "vsc.h"
    include "macro.h"

    seg code
    org $F000   ;defines the origin of the ROM at $F0000

START:
    ;CLEAN_START ;   Macro to safely clear the memory
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set background luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #$1E    ; Load color into A ($1E is NTSC yellow)
    sta COLUBK  ; STORE A TO BACKGROUND COLOR ADDRESS $09

    jmp START  ; Repeat from START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FILL ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

    org $FFFC   ; Defines origin to $FFFC
    .word START ; Reset vectot at $FFFC (where the program start)
    .word START ; Interrupt vector at $FFFE (unused in the VCS)