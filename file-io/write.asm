global	_start

extern	strlen
extern	print_str

section	.data
usage:		db	"USAGE: ./write [filename] [content]", 10, 0
failed:		db	"Failed to open file!", 10, 0

section	.text

_start:	mov	rax, [rsp]
	cmp	rax, 3
	jl	.show_usage

	; Open file
	mov	rdi, [rsp + 2*8]
	mov	rsi, 577		; O_WRONLY | O_CREAT | O_TRUNC
	mov	rdx, 0644o		; O_CREAT
	mov	rax, 2			; open opcode
	syscall

	mov	rbx, rax

	mov	rdi, [rsp + 3*8]
	call	strlen

	mov	rdx, rax
	mov	rsi, [rsp + 3*8]
	mov	rdi, rbx
	mov	rax, 1
	syscall

	jmp	.exit

.failed:
	mov	rdi, failed
	mov	rsi, 0
	call	print_str
	jmp	.exit

.show_usage:
	mov	rdi, usage
	mov	rsi, 0
	call	print_str

.exit:	mov	rdi, 0
	mov	rax, 60
	syscall
