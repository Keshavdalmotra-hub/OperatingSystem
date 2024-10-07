org 0x7C00
bits 16

%define ENDL 0x0D , 0x0A


start:
	jmp main
;Print string to the screen
;Were  going to print with BIOS interrupts:
;
;Params:
;   -  ds:si points to string


puts:
	push si
	push ax

.loop:
	lodsb			;loads next character in all
	or al,al		;verify whether the next character su null?
	jz .done

	mov ah, 0x0e		;This will call the BIOS Interrupt
	mov bh, 0
	int 0x10

	jmp .loop

.done:
	pop ax
	pop si
	ret 


main:
	;setup data segments
	mov ax, 0     ;can't weite to es/ds directly
	mov ds , ax
	mov es, ax

	;setup stack
	mov ss, ax
	mov sp, 0x7C00  	;stack grows downwards from where we loaded in the memory
	;print message
	mov si, msg_hello
	call puts

	hlt

.halt:
	jmp .halt

msg_hello: db 'Hello world!', ENDL, 0


times 510 -($-$$) db 0
dw 0AA55h
