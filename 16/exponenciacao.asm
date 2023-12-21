; Exponentiation: Reads two numbers and prints a^b.
; Args: None. Return: None.
%define result [ebp-4]
EXPONENCIACAO:
  push ebp
  mov ebp, esp

  sub esp, 4
  mov dword result, 0

  call read_number
  add result, eax
  call read_number

  mov ecx, eax    ; number of times to loop
  mov ebx, result ; base
  mov eax, result ; result

  dec ecx
  cmp ecx, 0
  je DONE

LOOP:
  imul word ebx
  jo OVERFLOW

  dec ecx
  cmp ecx, 0
  jne LOOP

DONE:
  push eax
  call write_number

  ; Wait for enter
  call wait_for_enter

  mov esp, ebp
  pop ebp
  ret
