.model smaLL
.stack 640
.data 
cursxchat db 0
cursychat db 3

currxchat db 0
currychat db 16

datatosendflagchat db 0
VALUEschat db ? 
VALUErchat db ? 
isenterchat db 0
isbackspacechat db 0
lastsxchat db 12 dup(0)
lastrxchat db 12 dup(0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tempstring db 'Chat Mode','$'
;real strings
playername1 db  16 dup('$')
playername2 db   16 dup('$')
level db 1
VALUE db ?
gameover db 'Game Over,To Play Again Hit F2','$'
mes1 db 'enter your name:',13,10,'$' 
mess1 db 13,10,'$'
mes2 db 'then press enter to continue','$'
mes3 db 'to start chatting press f1',13,10,'$'
mes4 db 'to start the game press f2',13,10,'$'
mes5 db 'to end the progrm press esc',13,10,'$'
mes6 db 'you sent a game invitation',13,10,'$'
mes7 db 'you sent a chat invitation',13,10,'$'
mes8 db 'sent you a chat invitation',13,10,'$'
mes9 db 'sent you a game invitation',13,10,'$'
mes10 db 'your invitation was accepted',13,10,'$'
mes11 db 'your invitation was rejected',13,10,'$'
shld1col equ 60
shld2col equ 259
shld1row equ 125
shld2row equ 20
shld1clr equ 3h
shld2clr equ 0eh
shld2rowtemp dw ?
shld2coltemp dw ?
shld1rowtemp dw ?
shld1coltemp dw ?
life1 db 9
life2 db 9
bulletstrt1 equ 45
bulletstrt2 equ 270
bullet1y dw ?
bullet2y dw ?
temp dw ?
countbull1 dw 250
countbull2 dw 250
bulletlength equ 10
playerWidth EQU 42
playerHeight EQU 50
BulletCoOrdinateX1 dw ? ;coming from player 1
BulletCoOrdinateY1 dw ?

BulletCoOrdinateX2 dw ? ;coming from player 2
BulletCoOrdinateY2 dw ?

IfBullet dw 0
playerFilename DB 'p1.bin', 0

pW dW  playerWidth
ph dW  playerHeight
playerFilehandle DW ?


px dw 0
py dW 100
playerData DB playerWidth*playerHeight dup(0) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;player two data;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
playerWidth2 EQU 42
playerHeight2 EQU 50

playerFilename2 DB 'p1.bin', 0

pW2 dW  playerWidth2
ph2 dW  playerHeight2
playerFilehandle2 DW ?


px2 dw 260
py2 dW 100
playerData2 DB playerWidth2*playerHeight2 dup(0) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;power ups data;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

powerW EQU 20
powerH EQU 14

powerFileName DB 'puf.bin', 0

puW dW  powerW
puH dW  powerH
powerFilehandle DW ?


pux dw ?       ;;edited 
puy dW ?               ;edited
powerData DB powerW*powerH dup(0)
      ;;;;;;;;;;;;;;;;;;;;;
      
time db 0
powerFlag db 0
pTimer db 5     ;editet
WhichP db ?
RandomRow dw ?    ;edited       
      
      
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cursx db 0
cursy db 21

currx db 0
curry db 22

datatosendflag db 0
VALUEs db ? 
VALUEr db ? 
isenter db 0
isenters db 0
isbackspace db 0
lastsx db 12 dup(0)
lastrx db 12 dup(0)
;;;;;;;;;;;;;;;;;;;;


.code 
initialize proc
;;set 
mov dx,3fbh 			; Line Control Register
mov al,10000000b		;Set Divisor Latch Access Bit
out dx,al				;Out it
;;set LSB
mov dx,3f8h			
mov al,0ch			
out dx,al
;; set msb
mov dx,3f9h
mov al,00h
out dx,al
;;set port
mov dx,3fbh
mov al,00011011b
out dx,al
ret
initialize endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inlinechat proc

;;;;;;;;;;;;;;
mov cx,0 ;Column
mov dx,160 ;Row
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
chatline1: int 10h
inc cx
cmp cx,320
jnz chatline1

;;;;;;;;;;;;;;
ret
inlinechat endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayinfirsthalf   PROC
cmp isbackspace,1
jne v 
cmp cursx,0
jne co
cmp cursy,21
jne e
mov cursx,0
jmp f
e:

mov cursx,0
jmp f
co:
dec cursx
f:
mov VALUEs,32
jmp con
v:
cmp isenter,1
jne con
ic:
inc cursy
inc cursy

mov cursx,0
jmp cheaky
con:
mov AH,2
mov dl ,cursx 
mov dh ,cursy 
Int 10h  ;to set the cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;display;;;;;;;;;;;;;;;;;;;;;
display:
mov AH,9  
mov bh,0          ;Page 0:
mov al ,VALUEs ;Letter 
mov cx,1h         ;5 times 
mov bl,09h ;color
Int 10h      ;to display the character
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmp isbackspace,1
je finish
inc cursx 
cheakx:
cmp cursx ,40
jne finish
normal:
jmp ic

cheaky:
   cmp cursy,25
   jne finish
   mov ah,6        ; function 6
   mov al,2        ; scroll by 1 line    
   mov bh,0    ; normal video attribute         
   mov ch,21        ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24       ; lower right Y
   mov dl,39      ; lower right X 
   int 10h           
   ;Scroll up ;;;;;;;

;;;;;;;;;;;;;;;;
dec cursy
dec cursy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finish:
mov AH,2
mov dl ,cursx 
mov dh ,cursy 
Int 10h  ;to set the cursor
mov isbackspace,0
mov isenter,0
mov al,0
mov datatosendflag,0
ret
displayinfirsthalf   endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayinsecondhalf  PROC
cmp isbackspace,1
jne v1 
cmp currx,0
jne co1
cmp curry,22
jne re
jmp f1
re:
 
cmp curry,22
jne s
mov curry,22
s:
mov currx,0
jmp f1
co1:
dec currx
f1:
mov al,32
jmp con1
v1:
cmp isenter,1
jne con1
ic1:
inc curry
inc curry

mov currx,0
jmp cheakyy
con1:
mov AH,2
mov dl ,currx 
mov dh ,curry 
Int 10h  ;to set the cursor
;;;;;;;;;;;;;;display;;;;;;;;;;;;;;;;;;;;;
mov AH,9  
mov bh,0          ;Page 0:al ,Letter 
mov cx,1h         ;1 times 
mov bl,0eh      ; background 
Int 10h      ;to display the character
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmp isbackspace,1
je finishsh
inc currx
cheakxx:
cmp currx ,40
jne finishsh
normall:
jmp ic1
cheakyy:
   cmp curry,26
   jne finishsh
   mov ah,6        ; function 6
   mov al,2        ; scroll by 1 line    
   mov bh,0     ; normal video attribute         
   mov ch,21       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24       ; lower right Y
   mov dl,39      ; lower right X 
   int 10h           
   ;Scroll up ;;;;;;;

;;;;;;;;;;;;;;;;
dec curry
dec curry
cmp curry,22
jne finishsh
mov curry,22
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finishsh:
mov AH,2
mov dl ,cursx 
mov dh ,cursy 
Int 10h  ;to set the cursor
mov isenter,0
mov isbackspace,0
mov al,0
ret
displayinsecondhalf  endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;------------------------------------------------------------------------
startjump proc
jmp masm 
ret
startjump endp
;;;;;;;;;;;;;;;;;;;
getKeyJump proc
jmp getKey 
ret
getKeyJump endp
;;;;;;;;;;;;;;;;;;;;;
chilk proc
jmp clicked  
ret
chilk endp
;;;;;;;;;;;;;;;;;;
menuJmp proc
jmp menu  
ret
menuJmp endp
;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN    PROC FAR
start:
mov ax ,@data
mov ds,ax



call OpenFile
call OpenFile2
CALL OpenFilep

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
masm :
mov life1, 9
mov life2, 9
 mov ax,0600h 
  mov bh,00h
  mov cx,0 
  mov dx,184FH   
  int 10h

MOV ah,0;SET VIDO MOOD
MOV al,13h ;CHOOSE VIDO MOOD
INT 10H 

;;gwa elchat
;mov di,offset lastsx
;mov si,offset lastrx

call initialize
;;;;;names 


  mov ax,0600h 
  mov bh,00h
  mov cx,0 
  mov dx,184FH   
  int 10h
  
mov dl,5
mov dh,10
mov ah,2
mov bh,0
int 10h

   mov  ah, 9
   mov dx ,offset mes1
   int 21h

mov dl,5
mov dh,17
mov ah,2
mov bh,0
int 10h
   mov  ah, 9
   mov dx ,offset mes2
   int 21h   
   
mov dl,10
mov dh,13
mov ah,2
mov bh,0
int 10h

  mov cx,15
  
  
  mov di,offset playername1
  mov si,offset playername2
  
iScx15:
cmp isenter,1
jne cheakreceive
cmp isenters,1
jne CHKey2
jmp outp
;;;;;;;;;;;;;receive;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check that Data is Ready
cheakreceive:
	mov dx , 3FDH		; Line Status Register
	in al , dx 
  	test al , 1
  	Jz CHKey2                                   ;Not Ready
 ;If Ready read the VALUE in Receive data register
  	mov dx , 03F8H
  	in al , dx 
  	mov VALUEr , al
    mov [si],al
	inc si 
	cmp al,13
    jne CHKey2
	mov isenter,1
	
;jmp cheakreceive
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHKey2:
cmp isenters,1
je   cont2 
mov al,0
cmp datatosendflag,1
je send2
mov AH,01h
Int 16h
cmp al,0
je cheakreceive
mov AH,01h;;;read the char and put in al
Int 21h

;;;;;;;;a3mldrawlma anzl lta7t
 
r:
mov VALUEs,al ;;;;;;;;;data to send
mov [di],al
inc di 
;;;;;;;;;;;;;;;;;send;;;;;;;;;;;;;;;;;;;;
send2:;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
        In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ cheakreceive            ;Not empty;tb lw mlyanh a5od mnh input tany wala lazm astna

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUEs
  		out dx , al
		cmp al,13
		jne cont2
        mov isenters,1	
cont2:	
	
loop iScx15

outp:      ;second screen
  mov ax,0600h 
  mov bh,00h
  mov cx,0 
  mov dx,184FH   
  int 10h
  
  menu:
   mov ax,0600h 
   mov bh,00h
   mov cx,0 
   mov dx,184FH   
   int 10h
  
  ;move cursor
mov dl,8
mov dh,8
mov ah,2
mov bh,0
int 10h
   
   mov  ah, 9
   mov dx ,offset mes3
   int 21h
   
mov dl,8
mov dh,10
mov ah,2
mov bh,0
int 10h

   mov  ah, 9
   mov dx ,offset mes4
   int 21h
   
mov dl,8
mov dh,12
mov ah,2
mov bh,0
int 10h

   mov  ah, 9
   mov dx ,offset mes5
   int 21h
   
mov cx,0 ;Column
mov dx,170 ;Row
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
chatline11: int 10h
inc cx
cmp cx,320
jnz chatline11

mov cx,0 ;Column
mov dx,169 ;Row
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
chatline2: int 10h
inc cx
cmp cx,320
jnz chatline2

mov dl,193
mov dh,48
mov ah,2
mov bh,0
int 10h

   mov  ah, 9
   mov dx ,offset tempstring
   int 21h
   mov al,0
  
   getkey:
   mov ah,1
   int 16h
   jz bb 
   call chilk
   bb:
   mov dx , 3FDH		; Line Status Register
   in al , dx 
   test al , 1
   jz getkey
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;recieved;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov dl,2  ; change coordinates
   mov dh,14
   mov ah,2
   mov bh,0
   int 10h

	recieved:
  	mov dx , 03F8H
  	in al , dx 
  	mov VALUEr , al
	
	cmp VALUEr,59
	jne g
	
	mov  ah, 9
    mov dx ,offset playername2
    int 21h
	mov dl,10 ; change coordinates
    mov dh,14
    mov ah,2
    mov bh,0
    int 10h
	mov  ah, 9
    mov dx ,offset mes8
    int 21h
	
	mov ah,0
    int 16h
	mov VALUEs,al
	call SendChar
	cmp VALUEs,121
    je qq
   wq:
   cmp VALUEs,89
   jne wq2
   qq:
    call chatMode
   wq2:
      jmp menu
   
    g:
    cmp VALUEr,60
    jne e22 
	mov  ah, 9
    mov dx ,offset playername2
    int 21h
	mov dl,10  ; change coordinates
    mov dh,14
    mov ah,2
    mov bh,0
    int 10h
	mov  ah, 9
    mov dx ,offset mes9
    int 21h
	
	mov ah,0
    int 16h
	mov VALUEs,al
	call SendChar
	cmp VALUEs,121
    je qq2
    wq21:
    cmp VALUEs,89
    jne wq22
    qq2:
    jmp gamewithchatBEGIN
    wq22:
      jmp menu
	
	e22:
    cmp VALUEr,1
    je d3
	call getKeyJump
	d3:
	call EndProgram
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clicked;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   clicked:
   mov ah,0
   int 16h
   cmp al,27 
   jne d
   mov bl,1
   mov VALUEs,bl 
   jmp clickeds
   ;send
   d:   
   mov VALUEs,ah
        clickeds:
        mov dx , 3FDH		; Line Status Register
        In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ clickeds           ;Not empty;tb lw mlyanh a5od mnh input tany wala lazm astna

  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUEs
  		out dx , al
    
	mov dl,8
    mov dh,14
    mov ah,2
    mov bh,0
    int 10h
    cmp VALUEs,59
	jne g2
	
	mov  ah, 9
    mov dx ,offset mes7
    int 21h
	
	call RecieveChar
	
	cmp VALUEr,121
	jne a 
	mov  ah, 9
    mov dx ,offset mes10
    int 21h
	
call chatMode
	; je chat
	a:
	cmp VALUEr,89
	jne a2
	mov  ah, 9
    mov dx ,offset mes10
    int 21h
    call chatMode
	  
	a2:
	mov  ah, 9
    mov dx ,offset mes11
    int 21h
	
	jmp menu
	
    g2:
    cmp VALUEs,60
	jne e2
	mov  ah, 9
    mov dx ,offset mes6
    int 21h
	call RecieveChar
	
	cmp VALUEr,'y'
	jne a1 
	mov  ah, 9
    mov dx ,offset mes10
    int 21h
	
	je gamewithchatBEGIN
	
	a1:
	cmp VALUEr,'Y'
	jne a21
	mov  ah, 9
    mov dx ,offset mes10
    int 21h
    je gamewithchatBEGIN 
	  
	a21:
	mov  ah, 9
    mov dx ,offset mes11
    int 21h
	call menuJmp
    
    
	e2:
    cmp VALUEs,1
    je d4
	call getKeyJump 
    	
  
    d4 :
	call EndProgram
  
    
    ;esc 27
    ;f1  59
    ;f2  60
   

;;;;;;;;;;;;;;main;;;;;;;


;call drawconst
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gamewithchatBEGIN:
mov ax,0600h 
 mov bh,00 
 mov cl,0
 mov ch,21
 mov dh,25
 mov dl,4FH 
 int 10h
 
call updateInterface
call inlinechat
call clearbuffer
gamewithchat:

;call ChecKey
mov ah,1
int 16h


jz rec

mov ah,0
int 16h

mov VALUE,ah
cmp al,27  ;to exit if esc is pressed
je exit
call clearbuffer

call SendMovement
rec:
call RecieveMovement
jmp gamewithchat 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; return control to operating system
 
exit :
call EndProgram 
 
MAIN    ENDP



Endgame proc 
call clear
mov dl,5
mov dh,10
mov ah,2
mov bh,0
int 10h


mov  ah, 9
mov dx ,offset gameover
int 21h

c:
mov ah,0
int 16h

cmp ah,60
jnz c
jmp MAIN

Endgame endp
;;;;;;;;;;;;;;;;;;;

dispScore proc

mov ax,0600h 
mov bh,00
mov cx,0 
mov dx,184FH   
int 10h

mov ah,2 
mov dl, 15
mov dh, 16
mov bx,0
int 10h 
;displaylife
add life1,48
mov ah,9          ;Display 
mov bh,0          ;Page 0 
mov al,life1        ;Letter D 
mov cx,1          ;1 times 
mov bl,003h ;Green (A) on white(F) background 
int 10h 
sub life1,48
;;move cursor
mov ah,2 
mov dl, 12
mov dh, 13 
mov bx,0
int 10h

mov ah, 9 
mov dx, offset playername1
int 21h  

;;move cursor
mov ah,2 
mov dl, 25
mov dh, 16 
mov bx,0
int 10h 
;displaylife
add life2,48
mov ah,9          ;Display 
mov bh,0          ;Page 0 
mov al,life2        ;Letter D 
mov cx,1        ;1 times 
mov bl,00eh ;Green (A) on white(F) background 
int 10h 
sub life2,48
;;move cursor
mov ah,2 
mov dl, 25
mov dh, 13 
mov bx,0
int 10h

mov ah, 9 
mov dx, offset playername2
int 21h 

call delay
call delay
call delay
call delay
call delay

jmp MAIN

mov al,0
ret
dispScore endp
;;;;;;;;;;;;;;;;;;;;;;;
delay proc
MOV     CX, 0FH  ;delay
MOV     DX, 4240H ;delay
MOV     AH, 86H ;delay
INT     15H ;delay
ret
delay endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
killHIM1 proc

call bulletsound
mov countbull1,220
mov cx, px
add cx,40
mov temp,cx
mov BulletCoOrdinateX1,cx
mov dx, py  
mov BulletCoOrdinateY1,dx

mov dx, py    ; player row
mov bullet1y,dx


bulletloop1:
mov ah,1
int 16h

jz l4
mov ah,0
int 16h

mov VALUE,ah
call SendMovement

l4:
call RecieveMovement

mov cx, temp
mov dx, bullet1y     ; player row
add dx,25

call drawarrbulletbl

mov cx,temp         ;;;;;;;;;;;;;;;shield check
mov dx, bullet1y     ; player row
add dx,25
mov shld2coltemp,shld2col
add shld2coltemp,15
cmp cx, shld2coltemp                     
jne continueKill1    
cmp dx , shld2row
jb continueKill1
mov shld2rowtemp,shld2row
add shld2rowtemp,35
cmp dx,shld2rowtemp
ja continueKill1

jmp stop1

continueKill1:
inc temp
mov cx, temp
mov dx, bullet1y     ; player row
add dx,25

call drawarrbullet

dec countbull1
jnz bulletloop1
call CheckIfOneHitTwo          

stop1:
mov IfBullet,0                
jmp gamewithchatBEGIN
ret
killHIM1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;
tempEnd proc 
call Endgame
ret
tempEnd endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckIfOneHitTwo proc
push cx
push dx
mov bx,BulletCoOrdinateY1
mov dx,py2
sub dx,20
cmp bx,dx
jb return
mov cx,py2
add cx,10
cmp bx,cx
ja return 
dec life2
cmp life2,0
je tempEnd
call updateInterface
return:
pop dx
pop cx
ret
CheckIfOneHitTwo endp
;;;;;;;;;;;;;;;;;;;
CheckIfTwoHitOne proc
push cx
push dx
mov bx,BulletCoOrdinateY2
mov dx,py
sub dx,25
cmp bx,dx
jb return1
mov cx,py
add cx,20
cmp bx,cx
ja return 
dec life1
cmp life1,0
je tempEnd
call updateInterface
return1:
pop dx
pop cx
ret
CheckIfTwoHitOne endp

;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndProgram proc
   ;mov AH , 0
    ;INT 16h
    call CloseFile
    call CloseFile2 
    call CloseFilep   
    ;Change to Text MODE
    mov AH,0          
    mov AL,03h
    INT 10h    
    ; return control to operating system
    mov AH , 4ch
    INT 21H 
    ret
EndProgram endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RecieveChar proc
   tryR:
   mov dx , 3FDH		; Line Status Register
   in al , dx 
   test al , 1
   jz tryR
   
  	mov dx , 03F8H
  	in al , dx 
  	mov VALUEr , al
ret	
RecieveChar endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendChar proc
        tryS:
        mov dx , 3FDH		; Line Status Register
        In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ tryS           ;Not empty;tb lw mlyanh a5od mnh input tany wala lazm astna

  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUEs
  		out dx , al
ret		
SendChar endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;movement procs;;;;;;;;;;;;;;;;;;;;;;;;;;;
movUP1 proc 
cmp py,0
je ret1
sub py,10  
mov al,0  ;;;; to remove the key from the buffer 
jmp ret2
ret1:
mov py,0
ret2: 
call updateInterface
ret
movUP1 endp

movDOWN1 proc
cmp py,110        
je ret3
add py,10 
mov al,0 
jmp ret4
ret3:
mov py,110
ret4:
call updateInterface 
ret     
movDOWN1 endp
             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
movUP2 proc 
cmp py2,0
je re1
sub py2,10  
mov al,0  ;;;; to remove the key from the buffer 
jmp re2
re1:
mov py2,0
re2: 
call updateInterface
ret
movUP2 endp

movDOWN2 proc
cmp py2,110
je re3
add py2,10  
mov al,0  ;;;; to remove the key from the buffer 
jmp re4
re3:
mov py2,110
re4: 
call updateInterface
ret
movDOWN2 endp

killHIM2 proc
call bulletsound
mov countbull2,230
mov cx, px2
mov BulletCoOrdinateX2,cx
mov temp,cx
mov dx, py2 
mov BulletCoOrdinateY2,dx
mov dx, py2    ; player row
mov bullet2y,dx


bulletloop2:
mov ah,1
int 16h

jz ll4
mov ah,0
int 16h

cmp al,27
jne sss
call EndProgram


sss:
mov VALUE,ah
call SendMovement

ll4:
call RecieveMovement
mov cx, temp
mov dx, bullet2y     ; player row
add dx,20

call drawarrbulletbl


mov cx,temp
mov dx, bullet2y     ; player row
add dx,20
mov shld1coltemp,shld1col
sub shld1coltemp,7
cmp cx, shld1coltemp                      ;;fix ??? ???????
jne continueKill2    
cmp dx , shld1row
jb continueKill2
mov shld1rowtemp,shld1row
add shld1rowtemp,35
cmp dx,shld1rowtemp
ja continueKill2
jmp stop2

continueKill2:
;call updateInterface
dec temp
mov cx,temp
mov dx, bullet2y     ; player row
add dx,20
call drawarrbullet
dec countbull2
cmp countbull2,0
jnz bulletloop2

call CheckIfTwoHitOne           ;??? ???????
stop2:
mov IfBullet,0                  ;?????
jmp gamewithchatBEGIN
ret
killHIM2 endp           


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; updates interface;;;;;;;;;;;;;
updateInterface proc

inc time  
call clear 
cmp powerFlag,1
jnz r80
call drawNewp
r80:
call drawNEW
call drawNEW2
call drawShield1
call drawShield2
call displaylife1
call displaylife2
;hn3addel elclear 3shan t clear l7d bdayt elchat 
ret
updateInterface endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;sounds;;;;;;;;;;;;;;;;;;;;;;;;;;
 bulletsound proc    

MOV     DX,2000          ; Number of times to repeat whole routine.

MOV     BX,1             ; Frequency value.

MOV     AL, 10110110B    ; The Magic Number (use this binary number only)
OUT     43H, AL          ; Send it to the initializing port 43H Timer 2.

NEXT_FREQUENCY:          ; This is were we will jump back to 2000 times.

MOV     AX, BX           ; Move our Frequency value into AX.

OUT     42H, AL          ; Send LSB to port 42H.
MOV     AL, AH           ; Move MSB into AL  
OUT     42H, AL          ; Send MSB to port 42H.

IN      AL, 61H          ; Get current value of port 61H.
OR      AL, 00000011B    ; OR AL to this value, forcing first two bits high.
OUT     61H, AL          ; Copy it to port 61H of the PPI Chip
                         ; to turn ON the speaker.

MOV     CX, 100          ; Repeat loop 100 times
DELAY_LOOP:              ; Here is where we loop back too.
LOOP    DELAY_LOOP       ; Jump repeatedly to DELAY_LOOP until CX = 0


INC     BX               ; Incrementing the value of BX lowers 
                         ; the frequency each time we repeat the
                         ; whole routine

DEC     DX               ; Decrement repeat routine count

CMP     DX, 0            ; Is DX (repeat count) = to 0
JNZ     NEXT_FREQUENCY   ; If not jump to NEXT_FREQUENCY
                         ; and do whole routine again.

                         ; Else DX = 0 time to turn speaker OFF

IN      AL,61H           ; Get current value of port 61H.
AND     AL,11111100B     ; AND AL to this value, forcing first two bits low.
OUT     61H,AL           ; Copy it to port 61H of the PPI Chip
                         ; to
 ret 
 bulletsound endp
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;power ups procs;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 OpenFilep PROC 

    ; Open file

    mov AH, 3Dh
    mov AL, 0 ; read only
    LEA DX, powerFilename
    INT 21h
    
    ; you should check carry flag to make sure it Worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code
     
    mov [powerFilehandle], AX
    
    RET

OpenFilep ENDP


ReadDatap PROC

    mov AH,3Fh
    mov BX, [powerFilehandle]
    mov CX,powerW*powerH ; number of bytes to read
    LEA DX, powerData
    INT 21h
    RET
ReadDatap ENDP 


CloseFilep PROC
    mov AH, 3Eh
    MOV BX, [powerFilehandle]

    INT 21h
    RET
CloseFilep ENDP



 
drawNEWp  proc
 
    
    CALL ReadDatap   
    LEA BX , powerData ; BL contains index at the current draWn pixel
    
   
     
    mov CX,pux
    mov DX,puy
    mov AH,0ch
    add puW,cx
    add puh,dx
; DraWing loop 
pdraWLoop:
    mov AL,[BX]
    INT 10h 
    INC CX   
    INC BX
    CMP CX,puW
JNE pdraWLoop 
    
    mov CX ,pux
    INC DX
    CMP DX ,puh
JNE pdraWLoop
     mov al,0
     mov puW,powerW
     mov puh,powerH
     
     
    
 ret
 drawNEWp endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   PowerUpGenerator   proc           ;editd
   
   mov pTimer,6
               ;random player
   RANDPlayer:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9

   add  dl, '0'  ; to ascii from '0' to '9'
   
   mov Whichp,dl    ;;; if the random number is divisible by 2 it will appear to the first player 
   
   
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   RANDPosition:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9

   add  dl, '0'  ; to ascii from '0' to '9'
   mov RandomRow ,dx
    mov puy,dx
     ;;;;;;;;;;;;;;;;;                    
   test Whichp,1    ;; tests first bit 
   jnz  generator2
   
   
    ;;;;;;;;;;
   generator1:
 
   mov pux,10
   call drawNEWp
   
   gen1:
   ;call ChecKey
   mov dx,py
   mov bx,puy
   cmp dx,bx 
   jbe decL1        ;edited
   dec pTimer
   jnz gen1
   jmp return_
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   generator2:
   
   mov pux,270
   call drawNEWp
   
   gen2:
   ;call ChecKey
   
   mov dx,py2
   mov bx,puy                                                 
   cmp dx,bx
   jbe decL2       ;edited 
   
   dec pTimer
   jnz gen2
   
   jmp return_ 
   
   decL1:
   dec life2
   call displayLife2 
   jmp return_
   
   decL2:
    dec life1
   call displayLife1 
              ;;; decrease the lifes of the first player 

   return_:
   mov powerFlag,0
   mov pTimer ,6
   ret
   PowerUpGenerator endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;player one procs;;;;;;;;;;
OpenFile PROC 

    ; Open file

    mov AH, 3Dh
    mov AL, 0 ; read only
    LEA DX, playerFilename
    INT 21h
    
    ; you should check carry flag to make sure it Worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code
     
    mov [playerFilehandle], AX
    
    RET

OpenFile ENDP


ReadData PROC

    mov AH,3Fh
    mov BX, [playerFilehandle]
    mov CX,playerWidth*playerHeight ; number of bytes to read
    LEA DX, playerData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
    mov AH, 3Eh
    MOV BX, [playerFilehandle]

    INT 21h
    RET
CloseFile ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
delayfast proc 
Mov cx,00h   ;delay
mov dx,1240h
mov ah,86h
int 15h
ret
delayfast endp
;;;;;;;;;;;;;;;;;;;;;;;
delayslow proc 
Mov cx,00h   ;delay
mov dx,2240h
mov ah,86h
int 15h
ret
delayslow endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear proc
 mov ax,0600h 
 mov bh,00 
 mov cl,0
 mov ch,0 
 mov dh,20
 mov dl,4FH 
 int 10h
 
ret 
 clear endp
 
drawNEW  proc
 
    
    CALL ReadData   
    LEA BX , playerData ; BL contains index at the current draWn pixel
     
    mov CX,px
    mov DX,py
    mov AH,0ch
    add pW,cx
    add ph,dx
; DraWing loop 
draWLoop:
    mov AL,[BX]
    INT 10h 
    INC CX   
    INC BX
    CMP CX,pW
JNE draWLoop 
    
    mov CX ,px
    INC DX
    CMP DX ,ph
JNE draWLoop
     mov al,0
     mov pW,playerWidth
     mov ph,playerHeight
    
 ret
 drawNEW endp
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;player two XD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 OpenFile2 PROC 

    ; Open file

    mov AH, 3Dh
    mov AL, 0 ; read only
    LEA DX, playerFilename2
    INT 21h
    
    ; you should check carry flag to make sure it Worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code
     
    mov [playerFilehandle2], AX
    
    RET

OpenFile2 ENDP


ReadData2 PROC

    mov AH,3Fh
    mov BX, [playerFilehandle2]
    mov CX,playerWidth2*playerHeight2 ; number of bytes to read
    LEA DX, playerData2
    INT 21h
    RET
ReadData2 ENDP 


CloseFile2 PROC
    mov AH, 3Eh
    MOV BX, [playerFilehandle2]

    INT 21h
    RET
CloseFile2 ENDP



 
drawNEW2  proc
 
    
    CALL ReadData2   
    LEA BX , playerData2 ; BL contains index at the current draWn pixel
     
    mov CX,px2
    mov DX,py2
    mov AH,0ch
    add pW2,cx
    add ph2,dx
; DraWing loop 
draWLoop2:
    mov AL,[BX]
    INT 10h 
    INC CX   
    INC BX
    CMP CX,pW2
JNE draWLoop2 
    
    mov CX ,px2
    INC DX
    CMP DX ,ph2
JNE draWLoop2
     mov al,0
     mov pW2,playerWidth2
     mov ph2,playerHeight2
    
 ret
 drawNEW2 endp
 
drawarrbullet proc
;mov cx, bulletstrt1    ;get row(dx)from player position
mov ah,0ch       ;Draw Pixel Command 
mov al,0ch
mov bl,bulletlength
back7:   
int 10h 
inc cx      
dec bl      
jnz back7
cmp level,1
jne tt
call delayslow
tt:
call delayfast

ret
drawarrbullet endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawarrbulletbl proc
;mov cx, bulletstrt1    ;get row(dx)from player position
mov ah,0ch       ;Draw Pixel Command 
mov al,0h
mov bl,bulletlength
back10:   
int 10h 
inc cx      
dec bl      
jnz back10
ret
drawarrbulletbl endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawShield1 proc

mov ah,0ch       ;Draw Pixel Command 
mov cx,shld1col       ;Column 
mov dx,shld1row        ;Row       
mov al,shld1clr        ;Pixel color 
back9:   
int 10h         
inc dx     
cmp dx,160        
jnz back9 

mov ah,0ch       ;Draw Pixel Command 
mov cx,shld1col       ;Column 
inc cx
mov dx,shld1row        ;Row       
mov al,shld1clr        ;Pixel color 
zyada1:   
int 10h         
inc dx     
cmp dx,160        
jnz zyada1 

mov ah,0ch       ;Draw Pixel Command 
mov cx,shld1col       ;Column 
inc cx
inc cx
mov dx,shld1row        ;Row       
mov al,shld1clr        ;Pixel color 
zyadaa1:   
int 10h         
inc dx     
cmp dx,160        
jnz zyadaa1 

ret
drawShield1 endp
;;;;;;;;;;
drawShield2 proc
mov ah,0ch       ;Draw Pixel Command 
mov al,shld2clr       ;Pixel color 
mov cx,shld2col       ;Column 
mov dx,shld2row        ;Row       

back8:   
int 10h         
inc dx     
cmp dx,55       
jnz back8 


mov ah,0ch       ;Draw Pixel Command 
mov al,shld2clr       ;Pixel color 
mov cx,shld2col       ;Column 
inc cx
mov dx,shld2row        ;Row     
zyada:   
int 10h         
inc dx     
cmp dx,55       
jnz zyada

mov ah,0ch       ;Draw Pixel Command 
mov al,shld2clr       ;Pixel color 
mov cx,shld2col       ;Column 
inc cx
inc cx
mov dx,shld2row        ;Row     
zyadaa:   
int 10h         
inc dx     
cmp dx,55       
jnz zyadaa

ret
drawShield2 endp
;;;;;;;;;
clearbuffer proc
mov ah,0ch
mov al,0
int 21h
ret
clearbuffer endp
;;;;;;;;;;;;;;;
displaylife1 proc
;;move cursor
mov ah,2 
mov dl, 17
mov dh, 1
mov bx,0
int 10h 
;displaylife
add life1,48
mov ah,9          ;Display 
mov bh,0          ;Page 0 
mov al,life1        ;Letter D 
mov cx,1          ;1 times 
mov bl,003h ;Green (A) on white(F) background 
int 10h 
sub life1,48
mov ah,2 
mov dl, 10
mov dh, 1 
mov bx,0
int 10h

mov ah, 9 
mov dx, offset playername1
int 21h  
ret
displaylife1 endp
displaylife2 proc
;;move cursor
mov ah,2 
mov dl, 20
mov dh, 1 
mov bx,0
int 10h 
;displaylife
add life2,48
mov ah,9          ;Display 
mov bh,0          ;Page 0 
mov al,life2        ;Letter D 
mov cx,1        ;1 times 
mov bl,00eh ;Green (A) on white(F) background 
int 10h 
sub life2,48
mov ah,2 
mov dl, 23
mov dh, 1 
mov bx,0
int 10h

mov ah, 9 
mov dx, offset playername2
int 21h  
ret
displaylife2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkShield1 proc 
cmp BulletCoOrdinateX2 , shld1col
jne turn 

cmp BulletCoOrdinateY2 ,shld1row
 


turn :
ret 
checkShield1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendMovement proc

    cmp VALUE, 48h   ;UP.
    jne down3
	call movUP1
	jmp send
	
	down3:
    cmp VALUE, 50h   ;DOWN.
    jne shoot3
	call movDOWN1
	jmp send
	shoot3:
    ;cmp ah, 4Bh   ;LEFT.

    cmp VALUE, 4Dh   ;RIGHT.
	jne f44
	
   mov dx , 3FDH		; Line Status Register
   In al , dx 			;Read Line Status
   test al , 00100000b
   JZ return99 
   mov dx , 3F8H		; Transmit data register
   mov  al,VALUE
   out dx , al
   call killHIM1 
   jmp return99

	f44:
	cmp VALUE,3Eh
    jne return99
	mov dx , 3FDH		; Line Status Register
    In al , dx 			;Read Line Status
    test al , 00100000b
    JZ return99 
    mov dx , 3F8H		; Transmit data register
    mov  al,VALUE
    out dx , al
    call dispScore
	jmp return99
	
	cmp VALUE,1
    jne ex1
	call EndProgram
	ex1:
   cmp VALUE,0Eh
   jne o1
   mov isbackspace,1
   jmp contr1
   o1:cmp VALUE,1ch
   jne contr1
    mov isenter,1
	
	mov al,VALUE
	mov VALUEs,al
contr1:call displayinfirsthalf
  ;;;;;;;;;

send:
mov dx , 3FDH		; Line Status Register
In al , dx 			;Read Line Status
test al , 00100000b
JZ return99 
mov dx , 3F8H		; Transmit data register
mov  al,VALUE
out dx , al

return99:
ret
SendMovement endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RecieveMovement proc

mov dx , 3FDH		; Line Status Register
in al , dx 
test al , 1
JZ return100
  
mov dx , 03F8H
in al , dx 
mov VALUE , al


    cmp VALUE, 48h   ;UP.
    jne down4
	call movUP2
	jmp return100
	
	down4:
    cmp VALUE, 50h   ;DOWN.
    jne shoot4
	call movDOWN2
	jmp return100
	
	shoot4:
	cmp VALUE, 4Dh   ;right
	jne f4
    call killHIM2 

	f4:
	cmp VALUE,3Eh
    jne rt9
    call dispScore  ;;;;;;;;;
	
	rt9:
	cmp VALUE,1 ;esc
    jne ex
	call EndProgram
	ex:
    cmp VALUE,0Eh ;backspace   
    jne o
    mov isbackspace,1
    jmp contr
    o:	cmp VALUE,1ch  ;enter
    jne contr
    mov isenter,1
	mov al,VALUE
	mov VALUEr,al
contr:call displayinsecondhalf
        



return100:
ret
RecieveMovement endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
splitscreenchat proc
mov ax,0600h 
mov bh,00 
mov cx,0 
mov dx,184FH 
int 10h 
;;;;;;;;
mov ah,2     ; set cursor
mov dl,0
mov dh , 12  ; sender
int 10h 
;;;;;;;
mov ah,9          ;Display 
mov bh,0          ;Page 0 
mov al,'-'        ;Letter D 
mov cx,80         ;5 times 
mov bl,0fh ;Green (A) on white(F)
int 10h 
;;;;;;;;;;;;;
mov ah,2     ; set cursor
mov dl,0
mov dh ,0  ; sender
int 10h 
ret
splitscreenchat endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayinfirsthalfchat   PROC
cmp isbackspacechat,1
jne v1c 
cmp cursxchat,0
jne co1c
cmp cursychat,0
jne e1c
mov cursxchat,0
jmp f1c
e1c:
dec cursychat
dec di
mov ah,[di]
mov cursxchat,ah
jmp f1c
co1c:
dec cursxchat
f1c:
mov VALUEschat,32
jmp con1c
v1c:
cmp isenterchat,1
jne con1c
ic1c:
inc cursychat
mov ah,cursxchat
mov [di],ah
inc di
mov cursxchat,0
jmp cheaky1c
con1c:
mov AH,2
mov dl ,cursxchat 
mov dh ,cursychat 
Int 10h  ;to set the cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;display;;;;;;;;;;;;;;;;;;;;;
display1c:
mov AH,9  
mov bh,0          ;Page 0:
mov al ,VALUEschat ;Letter 
mov cx,1h         ;5 times 
mov bl,09h ;color
Int 10h      ;to display the character
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmp isbackspacechat,1
je finish1c
inc cursxchat 
cheakx1c:
cmp cursxchat ,80
jne finish1c
normal1c:
jmp ic1c
;mov cursxchat,0
;inc cursy
cheaky1c:
   cmp cursychat,12
   jne finish1c
   mov ah,6        ; function 6
   mov al,1        ; scroll by 1 line    
   mov bh,0     ; normal video attribute         
   mov ch,3        ; upper left Y
   mov cl,0        ; upper left X
   mov dh,11       ; lower right Y
   mov dl,79       ; lower right X 
   int 10h           
   ;Scroll up ;;;;;;;

;;;;;;;;;;;;;;;;
dec cursychat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finish1c:
mov AH,2
mov dl ,cursxchat 
mov dh ,cursychat 
Int 10h  ;to set the cursor
mov isbackspacechat,0
mov isenterchat,0
mov al,0
mov datatosendflagchat,0
ret
displayinfirsthalfchat   endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayinsecondhalfchat  PROC
cmp isbackspacechat,1
jne v11c 
cmp currxchat,0
jne co11c
cmp currychat,13
jne re1c
jmp f11c
re1c:
dec currychat
dec si
mov ah,[si]
mov currxchat,ah
jmp f11c
co11c:
dec currxchat
f11c:
mov al,32
jmp con11c
v11c:
cmp isenterchat,1
jne con11c
ic11c:
inc currychat
mov ah,currxchat
mov [si],ah
inc si
mov currxchat,0

jmp cheakychat
con11c:
mov AH,2
mov dl ,currxchat 
mov dh ,currychat 
Int 10h  ;to set the cursor
;;;;;;;;;;;;;;display;;;;;;;;;;;;;;;;;;;;;
mov AH,9  
mov bh,0          ;Page 0:al ,Letter 
mov cx,1h         ;1 times 
mov bl,0eh      ; background 
Int 10h      ;to display the character
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmp isbackspacechat,1
je finishsh1c
inc currxchat
cheakxx1c:
cmp currxchat ,80
jne finishsh1c
normall1c:
jmp ic11c
;mov currx,0
;inc curry
cheakychat:
   cmp currychat,25
   jne finishsh1c
   mov ah,6        ; function 6
   mov al,1        ; scroll by 1 line    
   mov bh,0     ; normal video attribute         
   mov ch,16        ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24       ; lower right Y
   mov dl,79       ; lower right X 
   int 10h           
   ;Scroll up ;;;;;;;

;;;;;;;;;;;;;;;;
dec currychat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finishsh1c:
mov AH,2
mov dl ,cursxchat 
mov dh ,cursychat 
Int 10h  ;to set the cursor
mov isenterchat,0
mov isbackspacechat,0
mov al,0
ret
displayinsecondhalfchat  endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
chatMode    PROC 

mov ah,6        ; function 6
   mov al,00       ; scroll by 1 line    
   mov bh,0     ; normal video attribute         
   mov ch,00        ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24       ; lower right Y
   mov dl,79       ; lower right X 
   int 10h           
    mov AH,0          
    mov AL,03h
    INT 10h    
	
	;mov ah,2     ; set cursor
    ;mov dl,0
    ;mov dh , 1  ; sender
    ;int 10h 
	
	;mov ax,9
	;mov dx ,offset playername1
	;int 21h
	
	
	;mov ah,2     ; set cursor
    ;mov dl,0
    ;mov dh ,14  ; sender
    ;int 10h 

	;mov ax,9
	;mov dx ,offset playername2
	;int 21h
	

mov di,offset lastsxchat
mov si,offset lastrxchat


call splitscreenchat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cheakreceivechat:
;;;;;;;;;;;;;receive;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check that Data is Ready
	mov dx , 3FDH		; Line Status Register
	in al , dx 
  	test al , 1
  	Jz CHKeychat                                   ;Not Ready
 ;If Ready read the VALUE in Receive data register
  	mov dx , 03F8H
  	in al , dx 
  	mov VALUErchat , al
    mov al , VALUErchat
	cmp al,27
    je exit1c
	cmp al,8
	jne o1c
	mov isbackspacechat,1
    jmp contr1c
o1c:cmp al,13
    jne contr1c
	mov isenterchat,1
contr1c:call displayinsecondhalfchat
jmp cheakreceivechat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHKeychat:
mov al,0
cmp datatosendflagchat,1
je sendchat
mov AH,01h
Int 16h
cmp al,0
je cheakreceivechat
mov AH,00h;;;read the char and put in al
Int 16h
mov VALUEschat,al ;;;;;;;;;data to send
;;;;;;;;;;;;;;;;;send;;;;;;;;;;;;;;;;;;;;
sendchat:;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
        In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ cheakreceivechat            ;Not empty;tb lw mlyanh a5od mnh input tany wala lazm astna

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUEschat
  		out dx , al
		cmp al,27
        je exit1c
		cmp al,8
		jne j1c
		mov isbackspacechat,1
		jmp cont1c
	j1c:	cmp al,13
		jne cont1c
        mov isenterchat,1		
cont1c:call displayinfirsthalfchat
jmp cheakreceivechat

exit1c:
 call EndProgram
 ret
chatMode    ENDP

END MAIN