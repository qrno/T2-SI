; Multiplication: Reads two numbers and prints their product.
; Args: None. Return: None.
%define result [ebp-4]
MULTIPLICACAO:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword result, 0

  ; Read both numbers and add to result
  call read_number
  add result, eax
  call read_number
  imul dword result

  jo OVERFLOW

  mov result, eax

  push dword result
  call write_number

  ; Wait for enter
  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret

OVERFLOW:
  push M_overflow
  push dword [M_overflow_len]
  call print

  call exit
