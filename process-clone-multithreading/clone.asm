global  _start

extern  print_int
extern  print_str


section .data

hello_world:    db      "Hello, world!", 10, 0
hello_room:     db      "Hello, room...", 10, 0
delay_time:     dq      1, 0                    ; s, ns
stack_size:     dq      1024                    ; 1 MB

section .text

delay:  mov     rdi, delay_time
        mov     rax, 35                         ; nanosleep opcode
        syscall
        ret

allocate_stack:
        mov     rdi, 0                          ; addr
        mov     rsi, [stack_size]               ; length
        mov     rdx, 0x3                        ; prot (PROT_READ | PROT_WRITE)
        mov     r10, 0x22                       ; flags (MAP_PRIVATE | MAP_ANONYMOUS)
        mov     r8, -1                          ; fd
        mov     r9, 0                           ; offset
        mov     rax, 9                          ; mmap opcode
        syscall

        add     rax, [stack_size]               ; to get bottom of stack
        ret

print_loop:
.loop:  mov     rdi, [rsp + 8]                  ; addr of string is 2nd from TOS, TOS is return addr
        mov     rsi, 0
        call    print_str
        call    delay
        jmp     .loop

_start:
        call    allocate_stack
        sub     rax, 8                          ; to put string addr
        mov     qword [rax], hello_room
        sub     rax, 8                          ; because print_loop will look at second value from top

        mov     rdi, 0x10d00                    ; flags (CLONE_VM | CLONE_FILES | CLONE_THREAD | CLONE_SIGHAND)
        mov     rsi, rax                        ; stack ptr
        mov     rax, 56                         ; clone opcode
        syscall

        test    rax, rax
        jnz      .main                          ; jmp to main if main process

        jmp     print_loop                      ; child process

.main:
        push    hello_world
        call    print_loop
