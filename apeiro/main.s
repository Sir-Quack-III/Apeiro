    .org $0000
    strptr: .res 2, $00

    .code

    .import _acia_init
    .import _pr_char

reset:
    jsr _acia_init

    lda #'B'
    jsr _pr_char

loop:
    jmp loop

    .segment "VECTORS"
    .word $0000
    .word reset
    .word $0000