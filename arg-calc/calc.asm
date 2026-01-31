global	_start

extern	atoi
extern	print_str
extern	print_int

section	.data
usage:		db	"USAGE: ./calc [operand 1] [operator] [operand 2]", 0
invalid_opr:	db	"Invalid operator!", 0
zero_div:	db	"Cannot divide by zero!", 0

section	.text

_start:	mov	rax, [rsp]		; Load argc
	cmp	rax, 4
	jl	.show_usage

	mov	rdi, [rsp + 2*8]	; parse operand 1
	call	atoi
	push	rax			; push operand 1 on stack

	mov	rdi, [rsp + 3*8]	; read operator
	mov	rbx, [rdi]		; store operator in rbx

	mov	rdi, [rsp + 4*8]	; parse operand 2
	call	atoi			; operand 2 is now in rax

	mov	r10, rax
	pop	rax			; restore operand 1 from stack

	cmp	bl, '+'
	je	.add

	cmp	bl, '-'
	je	.sub

	cmp	bl, '*'
	je	.mul

	cmp	bl, '/'
	je	.div



.add:	add	rax, r10
	jmp	.answer

.sub:	sub	rax, r10
	jmp	.answer

.mul:	imul	rax, r10
	jmp	.answer

.div:	xor	rdx, rdx		; clear rdx for division
	cqo				; sign extend rax into rdx:rax
	idiv	r10
	jmp	.answer

.answer:
	mov	rdi, rax
	mov	rsi, 1
	call	print_int
	jmp	.exit

.show_usage:
	mov	rdi, usage
	mov	rsi, 1
	call	print_str

.exit:	mov	rdi, 0
	mov	rax, 60
	syscall
