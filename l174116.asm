[org 0x0100]
	jmp start

intro_message: db 'PRESS ANY KEY TO CONTINUE'
intro_message_length: dw 25
ending_message:	db 'GAME OVER'
ending_message_length: dw 9
message:	db 'SCORE:'
score:		dw	0
length:		dw	6
Popped_Message:	db 'POPPED: '
Missed_Message:	db 'MISSED: '
Missed:		dw 0
length3:	dw 8
Popped:		dw 0
message2:	db 'TIME LEFT: '
seconds:	dw	120
length2:	dw	11
symbol:		db ' '
len:	    dw	1
TopLeftX:	dw 21
TopLeftY:	dw 0
BottomRightX: dw 24
BottomRightY: dw 3
color:		dw 68
char1:		db 'T'
char2:		db 'J'
char3:		db 'R'
Number:		dw 0	
IsStart:	dw 0
randomNum:	dw 0
location:	dw 0
BorderColor1: dw 68
BorderColor2: dw 17
BorderColor3: dw 34
ScanCode1:	db 0
ScanCode2:	db 0
ScanCode3:	db 0
Col1:		dw 0
Col2:		dw 0
Range:		dw 0
genrand:	push ax
			push dx
			push cx
            MOV AH, 00h  ; interrupts to get system time        
			INT 1AH   
			mov  ax, dx
			xor  dx, dx
			mov  cx, [Range]    
			div  cx       ; here dx contains the remainder of the division - from 0 to 9
			mov [randomNum],dl
			add  dl, '0'  ; to ascii from '0' to '9'
			mov ah,2h
			pop cx
			pop dx
			pop ax
			ret

SetChar1A:	mov byte[char1],'A'
			mov byte[ScanCode1],0x1E
			mov word[BorderColor1],68
			ret
SetChar1B:	mov byte[char1],'B'
			mov byte[ScanCode1],0x30
			mov word[BorderColor1],68
			ret
SetChar1C:	mov byte[char1],'C'
			mov byte[ScanCode1],0x2E
			mov word[BorderColor1],68
			ret
SetChar1D:	mov byte[char1],'D'
			mov byte[ScanCode1],0x20
			mov word[BorderColor1],68
			ret
			
SetChar2W:	mov byte[char2],'W'
			mov byte[ScanCode2],0x11
			mov word[BorderColor2],17
			ret
SetChar2X:	mov byte[char2],'X'
			mov byte[ScanCode2],0x2D
			mov word[BorderColor2],17
			ret
SetChar2Y:	mov byte[char2],'Y'
			mov byte[ScanCode2],0x15
			mov word[BorderColor2],17
			ret
SetChar2Z:	mov byte[char2],'Z'
			mov byte[ScanCode2],0x2C
			mov word[BorderColor2],17
			ret

SetChar3J:	mov byte[char3],'J'
			mov byte[ScanCode3],0x24
			mov word[BorderColor3],34
			ret
SetChar3K:	mov byte[char3],'K'
			mov byte[ScanCode3],0x25
			mov word[BorderColor3],34
			ret
SetChar3L:	mov byte[char3],'L'
			mov byte[ScanCode3],0x26
			mov word[BorderColor3],34
			ret			
SetChar3M:	mov byte[char3],'M'
			mov byte[ScanCode3],0x32
			mov word[BorderColor3],34
			ret			

a1:		call SetChar1A
		jmp a5
a2:		call SetChar1B
		jmp a5
a3:		call SetChar1C
		jmp a5
a4:		call SetChar1D
		jmp a5

RandomChar1:	mov word[Range],4
				call genrand
				cmp word[randomNum],0
				je a1
				cmp word[randomNum],1
				je a2
				cmp word[randomNum],2
				je a3	
				cmp word[randomNum],3
				je a4
a5:				ret
				
b1:		call SetChar2W
		jmp b5
b2:		call SetChar2W
		jmp b5
b3:		call SetChar2Y
		jmp b5
b4:		call SetChar2Z
		jmp b5

RandomChar2:	mov word[Range],4
				call genrand
				cmp word[randomNum],0
				je b1
				cmp word[randomNum],1
				je b2
				cmp word[randomNum],2
				je b3	
				cmp word[randomNum],3
				je b4
b5:				ret

c1:		call SetChar3J
		jmp c5
