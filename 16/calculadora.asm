%include "soma.asm"
%include "subtracao.asm"
%include "multiplicacao.asm"
%include "divisao.asm"
%include "mod.asm"
%include "exponenciacao.asm"

section .data
  M_name  db "Bem vindo. Digite seu nome: ",0
  M_name_len dd 29
  M_hola1 db "Hola, ",0
  M_hola1_len dd 7
  M_hola2 db ", bem-vindo ao programa de CALC IA-32",0x0A,0
  M_hola2_len dd 38

  M_menu_1  db "ESCOLHA UMA OPÇÃO:",0x0A,0
  M_menu_len_1 dd 22
  M_menu_2  db "- 1: SOMA",0x0A,0
  M_menu_len_2 dd 11
  M_menu_3  db "- 2: SUBTRAÇÃO",0x0A,0
  M_menu_len_3 dd 18
  M_menu_4  db "- 3: MULTIPLICAÇÃO",0x0A,0
  M_menu_len_4 dd 22
  M_menu_5  db "- 4: DIVISÃO",0x0A,0
  M_menu_len_5 dd 15
  M_menu_6  db "- 5: EXPONENCIAÇÃO",0x0A,0
  M_menu_len_6 dd 22
  M_menu_7  db "- 6: MOD",0x0A,0
  M_menu_len_7 dd 10
  M_menu_8  db "- 7: SAIR",0x0A,0
  M_menu_len_8 dd 11
  M_minus_sign db "-",0

  M_overflow db "OCORREU OVERFLOW",0x0A,0
  M_overflow_len dd 17

section .bss
  user_name resb 100
  user_name_len resd 1

  num_buffer resb 100

section .text
  global _start

;==========================
; MAIN
;==========================
_start:
  push M_name
  push DWORD [M_name_len]
  call print

  push user_name
  push user_name_len
  call read_string

  ; Greets the user
  push M_hola1
  push DWORD [M_hola1_len]
  call print
  push user_name
  push DWORD [user_name_len]
  call print
  push M_hola2
  push DWORD [M_hola2_len]
  call print

MENU_LOOP:
  call print_menu
  call read_number

  cmp eax, 1
  je OP_SOMA
  cmp eax, 2
  je OP_SUBTRACAO
  cmp eax, 3
  je OP_MULTIPLICACAO
  cmp eax, 4
  je OP_DIVISAO
  cmp eax, 5
  je OP_EXPONENCIACAO
  cmp eax, 6
  je OP_MOD
  cmp eax, 7
  je OP_SAIR

OP_SOMA:
  call SOMA
  jmp MENU_LOOP
OP_SUBTRACAO:
  call SUBTRACAO
  jmp MENU_LOOP
OP_MULTIPLICACAO:
  call MULTIPLICACAO
  jmp MENU_LOOP
OP_DIVISAO:
  call DIVISAO
  jmp MENU_LOOP
OP_EXPONENCIACAO:
  call EXPONENCIACAO
  jmp MENU_LOOP
OP_MOD:
  call MOD
  jmp MENU_LOOP
OP_SAIR:
  call exit

; Print - Print a string indicated by a pointer
; Args: - ptr [EBP + 12]
;       - len [ESP + 8]
; Return: None
; Example:
;   push M_name
;   push DWORD [M_name_len]
;   call print
print:
  push ebp
  mov ebp, esp

  mov eax, 4
  mov ebx, 1
  mov ecx,[ebp + 12]
  mov edx,[ebp + 8]
  int 80h

  pop ebp
  ret 8

; Print Menu: Calls print 8 times to print each line of the menu
; Args: None. Return: None
print_menu:
  push M_menu_1
  push DWORD [M_menu_len_1]
  call print
  push M_menu_2
  push DWORD [M_menu_len_2]
  call print
  push M_menu_3
  push DWORD [M_menu_len_3]
  call print
  push M_menu_4
  push DWORD [M_menu_len_4]
  call print
  push M_menu_5
  push DWORD [M_menu_len_5]
  call print
  push M_menu_6
  push DWORD [M_menu_len_6]
  call print
  push M_menu_7
  push DWORD [M_menu_len_7]
  call print
  push M_menu_8
  push DWORD [M_menu_len_8]
  call print
  ret

; Wait for enter: Blocks the program until the user presses enter
; Args: None. Return: None.
%define buf [ebp-4]
wait_for_enter:
  push ebp
  mov ebp, esp

  mov eax, 3
  mov ebx, 0
  lea ecx, buf
  mov edx, 1
  int 0x80

  pop ebp
  ret

; Read String: Reads a string into a buffer and stores the length read as well
; Args: - buffer [EBP+12]
;       - len_ptr [EBP+8]
; Return: None
read_string:
  push ebp
  mov ebp, esp

  mov eax, 3
  mov ebx, 0
  mov ecx, [ebp+12]
  mov edx, 100
  int 0x80

  mov edi,[ebp+8]
  dec eax ; Removes the newline
  mov [edi], eax

  pop ebp
  ret 8

; Read Number: reads a number from stdin.
; Args: None.
; Return: - Value read [eax]
%define sign ebp-1
read_number:
  push ebp
  mov ebp, esp

  mov byte [sign], 0

  mov eax, 3
  mov ebx, 0
  mov ecx, num_buffer
  mov edx, 100
  int 0x80

  convert_number:
    mov eax, num_buffer ; Buffer
    mov ebx, 0          ; Value
    mov ecx, 0          ; Buffer index
    mov edx, 0          ; Current char
  convert_number_loop:
    movzx edx, byte [eax+ecx]
    cmp edx, 0x0A
    je convert_number_done
    cmp edx, '-'
    jne convert_number_loop_pos
    mov byte [sign], 1
    inc ecx
    jmp convert_number_loop
  convert_number_loop_pos:
    sub edx,'0'
    imul ebx, ebx, 10
    add ebx, edx
    inc ecx
    jmp convert_number_loop
  convert_number_done:
    cmp byte [sign], 1
    jne convert_number_done_pos
    neg ebx
  convert_number_done_pos:
    mov eax,ebx

  pop ebp
  ret

; Write number: Writes the number passed from the stack
; Args: - number [EBP+8]
; Return: None.
%define number [EBP+8]
%define buffer ESP-12
write_number:
  push ebp
  mov ebp, esp

  mov eax, number
  mov ecx, 0

  cmp eax, 0
  jge write_digits
  negative:
    mov eax, 4
    mov ebx, 1
    mov ecx, M_minus_sign
    mov edx, 1
    int 0x80

    mov eax, number
    mov ecx, 0
    neg eax
    jmp write_digits

  write_digits:
    mov edx, 0
    mov ebx, 10
    div ebx
    add dl, '0'
    mov byte [buffer+ecx], dl
    dec ecx

    cmp eax, 0
    jg write_digits

  neg ecx
  mov edx, ecx
  neg ecx
  inc ecx
  lea ecx, [buffer+ecx]
  mov eax, 4
  mov ebx, 1
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov byte [buffer], 0x0A
  lea ecx, [buffer]
  mov edx, 1
  int 0x80

  pop ebp
  ret 4

; Exit:  Performs a system call to exit the program
; Args: None. Return: None
exit:
  mov eax, 1
  mov ebx, 0
  int 80h
