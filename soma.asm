; Soma: Reads two numbers and prints their sum.
; Args: None. Return: None.
%define result [ebp-4]
SOMA:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword result, 0

  ; Read both numbers and add to result
  call read_number
  add result, eax
  call read_number
  add result, eax

  push dword result
  call write_number

  ; Wait for enter
  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret
