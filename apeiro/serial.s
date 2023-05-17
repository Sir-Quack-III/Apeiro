ACIA_DATA = $5000
ACIA_STATUS = $5001
ACIA_CMD = $5002
ACIA_CTRL = $5003

	.code

	.export _acia_init, _pr_byte, _pr_nl, _pr_char

; ~~~~~
; RESET
; ~~~~~

_acia_init:
	lda #$00
	sta ACIA_STATUS

	lda #$1f ; 19200 baud rate, 8 bits, no parity
	sta ACIA_CTRL

	lda #$0b
	sta ACIA_CMD

	rts


_pr_byte:
	phx
	pha

	; get high nibble
	and #%11110000
	lsr
	lsr
	lsr
	lsr

	tax
	lda hexbits,x
	jsr _pr_char

	pla
	pha

	and #%00001111

	tax
	lda hexbits,x
	jsr _pr_char

	pla
	plx
	rts

_pr_char:
	sta ACIA_DATA
	pha
tx_wait:
	lda ACIA_STATUS
	and #$10 ; check if its already tryin to send something
	beq tx_wait
	jsr tx_delay

	pla
	rts

tx_delay: ; delay because WDC is dumb >:(
	phx
	ldx #100
tx_delay_1:
	dex 
	bne tx_delay_1
	plx
	rts

_pr_nl:
	lda #$0d
	jsr _pr_char
	lda #$0a
	jsr _pr_char
	rts

; ~~~~~~~~~
; CONSTANTS
; ~~~~~~~~~
hexbits: .asciiz "0123456789abcdef"
