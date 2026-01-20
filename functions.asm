global	strlen
global	strcmp
global	strrev
global	atoi
global	itoa
global	uitoa

section	.text

; --- STRLEN (char *s) ---

strlen:	mov	rcx, rdi		; store start addr in rcx

.loop:	cmp	byte [rdi], 0		; check for string terminator
	je	.end			; break loop if end of string
	inc	rdi			; increment *s ptr
	jmp	.loop			; continue loop

.end:	sub	rdi, rcx		; subtract start addr from end addr
	mov	rax, rdi		; store return value in rax

	ret


; --- STRCMP (char *s1, char *s2) ---

strcmp:
	
.loop:	mov	al, byte [rdi]		; load character from s1
	mov	cl, byte [rsi]		; load character from s2

	cmp	al, 0			; check for string terminator
	je	.end			; break loop if end of string

	cmp	al, cl			; compare characters
	jne	.end			; break loop if not equal

	inc	rdi			; increment *s1
	inc	rsi			; increment *s2
	jmp	.loop			; continue loop

.end:	sub	al, cl			; subtract for difference
	movzx	rax, al			; store return value in rax

	ret


; --- ATOI (char *s) ---

atoi:	push	rdi			; store start addr to later check for '-'

	cmp	byte [rdi], '-'		; check if negative
	jne	.positive	
	inc	rdi			; skip one char if negative

.positive:
	xor	rdx, rdx		; clear rdx
	xor	rcx, rcx		; clear rcx

.loop:	mov	cl, byte [rdi]		; load character
	
	cmp	cl, 0			; check for string terminator
	je	.end_loop		; break loop of end of string

	imul	rdx, 10
	sub	cl, '0'			; ascii to int
	add	rdx, rcx

	inc	rdi			; increment *s ptr
	jmp	.loop			; continue loop

.end_loop:
	mov	rax, rdx		; store return value in rax

	pop	rdi			; restore original start addr of string
	cmp	byte [rdi], '-'		; check if '-'
	jne	.end

	neg	rax	
	
.end:	ret


; --- STRREV (char *s) ---

strrev:	push	rdi			; store rdi to return at the end
	push	rdi			; preserve rdi to use after strlen
	call	strlen
	mov	rcx, rax		; store length of string in rcx
	dec	rcx			; decrement 1 for last character index

	pop	rdi			; restore original start addr of string
	add	rcx, rdi		; rcx now holds end of string addr

.loop:	cmp	rdi, rcx		; check left < right
	jge	.end

	mov	al, byte [rdi]		; load character at left
	mov	dl, byte [rcx]		; load character at right
	mov	byte [rdi], dl		; swap
	mov	byte [rcx], al

	inc	rdi			; move pointers
	dec	rcx

	jmp	.loop			; continue loop

.end:	pop	rax			; pop previous rdi value into rax
	ret



; --- ITOA (int i, char *buf) ---

itoa:	push	rsi			; store buf addr to return
	cmp	rdi, 0			; check if negative
	jge	.positive

	mov	byte [rsi], '-'		; add - in buf if negative
	inc	rsi			
	neg	rdi			; rest of the number can be treated as positive

.positive:
	call	uitoa			; convert positive number to ascii
	pop	rax			; restore buffer start addr to return
	ret

; --- UITOA (int i, char *buf) ---

uitoa:	push	rsi			; push buffer start address to stack
	
	mov	r9, 10			; base for division
	mov	rax, rdi		; load number to rax for division

.loop:	xor	rdx, rdx		; clear rdx for division
	div	r9

	add	rdx, '0'		; convert remainder to ascii
	mov	byte [rsi], dl		; store ascii in buffer
	inc	rsi			; increment buffer ptr

	test	rax, rax		; stop if number is 0
	jg	.loop

.end:	mov	byte [rsi], 0		; add string terminator
	
	pop	rdi			; pop buffer start addr into rdi
	call	strrev

	ret