c2:		call SetChar3K
		jmp c5
c3:		call SetChar3L
		jmp c5
c4:		call SetChar3M
		jmp c5

RandomChar3:	mov word[Range],4
				call genrand
				cmp word[randomNum],0
				je c1
				cmp word[randomNum],1
				je c2
				cmp word[randomNum],2
				je c3	
				cmp word[randomNum],3
				je c4
c5:				ret

			
kbisr:	push ax
		push es
		mov ax,0xB800
		mov es,ax
		in al,0x60
		cmp al,[ScanCode1]			 ;compare char1
		jne nextcmp
		add word[score],10
		add word[Popped],1
		call removebubble1
		jmp nomatch

nextcmp:	cmp al,[ScanCode2]	     ;compare char2
			jne nextcmp2
			add word[score],10
			add word[Popped],1
			call removebubble2
			jmp nomatch
			
nextcmp2:	cmp al,[ScanCode3]		 ;compare char3
			jne nomatch
			add word[score],10
			add word[Popped],1
			call removebubble3
nomatch:	mov al,0x20
			out 0x20,al
			pop es
			pop ax
			iret

FullClrscr:	push es
			push ax
			push di
		
		mov ax,0xB800
		mov es,ax
		mov di,0
		
		
Nextloc:	mov word[es:di],0x0720
			add di,2
			cmp di,4000
			jne Nextloc
			pop di
			pop ax
			pop es
			ret

changedi:mov di,[Col2]
		 add word[Col1],160
		 add word[Col2],160
		jmp l1
check1:	cmp di,[Col1]			
		jge check2
		jmp l1
check2:	cmp di,[Col2]			
		jle changedi
		jmp l1
clrscr:	push es
		push ax
		push di
		mov word[Col1],118
		mov word[Col2],160
		mov ax,0xB800
		mov es,ax
		mov di,0
		
		
nextloc:	mov word[es:di],0x3E20
			add di,2
			jmp check1
l1:			cmp di,4000
			jne nextloc
			pop di
			pop ax
			pop es
			ret
				
printnum:	push bp
			mov bp,sp
			push es
			push ax
			push bx
			push cx
			push dx
			push di
			
			mov ax,0xB800
			mov es,ax
			mov ax,[bp+4]
			mov bx,10
			mov cx,0


nextdigit:	mov dx,0
			div bx
			add dl,0x30
			push dx
			inc cx
			cmp ax,0
			jnz nextdigit
			
			
			mov di, [location]

nextpos:	pop dx
			mov dh,0x61
			mov [es:di],dx
			add di,2
			loop nextpos
			
			pop di
			pop dx
			pop cx
			pop bx
			pop ax
			pop es
			pop bp
			ret 2			
			
			
			
printstr:	push bp
			mov bp,sp
			push es	
			push ax
			push cx
			push si
			push di
			
			mov ax, 0xb800
			mov es,ax
			mov al,80
			mul byte[bp+10]
			add ax,[bp+12]
			shl ax,1
			mov di,ax
			mov si,[bp+6]
			mov cx,[bp+4]
			mov ah,[bp+8]

nextch:		mov al,[si]
			mov [es:di],ax
			add di,2
			add si,1
			loop nextch
			
			pop di
			pop si
			pop cx
			pop ax
			pop es
			pop bp
			ret 10
			
displayY:	mov byte[char1],'Y'
			mov word[color],34
			jmp loop2
displayP:	mov byte[char1],'P'
			mov word[color],17
			jmp loop2
displayI:	mov byte[char1],'I'
			mov word[color],68
			jmp loop2
displayN:	mov byte[char1],'N'
			mov word[color],34
			jmp loop2
displayG:	mov byte[char1],'G'
			mov word[color],17
			jmp loop2
			
displayA:	mov byte[char1],'A'
			mov word[color],68
			jmp loop4
			
displayL1:	mov byte[char1],'L'
			mov word[color],34
			jmp loop4

displayL2:	mov byte[char1],'L'
			mov word[color],17
			jmp loop4

displayO1:	mov byte[char1],'O'
			mov word[color],68
			jmp loop4

displayO2:	mov byte[char1],'O'
			mov word[color],34
			jmp loop4

displayN2:	mov byte[char1],'N'
			mov word[color],17
			jmp loop4
			
				

