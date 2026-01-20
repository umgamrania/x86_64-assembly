global	_start

extern	iprint
extern	sprint
extern	strlen

section	.bss
sock_fd:	resq		1
client_fd:	resq		1
buf:		resb		1024

section	.data
failed:		db		"Failed to create socket!", 10, 0
fail_bind:	db		"Failed to bind!", 10, 0

msg_wait_client:db		"Waiting for client...", 10, 0
msg_client_connected:
		db		"Client connected!", 10, 0
msg_wait_msg:	db		"Waiting for message...", 10, 0

text_client:	db		"Client: ", 0
sockaddr:
	dw	2		; AF_INET
	dw	0x901F		; port (8080)
	db	127, 0, 0, 1	; 127.0.0.1

section	.text

_start:	
	; CREATE SOCKET

	mov	rdi, 2		; AF_INET
	mov	rsi, 1		; SOCK_STREAM
	mov	rdx, 6		; IPPROTO_TCP
	mov	rax, 41		; socket opcode
	syscall

	cmp	rax, 0
	jl	.failed

	mov	[sock_fd], rax	; store socket fd in variable

	; SETSOCKOPT SO_REUSEADDR
	mov     rdi, [sock_fd]
	mov     rsi, 1          ; level, SOL_SOCKET
	mov     rdx, 2          ; SO_REUSEADDR
	push    dword 1
	mov     r10, rsp
	mov     r8, 4
	mov     rax, 54
	syscall


	; BIND

	mov	rdi, [sock_fd]	; sock_fd
	mov	rsi, sockaddr	; sockaddr struct
	mov	rdx, 16		; length of sockaddr
	mov	rax, 49		; bind opcode
	syscall

	cmp	rax, 0
	jl	.fail_bind

	; LISTEN

	mov	rdi, [sock_fd]
	mov	rsi, 5		; backlog
	mov	rax, 50		; listen opcode
	syscall


	mov	rdi, msg_wait_client
	mov	rsi, 0
	call	sprint

	; ACCEPT

	mov	rdi, [sock_fd]
	mov	rsi, 0		; remote addr not required
	mov	rdx, 0		; 0 since remote addr is 0
	mov	rax, 43		; accept opcode
	syscall

	mov	[client_fd], rax	; store client socket fd

	mov	rdi, msg_client_connected
	mov	rsi, 0
	call	sprint
	
.loop:	mov	rdi, msg_wait_msg
	mov	rsi, 0
	call	sprint

	; READ

	mov	rdi, [client_fd]
	mov	rsi, buf
	mov	rdx, 1024
	mov	rax, 0
	syscall

	cmp	rax, 0
	je	.exit

	; PRINT

	mov	rdi, text_client
	mov	rsi, 0
	call	sprint

	mov	rdi, buf
	mov	rsi, 1
	call	sprint

	jmp	.loop


.fail_bind:
	mov	rdi, fail_bind
	mov	rsi, 0
	call	sprint
	jmp	.exit

.failed:
	mov	rdi, failed
	mov	rsi, 0
	call	sprint

.exit:	mov	rdi, 0
	mov	rax, 60
	syscall
