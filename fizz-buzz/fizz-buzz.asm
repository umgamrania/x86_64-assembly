global	_start

extern	sprint
extern	iprint
extern	atoi

section	.data
usage:		db	"USAGE: ./fizz-buzz [n]", 10, 0
fizz:		db	"Fizz", 0
buzz:		db	"Buzz", 0
nl:		db	10, 0

section	.text

_start:	mov	rax, [rsp]		; Load argc
	cmp	rax, 2
	jl	.show_usage

	mov	rdi, [rsp + 2*8]
	call	atoi
	mov	rbx, rax		; Limit
	mov	rcx, 1			; Counter

	mov	r12, 0			; flag
	mov	r13, 3
	mov	r14, 5

.loop:	cmp	rcx, rbx
	jg	.exit

	mov	r12, 0
	xor	rdx, rdx		; Clear rdx for division
	mov	rax, rcx		; Load number in rax
	
	idiv	r13
	cmp	rdx, 0
	jne	.check_five

	mov	r12, 1
	
	push	rcx			; preserve rcx
	mov	rdi, fizz
	mov	rsi, 0
	call	sprint
	pop	rcx

.check_five:
	xor	rdx, rdx
	mov	rax, rcx

	idiv	r14
	cmp	rdx, 0
	jne	.print_num

	mov	r12, 1
	
	push	rcx
	mov	rdi, buzz
	mov	rsi, 0
	call	sprint
	pop	rcx

.print_num:
	test	r12, r12
	jnz	.continue

	push	rcx
	mov	rdi, rcx
	mov	rsi, 0
	call	iprint
	pop	rcx

.continue:
	push	rcx
	mov	rdi, nl
	mov	rsi, 0
	call	sprint
	pop	rcx

	inc	rcx
	jmp	.loop

.show_usage:
	mov	rdi, usage
	mov	rsi, 0
	call	sprint

.exit:	mov	rdi, 0
	mov	rax, 60
	syscall
