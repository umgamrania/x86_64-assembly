global  read_int
global  read_str

extern  print_str
extern  atoi

section .bss
read_int_buf:      resb            64

section .text

; --- READ_INT() ---

read_int:
        mov     rdi, 0                  ; stdin
        mov     rsi, read_int_buf       ; buf
        mov     rdx, 64                 ; count
        mov     rax, 0                  ; read opcode
        syscall

        mov     rdi, read_int_buf
        call    atoi

        ret

; --- READ_STR(char *buf, int len) ---

read_str:
        mov     rdx, rsi                ; load count
        mov     rsi, rdi                ; load buf
        mov     rdi, 0                  ; stdin
        mov     rax, 0                  ; read opcode
        syscall

        ret