loadrectangles:	add word[IsStart],1
				call FullClrscr
				mov bx,6
				mov cx,10
				mov dx,10
				mov si,14
				mov di,cx
				add di,2

				
loop1:			mov word[TopLeftX],bx
				mov word[TopLeftY],cx
				mov word[BottomRightX],dx
				mov word[BottomRightY],si
				call printRectangle
				mov ax,di
				push ax
				mov ax,8
				push ax
				mov ax,2
				push ax
				mov ax,char1
				push ax
				push word[len]
				call printstr
				add cx,6
				add si,6
				mov di,cx
				add di,2
				add word[Number],1
				cmp word[Number],1
				je displayY
				cmp word[Number],2
				je displayP
				cmp word[Number],3
				je displayI
				cmp word[Number],4
				je displayN
				cmp word[Number],5
				je displayG
loop2:			cmp word[Number],6
				jl	loop1
				
				mov byte[char1],'B'
				mov word[Number],0
				mov bx,12
				mov cx,2
				mov dx,16
				mov si,6
				mov di,cx
				add di,2
loop3:			mov word[TopLeftX],bx
				mov word[TopLeftY],cx
				mov word[BottomRightX],dx
				mov word[BottomRightY],si
				call printRectangle
				mov ax,di
				push ax
				mov ax,14
				push ax
				mov ax,2
				push ax
				mov ax,char1
				push ax
				push word[len]
				call printstr
				add cx,6
				add si,6
				mov di,cx
				add di,2
				add word[Number],1
				cmp word[Number],1
				je displayA
				cmp word[Number],2
				je displayL1
				cmp word[Number],3
				je displayL2
				cmp word[Number],4
				je displayO1
				cmp word[Number],5
				je displayO2
				cmp word[Number],6
				je displayN2
			
loop4:			cmp word[Number],7
				jl loop3
				mov ax,27
				push ax
				mov ax,20
				push ax
				mov ax,0x92
				push ax
				mov ax,intro_message
				push ax
				push word[intro_message_length]
				call printstr
				mov ah,0
				int 0x16
				jmp load
			

delay:			push cx
				mov cx,40
delay_loop1:	push cx
				mov cx,0xFFFF
delay_loop2:	loop delay_loop2
				pop cx
				loop delay_loop1
				pop cx
				ret			
			
printRectangle:	mov bx,[TopLeftY]
										
horizontal1:	mov ax,bx
				push ax
				mov ax,[TopLeftX]
				push ax
				mov ax,[color]
				push ax
				mov ax,symbol
				push ax
				push word[len]
				call printstr
				inc bx
				cmp bx,[BottomRightY]
				jne horizontal1
		
				mov bx,[TopLeftX]
				
vertical1:		mov ax,[BottomRightY]
				push ax
				mov ax,bx
				push ax
				mov ax,[color]
				push ax
				mov ax,symbol
				push ax
				push word[len]
				call printstr
				inc bx
				cmp bx,[BottomRightX]
				jne vertical1
				
				mov bx,[BottomRightY]
horizontal2:	mov ax,bx
				push ax
				mov ax,[BottomRightX]
				push ax
				mov ax,[color]
				push ax
				mov ax,symbol
				push ax
				push word[len]
				call printstr
				dec bx
				cmp bx,[TopLeftY]
				jne horizontal2
		
				mov bx,[BottomRightX]
vertical2:		mov ax,[TopLeftY]
				push ax
				mov ax,bx
				push ax
				mov ax,[color]
				push ax
				mov ax,symbol
				push ax
				push word[len]
				call printstr
				dec bx
				cmp bx,[TopLeftX]
				jne vertical2
				ret
				
timer: mov ax,[seconds]
	   push ax
	   mov word[location],466
	   call printnum
	   call delay
	   sub word[seconds],1
	   ret				
LoadBalloonsMissed:	mov ax,63
	   push ax
	   mov ax,8
	   push ax
	   mov ax,0x61
	   push ax
	   mov ax,Missed_Message
	   push ax
	   push word[length3]
	   call printstr
	   mov ax,[Missed]
	   push ax
	   mov word[location],1420
	   call printnum
	   ret

