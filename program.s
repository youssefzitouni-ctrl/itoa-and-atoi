.intel_syntax noprefix

.global itoa
.global atoi
.global _start

_start:
    mov r13, qword ptr [rsp]
    xor r12, r12
    cmp r13, 1
    je no_args
    lea r14, [rsp + 16]
    mov r15, r13
    imul r15, 8
    add r15, rsp
    add r15, 8
    call boss

begin_itoa:
    xor r8, r8
    xor r9, r9
    xor r10, r10
    xor rdx, rdx
    xor rcx, rcx
    sub rsp, 32
    mov r15, rsp
    mov rsi, r15
    mov rdi, r12
    call itoa
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, r15
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

no_args:
    sub rsp, 32
    mov rsi, rsp
    mov byte ptr [rsi], '0'
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

boss:
boss_loop:
    cmp r14, r15
    je boss_done
    mov rdi, qword ptr [r14]
    call atoi
    add r12, rax
    add r14, 8
    jmp boss_loop

boss_done:
    jmp begin_itoa

itoa:
    xor r8, r8
    xor r9, r9
    xor r10, r10
    xor rdx, rdx
    xor rcx, rcx
    mov rax, rdi
    cmp rax, 0
    je zero
    mov r9, 1
    cmp rax, 0
    jl negate
    call loop
    ret

negate:
    neg rax
    mov byte ptr [rsi], '-'
    inc rsi
    mov r10, 1
    call loop
    ret

zero:
    mov byte ptr [rsi], 0x30
    mov rax, 1
    ret

loop:
    xor rdx, rdx
    mov rcx, 10
    div rcx
    push rdx
    cmp rax, 0
    je prntr
    inc r9
    jmp loop

prntr:
    xor r8, r8
prnt:
    pop rax
    add al, 0x30
    mov byte ptr [rsi+r8], al
    inc r8
    cmp r8, r9
    jne prnt
    mov rax, r9
    add rax, r10
    ret

atoi:
    xor rdx, rdx
    cmp byte ptr [rdi], '-'
    je rem
    call atoi_f
    ret

rem:
    inc rdi
    call atoi_f
    neg rax
    ret

atoi_f:
    cmp byte ptr [rdi], '9'
    ja don
    cmp byte ptr [rdi], '0'
    jb don
    call atoi_digit
    imul rdx, 10
    add rdx, rax
    inc rdi
    call atoi_f
    ret

don:
    mov rax, rdx
    ret

atoi_digit:
    movsx rax, byte ptr [rdi]
    sub rax, 48
    ret
