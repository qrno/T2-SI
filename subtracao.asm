%define result [ebp-4]

; Subtracao: Reads two numbers and prints first minus second.
; Args: None. Return: None.
SUBTRACAO:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword result, 0

  call read_number
  add dword result, eax
  call read_number
  sub dword result, eax

  push dword result
  call write_number

  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret

