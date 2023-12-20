%define resultado [ebp-4]

; Subtracao: Reads two numbers and prints first minus second.
; Args: None. Return: None.
SUBTRACAO:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword resultado, 0

  call read_number
  add dword resultado, eax
  call read_number
  sub dword resultado, eax

  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret

