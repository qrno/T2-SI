; Soma: Reads two numbers and prints their sum.
; Args: None. Return: None.
%define soma [ebp-4]
SOMA:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword soma, 0

  ; Read both number and add to soma
  call read_number
  add soma, eax
  call read_number
  add soma, eax

  ; Wait for enter
  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret
