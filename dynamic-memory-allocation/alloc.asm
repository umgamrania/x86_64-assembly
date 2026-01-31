global  _start

extern  print_int
extern  print_str
extern  read_int

section .data
msg1:   db      "Enter size: ", 10, 0
msg2:   db      "NUMBERS: ", 10, 0
msg3:   db      "Memory freed!", 10, 0
msg4:   db      "Failed to free memory!", 10, 0

section .bss
buf:                    resq    1
buf_size:               resq    1

section .text

; --- ALLOC(int size) ---

alloc:
        mov     rsi, rdi                        ; length
        mov     rdi, 0                          ; target addr
        mov     rdx, 0x3                        ; prot (PROT_READ | PROT_WRITE)
        mov     r10, 0x22                       ; flags (MAP_PRIVATE | MAP_ANONYMOUS)
        mov     r8, -1                          ; fd
        mov     r9, 0                           ; offset
        mov     rax, 9                          ; mmap opcode
        syscall

        ret


; --- FREE(void *ptr, int size) ---

free:   mov     rax, 0x0b                       ; munmap opcode
        syscall

        ret


_start: mov     rdi, msg1
        call    print_str

        call    read_int
        mov     qword [buf_size], rax

        mov     rdi, rax
        call    alloc
        mov     qword [buf], rax

        mov     rbx, qword [buf_size]
        dec     rbx

.loop:  cmp     rbx, 0
        je      .end_loop

        mov     rax, [buf]
        mov     byte [rax + rbx], bl

        dec     rbx

        jmp     .loop

.end_loop:
        mov     rdi, msg2
        mov     rsi, 0
        call    print_str

        mov     r15, 0

.loop2: cmp     rbx, qword [buf_size]
        jge     .end

        mov     rax, [buf]
        movzx   rdi, byte [rax + rbx]
        mov     rsi, 1
        call    print_int

        inc     rbx

        jmp     .loop2

.end:   mov     rdi, [buf]
        mov     rsi, [buf_size]
        call    free

        cmp     rax, 0
        jne     .failed
.freed:
        mov     rdi, msg3
        mov     rsi, 0
        call    print_str
        jmp     .exit

.failed:
        mov     rdi, msg4
        mov     rsi, 0
        call    print_str

.exit:
        mov     rdi, 0
        mov     rax, 60
        syscall
