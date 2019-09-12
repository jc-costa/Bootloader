org 0x7C00
    
    ;setando os registradores de segmento
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov sp, 0x7c00
	
    ;tudo isso aqui é pra carregar o boot2

    ;carregando o boot2 na memória
    mov ah, 2  
    ;indicando o setor do disco a ser lido     
    mov al, 1
    ;aqui indico o número do cilindro do disco
    mov ch, 0
    ;aqui o head number
    mov dh, 0
    ;a partir daqui nós começamos o boot2
    mov cl, 2
    ;dizendo onde o boot2 será carregado
    mov bx, 0x7E00
    int 0x13
    
    ;pulando para o boot2
    jmp 0x7E00

    times ((0x200 - 2) - ($ - $$)) db 0x00
    dw 0xAA55