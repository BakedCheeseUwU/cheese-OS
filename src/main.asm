;Org Tells the assembler where we expect our code to be loaded
;It tells the assembler to calculate all memory offsets starting at 0x7C00
;Our BIOS always puts our OS  at  address 0x7C00
org 0x7C00
;Tells the assembler to emit 16 bit code
bits 16

%define ENDL 0x0D,0x0A

start:
  jmp main

;Prints a string to the screen.
;Params:
; -ds:si points to a string

puts:
  ;save registers we will modify
  push si
  push ax

.loop:
   lodsb    ; loads next character in al
   or al,al  ; verify if the next character is null
   jz .done  ; if the next character is null we jump outside the loop
   mov ah,0x0e ; call BIOS interrupt
   mov bh,0
   int 0x10
   jmp .loop ; Loops


.done:
  pop ax
  pop si
  ret
  

main:
  ;setup data segments
  mov ax,0 ; can't write directly to ds/es
  mov ds,ax
  mov es,ax

  ;setup stack
  mov ss,ax
  mov sp,0x7C00 ; stack grows downwards from where we are loaded in memory

  ;print message
  mov si,msg_hello
  call puts

  ;hlt stops the cpu from executing
  hlt

;sometimes the cpu can start again so we create a halt label and jump to it
;This way it the cpu starts again it will be stuck in an infinite loop

;jmp jumps to a given location
.halt:
  jmp .halt


msg_hello: db 'Hello World',ENDL,0

;times repeats the instruction
;we will have 512bytes in 1 sector
;The BIOS requires the the last 2 bytes of the 1st sector are AA55
;We can ask Nasm to emit bytes directly by using db.It writes given bytes to the assembled binary file
;Here we fill upto 510 bytes and then declare 2 bytes($-$$ gives the size of our program so far in bytes)
;dw is similar to db but only writes 2 bytes(known as a word)
times 510-($-$$)db 0
dw 0AA55h
