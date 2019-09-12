org 0x7E00

string1 db 'Loading structures for the kernel...', 13, 10, 0
string2 db 'Setting up protected mode...', 13, 10, 0
string3 db 'Loading kernel in memory...', 13, 10, 0
string4 db 'Running kernel...', 13, 10, 0

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
	
    mov si, string1	
    call print

	mov dx, 3000
	call delay 
 
    mov si, string2	
    call print

	mov dx, 3000
	call delay  

    mov si, string3	
    call print

	mov dx, 3000
	call delay 
 
    mov si, string4	
    call print

	mov dx, 10000
	call delay  

    ;nesse trecho aqui, nós estamos setando todos os registradores para que seja possível o carregamento do kernel	
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov sp,0x7E00

    xor ax, ax
    mov ds, ax
	
    mov ah, 2       
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov cl, 3       
    mov bx, 0x500
    int 0x13

    jmp 0x500 	
	
print:			
    mov ah, 0Eh
	mov bh, 0
	mov bl, 0xf
loop:
    lodsb			
    cmp al, 0
    je done		
    int 10h			
    jmp loop

done:
    
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

times ((0x200 - 2) - ($ - $$)) db 0x00
dw 0xAA55