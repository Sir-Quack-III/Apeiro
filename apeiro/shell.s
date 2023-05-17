ACIA_DATA = $5000
ACIA_STATUS = $5001
ACIA_CMD = $5002
ACIA_CTRL = $5003

    .code

    .import _pr_char, _pr_nl

_shell_begin:
    ldx #0
print_logo:
	lda apeiro_logo,x
	beq print_logo_1
	jsr _pr_char
	inx
	jmp print_logo
print_logo_1:

; MAIN LOOP
_shell_loop:
    lda #'>'
	jsr _pr_char
rx_wait:
	lda ACIA_STATUS ; waits
	and #$08
	beq rx_wait

	lda ACIA_DATA

	pha
	eor #$0d
	beq enter
	pla

	pha
	eor #$08
	beq backspace
	pla

	jsr _pr_char

	jmp rx_wait

; ##############
; #  COMMANDS  #
; ##############


enter:
	pha
	lda #$0d
	jsr _pr_char
	lda #$0a
	jsr _pr_char
	lda #'>'
	jsr _pr_char
	pla
	jmp rx_wait

backspace:
	pha
	phx
	ldx #0
backspace_1:
	lda delete,x
	beq backspace_2
	jsr _pr_char
	inx
	jmp backspace_1
backspace_2:
	plx
	pla
	jmp rx_wait


; #####################
; #  END OF COMMANDS  #
; #####################

; CONSTANTS

apeiro_logo:
	.byte "  @@@@    @@@@"
	.byte $0d, $0a
	.byte " @####@ @@####@"
	.byte $0d, $0a
	.byte "@#   ##@##   #@"
	.byte $0d, $0a
	.byte "@####@@ @####@"
	.byte $0d, $0a
	.byte " @@@@    @@@@"
	.byte $0d, $0a
	.byte "Apeiro Operating System v0.01"
	.byte $0d, $0a, $00

delete:
	.byte $1b, '[', '1', 'D' ; move cursor 1 line left
	.byte $1b, '[', '0', 'J' ; clear screen from cursor
	.byte $00 ; null terminator