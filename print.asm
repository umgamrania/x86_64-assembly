global	sprint
global	iprint
global	uiprint

extern	itoa
extern	uitoa
extern	strlen

section	.bss
iprintbuf:	resb	32

section	.text

; --- SPRINT (char *s, bool new_line) ---

sprint:	push	rsi			; push rsi for later use
	push	rdi			; push *s before strlen
	call	strlen
	pop	rdi

	mov	rsi, rdi		; *s
	mov	rdx, rax		; move return value of strlen to rdx
	mov	rdi, 1			; stdout
	mov	rax, 1			; write opcode
	syscall

	pop	rsi
	cmp	rsi, 0
	je	.end			; just return if new_line is 0

	push	0xA			; push new line string to stack
	mov	rdi, 1			; stdout
	mov	rsi, rsp		; buf
	mov	rdx, 2			; count
	mov	rax, 1			; write opcode
	syscall

	add	rsp, 8			; remove new line char from stack

.end:	ret


; --- IPRINT (int i, bool new_line) ---

iprint:	push	rsi			; push rsi for later use
	
	mov	rsi, iprintbuf		; convert int to ascii and store in buf
	call	itoa
	
	pop	rsi			; restore new_line value
	mov	rdi, iprintbuf		; print converted buf
	call	sprint

	ret


; --- UIPRINT (int i, bool new_line) ---

uiprint:
	push	rsi			; push rsi for later use
	
	mov	rsi, iprintbuf		; convert int to string in buf
	call	uitoa

	pop	rsi
	mov	rdi, iprintbuf
	call	sprint

	ret