LoadBalloonsPopped:	mov ax,63
	   push ax
	   mov ax,6
	   push ax
	   mov ax,0x61
	   push ax
	   mov ax,Popped_Message
	   push ax
	   push word[length3]
	   call printstr
	   mov ax,[Popped]
	   push ax
	   mov word[location],1100
	   call printnum
	   ret
loadscore: 
	   mov ax,63
	   push ax
	   mov ax,4
	   push ax
	   mov ax,0x61
	   push ax
	   mov ax,message
	   push ax
	   push word[length]
	   call printstr
	   mov ax,[score]
	   push ax
	   mov word[location],780
	   call printnum
	   ret

loadtime: mov word[TopLeftX],0
	      mov word[TopLeftY],59
	      mov word[BottomRightX], 24
	      mov word[BottomRightY], 79
		  mov word[color],34
	      call printRectangle
		  mov dx,60
		  mov word[BottomRightX],23
repeat1:  mov word[TopLeftY],dx
		  mov bx,[BottomRightX]
repeat2:  mov ax,[TopLeftY]
		  push ax
		  mov ax,bx
		  push ax
		  mov word[color],0x66
		  mov ax,[color]
		  push ax
	      mov ax,symbol
		  push ax
		  push word[len]
		  call printstr
		  dec bx
		  cmp bx,[TopLeftX]
		  jne repeat2
		  add dx,1
		  cmp dx,79
		  jne repeat1
		  
		  mov ax,63
		  push ax
		  mov ax,2
		  push ax
		  mov ax,0x61
		  push ax
		  mov ax,message2
		  push ax
		  push word[length2]
		  call printstr
		  ret
PrintBorder:	mov word[TopLeftX],0
				mov word[TopLeftY],0
				mov word[BottomRightX],24
				mov word[BottomRightY],58
				mov word[color],17
				call printRectangle
		  mov dx,1
		  mov word[BottomRightX],23
repeat3:  mov word[TopLeftY],dx
		  mov bx,[BottomRightX]
repeat4:  mov ax,[TopLeftY]
		  push ax
		  mov ax,bx
		  push ax
		  mov word[color],0x3E
		  mov ax,[color]
		  push ax
	      mov ax,symbol
		  push ax
		  push word[len]
		  call printstr
		  dec bx
		  cmp bx,[TopLeftX]
		  jne repeat4
		  add dx,1
		  cmp dx,58
		  jne repeat3
		  ret
		  
GameOver:	call FullClrscr
			mov word[TopLeftX],0
			mov word[TopLeftY],0
			mov word[BottomRightX],24
			mov word[BottomRightY],79
			mov word[color],34
			call printRectangle
		  mov dx,1
		  mov word[BottomRightX],23
repeat5:  mov word[TopLeftY],dx
		  mov bx,[BottomRightX]
repeat6:  mov ax,[TopLeftY]
		  push ax
		  mov ax,bx
		  push ax
		  mov word[color],0x66
		  mov ax,[color]
		  push ax
	      mov ax,symbol
		  push ax
		  push word[len]
		  call printstr
		  dec bx
		  cmp bx,[TopLeftX]
		  jne repeat6
		  add dx,1
		  cmp dx,79
		  jne repeat5
		  
		  mov ax,30
		  push ax
		  mov ax,3
		  push ax
		  mov ax,0x61
		  push ax
		  mov ax,message
		  push ax
		  push word[length]
		  call printstr
		  mov word[location],560
		  mov ax,[score]
		  push ax
		  call printnum
		  
		  mov ax,30
		  push ax
		  mov ax,5
		  push ax
		  mov ax,0x61
		  push ax
		  mov ax,Popped_Message
		  push ax
		  push word[length3]
		  call printstr
		  mov word[location],880
		  mov ax,[Popped]
		  push ax
		  call printnum
		  
		  mov ax,30
		  push ax
		  mov ax,7
		  push ax
		  mov ax,0x61
		  push ax
		  mov ax,Missed_Message
		  push ax
		  push word[length3]
		  call printstr
		  mov word[location],1200
		  mov ax,[Missed]
		  push ax
		  call printnum
		  
		  mov ax,30
		  push ax
		  mov ax,14
		  push ax
		  mov ax,0xE1
		  push ax
		  mov ax,ending_message
		  push ax
		  push word[ending_message_length]
		  call printstr
		  
		  jmp end

RandomLocation1:mov word[Range],14
				call genrand
				mov bp,[randomNum]
				call RandomChar1
				ret	

RandomLocation2:mov word[Range],17						
				call genrand
				mov di,[randomNum]
				add di,35
				call RandomChar2
				ret
loadbubble1:
			mov word[TopLeftX],si
			mov word[TopLeftY],bp
			mov ax,si
			add ax,3
			add bp,5
			mov word[BottomRightX],ax
		    mov word[BottomRightY],bp
			sub bp,2
			mov ax,bp
			push ax
			mov ax,si	
			add ax,2
			push ax		
			mov word[color],0x3E
			mov ax,[color]
			push ax
			mov ax,char1
			push ax
			push word[len]
			call printstr
			mov ax,[BorderColor1]
			mov word[color],ax
		    call printRectangle
			mov bp,[TopLeftY]
			ret

loadbubble2:mov word[TopLeftX],cx			
			mov word[TopLeftY],di
			add di,5
			mov ax,cx
			add ax,3
			mov word[BottomRightX],ax
		    mov word[BottomRightY],di
			sub di,2
			mov ax,di
			push ax
			mov ax,cx	
			add ax,2
			push ax		
			mov word[color],0x3E
			mov ax,[color]
			push ax
			mov ax,char2
			push ax
			push word[len]
			call printstr
			mov ax,[BorderColor2]
			mov word[color],ax
		    call printRectangle
			mov di,[TopLeftY]
			ret
			
loadbubble3:mov word[TopLeftX],bx
			mov ax,bx
			add ax,3
			mov word[TopLeftY],20
			mov word[BottomRightX],ax
		    mov word[BottomRightY],25
			mov ax,23	
			push ax
			mov ax,bx
			add ax,2
			push ax		
			mov word[color],0x3E
			mov ax,[color]
			push ax
			mov ax,char3
			push ax
			push word[len]
			call printstr
			mov ax,[BorderColor3]
			mov word[color],ax
		    call printRectangle
			ret			

removebubble1: mov byte[char1],' '
			   mov word[BorderColor1],0
			   mov byte[ScanCode1],0
			   mov si,25
			   call SetChar1D
			   call RandomLocation1
			   call loadbubble1
			   ret
removebubble2: mov byte[char2],' '
               mov word[BorderColor2],0x3E
			   mov byte[ScanCode2],0
			
			   ret
removebubble3: mov byte[char3],' '
			   mov word[BorderColor3],0x3E
			   mov byte[ScanCode3],0
			   ret

IncreaseMissed:	add word[Missed],1
				jmp continue1
IncreaseMissed2:	add word[Missed],1
					jmp continue2
IncreaseMissed3:	add word[Missed],1
					jmp continue3

reset1:			mov si,21
				cmp byte[char1],' '
				jne IncreaseMissed
continue1:		call RandomChar1
				mov word[BorderColor1],68
				call RandomLocation1
				jmp loop5

reset2:			mov cx,22
				cmp byte[char2],' '
				jne IncreaseMissed2
continue2:		call RandomChar2
				mov word[BorderColor2],17
				call RandomLocation2
				jmp loop6

reset3:			mov bx,21
				cmp byte[char3],' '
				jne IncreaseMissed3
continue3:		call RandomChar3
				mov word[BorderColor3],34
				jmp loop7
	   
start:	cmp word[IsStart],0
		je loadrectangles
		
	
load:	mov si,21
		mov cx,22
		mov bx,21
		mov bp,0
		mov di,45
	
		call SetChar1B
		call SetChar2X
		call SetChar3L
		
main_loop:  cmp word[seconds],0
			je GameOver
			call clrscr
			call PrintBorder
		    call loadtime
			call loadscore
			call LoadBalloonsPopped
			call LoadBalloonsMissed
		    call loadbubble1
			call loadbubble2
			call loadbubble3
			call timer
			
			xor ax,ax
			mov es,ax
			cli
			mov word[es:9*4],kbisr
			mov [es:9*4+2],cs
			sti
			
			dec si
			dec cx
			dec bx
			cmp bx,0
			je reset3
loop7:	    cmp si,0
			je reset1
loop5:		cmp cx,0
			je reset2
loop6:		jmp main_loop	   
end: mov ax,0x4c00
int 21h