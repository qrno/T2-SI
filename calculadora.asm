%include "io.mac"

; M
%macro PUSH_ALL 0
  push ebp
  mov ebp, esp
  push eax
  push ebx
  push ecx
  push edx
%endmacro

%macro POP_ALL 0
  pop edx
  pop ecx
  pop ebx
  pop eax
  pop ebp
%endmacro


section .data
  M_name  db "Bem vindo. Digite seu nome: ",0
  M_name_len dd 29
  M_hola1 db "Hola, ",0
  M_hola1_len dd 7
  M_hola2 db ", bem-vindo ao programa de CALC IA-32",0x0A,0
  M_hola2_len dd 38
  M_prec  db "Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32):",0
  M_prec_len dd 65

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

section .bss
  user_name resb 100
  user_name_len resd 1

section .text
  global _start

_start:
  push M_name
  push DWORD [M_name_len]
  call print

  push user_name
  push user_name_len
  call read_string

  push M_hola1
  push DWORD [M_hola1_len]
  call print

  push user_name
  push DWORD [user_name_len]
  call print

  push M_hola2
  push DWORD [M_hola2_len]
  call print

  push M_prec
  push DWORD [M_prec_len]
  call print

  call print_menu

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
  PUSH_ALL

  mov eax, 4
  mov ebx, 1
  mov ecx,[ebp + 12]
  mov edx,[ebp + 8]
  int 80h

  POP_ALL
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

; Read String: Reads a string into a buffer and stores the length read as well
; Args: - buffer [EBP+12]
;       - len_ptr [EBP+8]
; Return: None
read_string:
  PUSH_ALL

  mov eax, 3
  mov ebx, 0
  mov ecx, [ebp+12]
  mov edx, 100
  int 0x80

  mov edi, [ebp+8]
  dec eax ; Removes the newline
  mov [edi], eax

  POP_ALL
  ret 8

; Exit - Performs a system call to exit the program
; Args: None. Return: None
exit:
  mov eax, 1
  mov ebx, 0
  int 80h
