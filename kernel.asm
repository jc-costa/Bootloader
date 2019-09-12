org 0x500
jmp start

;entrada
dia dw 0
mes dw 0
ano dw 0
hora dw 0

;strings auxiliares
string0 db 'Escolha ', 0
string1 db 'dia', 13, 10, 0
string2 db 'mes', 13, 10, 0
string3 db 'ano (do ano 0 ao 2500)', 13, 10, 0
string4 db 'hora', 13, 10, 0
string6 db 'Temperatura(Celsius): ', 0
string7 db 'Umidade(%): ', 0
string8 db 'Clima ', 0 


;Variaveis da funcao Lenum
qnt db 0
potencia dw 1 
numero dw 0
contador db 0

start:
    mov ax, 0x7E00		
    add ax, 288		
    mov ss, ax
    mov sp, 4096

    mov ax, 0		
    mov ds, ax

mov ah, 0
mov al, 13h
int 10h

;recebedia
mov si, string0
call Printastr
mov si, string1
call Printastr

autent1:
call Lenumero
mov word[dia], ax
cmp ax, 31
jge autent1

mov ax, word[dia]
call Printanumero

;recebemes
mov si, string0
call Printastr
mov si, string2
call Printastr

autent2:
call Lenumero
mov word[mes], ax
cmp ax, 13
jge autent2

mov ax, word[mes]
call Printanumero

;recebeano
mov si, string0
call Printastr
mov si, string3
call Printastr

call Lenumero
mov word[ano], ax

mov ax, word[ano]
call Printanumero

;recebehora
mov si, string0
call Printastr
mov si, string4
call Printastr

autent3:
call Lenumero
mov word[hora], ax
cmp ax, 24
jge autent3

mov ax, word[hora]
call Printanumero

;calcula as saidas
mov si, string6
call Printastr

call Calculatemp
call Printanumero
mov si, string7
call Printastr

call Calculaumid
call Printanumero

mov dx, 15000
call delay

jmp start

  
Printastr:  
  mov cl, 0   
  printando: 
  lodsb
  cmp cl, al
  je fimprint 
  mov ah, 0xe
  mov bh, 0
  mov bl, 0x9
  int 10h 
    jmp printando
  fimprint:
ret

Lenumero:
  mov byte[qnt], 0
  mov byte[contador], 0
  mov word[potencia], 1
  mov word[numero], 0

  leitura: ;le do teclado o numero
    mov ah, 0
      int 16h
      cmp al, 13
      je fimleitura

      inc byte[qnt]
      push ax 
      jmp leitura

  fimleitura:

  strnum: ;loop string -> numero
      cmp byte[contador], 0
      je unid
      imul bx, word[potencia], 10
      mov word[potencia], bx
      unid:
      pop ax
      sub al, 48
      mov ah, 0
      mul word[potencia]
      add word[numero], ax
      inc byte[contador]
      mov cl, byte[contador]    
      cmp cl, byte[qnt] 
      jl strnum
  mov ax, word[numero]

ret

Printanumero:

  ;loop numero -> string
  mov cl, 10
  mov bx, 0
  push bx
  mov bx, 10
  push bx
  mov bx, 13
  push bx

  numstr: ;empilha caracteres na ordem inversa
    div cl
    add ah, 48
    mov bl, ah
    push bx
    mov ah, 0
    cmp ax, 0
    jne numstr

    escritanum: ;retira caracteres para escrita
    pop ax
    cmp al, 0
    je fimescritanum
    mov ah, 0xe
    mov bh, 0
    mov bl, 0x3
    int 10h
    jmp escritanum
  fimescritanum: 
ret

Calculatemp:
  mov cx, word[dia]
  mov bx, word[hora]
  add cx, bx
  mov ax, 523  
  add ax, cx
  mov cx, word[ano]
  mul cx
  mov cx, 50
  div cx
  mov ax, dx

ret

Calculaumid:
  mov dx, 0
  mov ax, word[mes]
  mov cx, word[hora]
  mul cx
  mov cx, 100
  div cx
  mov ax, dx

ret

delay: 

  mov bp, dx
  back:
  dec bp
  nop
  jnz back
  dec dx
  cmp dx,0    
  jnz back
ret   

fim:

times 510-($-$$) db 0
dw 0AA55h