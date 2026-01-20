global	_start

extern	sprint
extern	iprint

section	.bss
buf:	resb	8
fd:	resq	1

section	.data
usage:		db	"USAGE: ./read [filename]", 0
notfound:	db	"File not found!", 0

section	.text

_start:	mov	rax, [rsp]		; Load argc
	cmp	rax, 2
	jl	.show_usage

	; Open file
	mov	rdi, [rsp + 2*8]	; argv[1]
	mov	rsi, 0			; O_RDONLY
	mov	rdx, 0			; no extra mode
	mov	rax, 2			; open opcode
	syscall

	cmp	rax, 0
	jl	.notfound

	mov	[fd], rax

.loop:	mov	rdi, [fd]
	mov	rsi, buf
	mov	rdx, 8
	mov	rax, 0
	syscall

	cmp	rax, 0
	je	.close

	mov	rdi, 1			; stdout
	mov	rsi, buf
	mov	rdx, rax
	mov	rax, 1
	syscall

	jmp	.loop

.close:	mov	rdi, [fd]
	mov	rax, 3
	syscall

	jmp	.exit

.notfound:
	mov	rdi, notfound
	mov	rsi, 1
	call	sprint
	jmp	.exit

.show_usage:
	mov	rdi, usage
	mov	rsi, 1
	call	sprint

.exit:	mov	rdi, 0
	mov	rax, 60
	syscall
