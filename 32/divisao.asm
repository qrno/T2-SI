; Division: Reads two numbers and prints their Quotient.
; Args: None. Return: None.
%define result [ebp-4]
DIVISAO:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword result, 0

  ; Read both numbers and add to result
  call read_number
  add result, eax
  call read_number

  mov ebx, eax
  mov eax, result
  mov result, ebx

  mov edx, 0
  idiv dword result

  push eax
  call write_number

  ; Wait for enter
  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret
