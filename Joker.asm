IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
;------------------------
;here is the Opening text you will resive as soon as you open the game
;this will ask you to choose a theme!
;------------------------
WelcomeMessege db "Welcome to the game hangman!" , 0
HowItWorks db "   Here I will give you a word and" , 0
howitworks2 db "      you'll have to guess it" , 0
ThemeChoosing1 db "  We have 4 themes you can choose from: ", 0
ThemeChoosing2 	db "  subjects, Food, games and vegies:", 0
;-------------------------
;here are some mseges that will display along playing
;-------------------------
outputMsg db "you choose: $"
topicGames db "Topic: Games", 0
topicFood db "Topic: Food", 0
topicSubjects db "Topic: subjects", 0
topicVegies db "Topic: vegetables", 0
Winning db "You won! :D ", 0
losing db "You lose! ):", 0

;-----------------------------
;the player picks the theme and then a random number will be generated
;this number will deside what is the word that will be choosen for the player to guess
;-----------------------------

food db "cheeseburger", 0, "nachos" , 0, "grilledcheese", 0, "schnitzel", 0


subjects db "engineer", 0, "robotics", 0, "photography", 0, "physics", 0


games db "minecraft", 0, "poker", 0, "neverhaveiever", 0, "overwatch", 0


vegetables db "peper", 0, "eggplants", 0, "kale", 0, "spinach", 0

;---------------------
;some variables of all kinds:
;---------------------

userInput db 100, ?, 100 dup(0)
rowsY db 3
columesX db 10
WordChoosen db ?
x dw 100
y dw 100
color db 2
string_length dw ?
vegiescmp dw 6
subjectscmp dw 8
gamescmp dw 5
foodcmp dw 4
random_numbey dw ?
choosen_string dw ?
topic_coosen dw ?
currentX dw ?
currentY dw ?
word_display db 20 dup('_'), 0
word_length dw ?
letters_guessed dw 0
input_row db 20
input_col db 1
worng_guesses dw 0
block_x     dw 50
block_y     dw 50 
block_color db 15 
; --------------------------
;this part of procs contains the actual
;drawing of the whole hangman that shows up
;where its being called where it can be sorted out
;-------------------------------
CODESEG
proc draw_head
	mov ax, [block_y]
	add ax, 35
	mov [block_y], ax
	mov ax, 3
	mov [block_color], al
	mov dx, [block_y]
	sub dx, 5
	mov [block_y], dx
	call bigpixel
	mov bx, [block_x]
	sub bx, 5
	mov [block_x], bx
	call bigpixel
	add bx, 10
	mov [block_x], bx
	call bigpixel
	mov cx, 2
diagnalLoop1:
	add bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop1
	mov cx, 3
downloop1:
	sub dx, 5
	mov [block_y], dx
	call bigpixel
	loop downloop1
	mov cx, 2
diagnalLoop2:
	sub bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop2
	mov cx, 3
forwardloop1:
	sub bx, 5	
	mov [block_x], bx
	call bigpixel
	loop forwardloop1
	mov cx, 2
diagnalLoop3:
	sub bx, 5
	add dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop3
	mov cx, 3
uploop1:
	add dx, 5	
	mov [block_y], dx
	call bigpixel
	loop uploop1
	mov cx, 2
diagnalLoop4:
	add dx, 5
	add bx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop4
		ret
endp draw_head
;---------------------------------------------
proc draw_body 
	mov [block_color], 93
	mov bx, [block_x]
	add bx, 7
	mov [block_x], bx
	mov cx, 5
bodyLoop:
	mov dx, [block_y]
	add dx, 5
	mov [block_y], dx
	call bigpixel
	loop bodyLoop
		ret
endp draw_body
;---------------------------------------------
proc draw_right_leg
	mov [block_color], 101

	mov cx, 3
	mov bx, [block_x]
	mov dx, [block_y]
	sub dx, 15
	add bx, 15
	mov [block_x], bx
	mov [block_y], dx

	
legloop1:
	mov dx, [block_y]
	mov bx, [block_x]
	add bx, 5
	add dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop legloop1
		ret
endp draw_right_leg
;---------------------------------------------
proc draw_left_leg
	mov [block_color], 65
	mov cx, 3

legloop2:
	mov dx, [block_y]
	mov bx, [block_x]
	sub bx, 5
	add dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop legloop2
		ret
endp draw_left_leg
;---------------------------------------------
proc draw_right_hand
	mov [block_color], 21
	mov cx, 3
	mov bx, [block_x]
	mov dx, [block_y]
	add dx, 15
	add bx, 15
	mov [block_x], bx
	mov [block_y], dx
	
handloop1:
	mov dx, [block_y]
	mov bx, [block_x]
	add bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop handloop1
	
		ret
endp draw_right_hand
;---------------------------------------------
proc draw_left_hand
	mov [block_color], 104
	mov cx, 3
	mov bx, [block_x]
	mov dx, [block_y]
	sub dx, 20
	sub bx, 15
	mov [block_x], bx
	mov [block_y], dx
	
handloop2:
	mov dx, [block_y]
	mov bx, [block_x]
	sub bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop handloop2
	
		ret
endp draw_left_hand
;---------------------------------------------
proc draw_eye1
	mov [block_color], 9
	mov bx, [block_x]
	mov dx, [block_y]
	sub dx, 25
	sub bx, 20
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
		ret
endp draw_eye1
;---------------------------------------------
proc draw_eye2
	mov [block_color], 15
	mov bx, [block_x]
	add bx, 10
	mov [block_x], bx
	call bigpixel
		ret
endp draw_eye2
;---------------------------------------------
proc draw_sad_face
	mov [block_color], 76
	mov dx, [block_y]
	add dx, 10
	mov [block_y], dx
	mov cx, 3
faceLoop:
	mov bx, [block_x]
	call bigpixel
	sub bx, 5
	mov [block_x], bx
	loop faceLoop
		ret
endp draw_sad_face
;---------------------------------------------
proc draw_xs
	mov [block_color], 4
	mov ax, [block_y]
	add ax, 35
	mov [block_y], ax
	mov ax, 3
	mov dx, [block_y]
	sub dx, 5
	mov [block_y], dx
	call bigpixel
	mov bx, [block_x]
	sub bx, 5
	mov [block_x], bx
	call bigpixel
	add bx, 10
	mov [block_x], bx
	call bigpixel
	mov cx, 2
diagnalLoop11:
	add bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop11
	mov cx, 3
downloop11:
	sub dx, 5
	mov [block_y], dx
	call bigpixel
	loop downloop11
	mov cx, 2
diagnalLoop21:
	sub bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop21
	mov cx, 3
forwardloop11:
	sub bx, 5	
	mov [block_x], bx
	call bigpixel
	loop forwardloop11
	mov cx, 2
diagnalLoop31:
	sub bx, 5
	add dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop31
	mov cx, 3
uploop11:
	add dx, 5	
	mov [block_y], dx
	call bigpixel
	loop uploop11
	mov cx, 2
diagnalLoop41:
	add dx, 5
	add bx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop diagnalLoop41
	
	;body
	
	mov bx, [block_x]
	add bx, 7
	mov [block_x], bx
	mov cx, 5
bodyLoop1:
	mov dx, [block_y]
	add dx, 5
	mov [block_y], dx
	call bigpixel
	loop bodyLoop1
	
    ;left leg
	
	mov cx, 3
legloop21:
	mov dx, [block_y]
	mov bx, [block_x]
	sub bx, 5
	add dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop legloop21
	
	;rightleg
	
	mov cx, 3
	mov bx, [block_x]
	mov dx, [block_y]
	sub dx, 15
	add bx, 15
	mov [block_x], bx
	mov [block_y], dx

	
legloop11:
	mov dx, [block_y]
	mov bx, [block_x]
	add bx, 5
	add dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop legloop11
	
	;left hand
	
	mov cx, 3
	mov bx, [block_x]
	mov dx, [block_y]
	sub dx, 20
	sub bx, 15
	mov [block_x], bx
	mov [block_y], dx
	
handloop21:
	mov dx, [block_y]
	mov bx, [block_x]
	sub bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop handloop21
	
	;right hand
	
	mov cx, 3
	mov bx, [block_x]
	mov dx, [block_y]
	add dx, 15
	add bx, 15
	mov [block_x], bx
	mov [block_y], dx
	
handloop11:
	mov dx, [block_y]
	mov bx, [block_x]
	add bx, 5
	sub dx, 5
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	loop handloop11
	
	;eye1
	
	mov bx, [block_x]
	mov dx, [block_y]
	sub dx, 25
	sub bx, 20
	mov [block_x], bx
	mov [block_y], dx
	call bigpixel
	
	;eye2
	
	mov bx, [block_x]
	add bx, 10
	mov [block_x], bx
	call bigpixel
	 
	;face
	mov dx, [block_y]
	add dx, 10
	mov [block_y], dx
	mov cx, 3
faceLoop1:
	mov bx, [block_x]
	call bigpixel
	sub bx, 5
	mov [block_x], bx
	loop faceLoop1
	mov ah, 00h
	int 16h
		ret
endp draw_xs
;--------------------------------------------
;end of the procs for drawing the hangman
;---------------------------------------------
proc bigpixel 
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov si, 0
    
row_loop:
    mov di, 0
    
col_loop:
    ; calculate pixel position
    mov ax, [block_y]
    add ax, si
    mov dx, ax
    
    mov ax, [block_x]
    add ax, di
    mov cx, ax
    
    ; set pixel color
    mov ah, 0ch
    mov al, [block_color]
    mov bh, 0
    int 10h
    
    inc di
    cmp di, 5
    jl col_loop
    
    inc si
    cmp si, 5
    jl row_loop
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
	
		ret
endp bigpixel 
;-------------------------------------------
proc answer_input NEAR
	push ax
	push bx
	push dx
    
    ; Use fixed position for input
    mov ah, 02h
    mov bh, 0
    mov dh, [input_row]
    mov dl, [input_col]
    int 10h
    
    mov ah, 0Ah
    mov dx, offset userInput
    int 21h
    
    xor bh, bh
    mov bl, [userInput+1]
    mov [byte ptr userInput + 2 + bx], 0
    pop dx
    pop bx
    pop ax
		ret
endp answer_input
;--------------------------------------------
proc print_input
    push ax
    push bx
    push dx
    
    ; Use fixed position for output message
    mov ah, 02h
    mov bh, 0
    mov dh, [input_row]
    mov dl, [input_col]
    int 10h
    
    mov ah, 09h
    mov dx, offset outputMsg
    int 21h
    
    ; Print only the actual input characters
    xor bh, bh
    mov bl, [userInput+1]  ; Get actual length
    mov [byte ptr userInput + 2 + bx], '$'  ; Add $ for print
    mov ah, 09h
    lea dx, [userInput+2]
    int 21h
    
    pop dx
    pop bx
    pop ax
    mov ah, 01h
    int 21h
    ret
endp print_input
;---------------------------------------------------------------------
proc clear_input_area NEAR
    push ax
    push bx
    push cx
    push dx
    
    ; Use fixed position for clearing
    mov ah, 02h
    mov bh, 0
    mov dh, [input_row]
    mov dl, [input_col]
    int 10h
    
    ; Print spaces to overwrite the input
    mov cx, 50          ; Clear more characters to ensure complete clearing
clear_loop:
    mov ah, 0Eh
    mov al, ' '         ; Space character
    mov bh, 0
    mov bl, 0Fh
    int 10h
    loop clear_loop
    
    ; Reset cursor position for next input
    mov ah, 02h
    mov bh, 0
    mov dh, [input_row]
    mov dl, [input_col]
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp clear_input_area

;-----------------------------------------------------------

proc cmp_strings FAR
	push ax
	push bx
	push dx
	push cx
	push si
	lea si, [userInput + 2]
	mov cx, 0

	count_loop:
	mov al, [si]
	cmp al, 0
	je check_vegies
	inc cx
	inc si
	jmp count_loop

	check_vegies:
	dec cx
	mov [string_length], cx
	mov ax, [vegiescmp]
	cmp cx, ax
	jne check_games
	mov [topic_coosen], 3
	jmp cmp_done

	check_games:
	mov ax, [gamescmp]
	cmp cx, ax
	jne check_subjects
	mov [topic_coosen], 2
	jmp cmp_done

	check_subjects:
	mov ax, [subjectscmp]
	cmp cx, ax
	jne check_food
	mov [topic_coosen], 1
	jmp cmp_done
	
	check_food:
	mov ax, [foodcmp]
	cmp cx, ax
	jne defalt
	mov [topic_coosen], 4
	jmp cmp_done

	defalt:
	mov [topic_coosen], 4
	jmp cmp_done

	cmp_done:
	pop si
	pop cx
	pop dx
	pop bx
	pop ax
		retf
	endp cmp_strings
;---------------------------------------
proc init_word_display NEAR
    push ax
    push bx
    push cx
    push si
    push di
    
    mov si, [choosen_string]
    mov cx, 0
count_word_length:
    mov al, [si]
    cmp al, 0
    je length_done
    inc cx
    inc si
    jmp count_word_length
    
length_done:
    mov [word_length], cx
    mov di, offset word_display
    mov bx, cx
    
build_display:
    mov [byte ptr di], ('_')
    inc di
    dec bx
    cmp bx, 0
    je display_done
    mov [byte ptr di], (' ') 
    inc di
    jmp build_display
    
display_done:
    mov [byte ptr di], 0
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
		ret
endp init_word_display
;------------------------------------------
proc print_word_display NEAR
    push ax
    push bx
    push si
    
    mov si, offset word_display
	mov ah, 02h         
    mov bh, 0
	mov bl, 15 ;color
    mov dh, 40 ;y coreds   
    mov dl, 160 ;x coreds 
    int 10h
	
print_looppp:
    mov al, [si]
    cmp al, 0
    je print_done
    
    mov ah, 0Eh             ; teletype output function
    int 10h                 ; BIOS video interrupt
    
    inc si
    jmp print_looppp
    
print_done:
    pop si
    pop bx
    pop ax
    ret
endp print_word_display
;---------------------------------------------------
;end of all procs
;---------------------------------------------------
start:	
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
;--------------------------
Opening:
	mov ax, 13h
	int 10h
;-------------------------------------
;this part prints out the WelcomeMesseges and instractions for the game
;-------------------------------------
	mov ah, 02h
	mov bh, 0
	mov dh, [rowsY]
	mov dl, 5
	int 10h
	
	mov si, offset WelcomeMessege
	
	print_loop:
	mov al, [si]
	cmp al, 0
	mov ah, 0Eh
	je sentance2
	mov bh, 0            
    mov bl, 0Fh         
    int 10h           
    
    inc si
    jmp print_loop
    
	
	sentance2:
    mov al, [rowsY]
    add al, 2
    mov [rowsY], al
    mov ah, 02h
    mov bh, 0
    mov dh, [rowsY]
    mov dl, 1
    int 10h
    
    mov si, offset HowItWorks
	print_loop2:
    mov al, [si]
    cmp al, 0
    je sentancee2
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loop2
    
	sentancee2:
	mov al, [rowsY]
    add al, 2            
    mov [rowsY], al      
    
   
    mov ah, 02h         
    mov bh, 0            
    mov dh, [rowsY]   
    mov dl, 1         
    int 10h
    
    mov si, offset howitworks2
	print_loopp2:
    mov al, [si]
    cmp al, 0
    je sentance3         
    
    mov ah, 0Eh 
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loopp2
	
	sentance3:
    mov al, [rowsY]
    add al, 2            
    mov [rowsY], al      
    
   
    mov ah, 02h         
    mov bh, 0            
    mov dh, [rowsY]   
    mov dl, 1         
    int 10h
    
    mov si, offset ThemeChoosing1
	print_loop3:
    mov al, [si]
    cmp al, 0
    je sentance4         
    
    mov ah, 0Eh 
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loop3
    
	sentance4:
    mov al, [rowsY]
    add al, 2            
    mov [rowsY], al      
    
   
    mov ah, 02h         
    mov bh, 0            
    mov dh, [rowsY]   
    mov dl, 1         
    int 10h
    
    mov si, offset ThemeChoosing2
	
	print_loop4:
    mov al, [si]
    cmp al, 0
    je answer         
    
    mov ah, 0Eh 
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loop4
	
answer:
	call answer_input
	call print_input
	call cmp_strings

	

;----------------------------------------------------------------------------------
;this part will generate a random number find which one of the themes the
;user choose matches the discription and pick a random word from that theme 

;------------------------Diffrant aproce-------------------------------------------

;generate's a random numebr between 1-4 to determan the word
;that the player will be needing to guess
;----------------------------------------------------------------------------------

randomnumber:
    mov ah, 00h
    int 1Ah
    xor dx, cx
    rol dx, 7
    add dx, 8765
    
    mov ax, dx
    xor dx, dx
    mov bx, 5
    div bx
    
    mov [random_numbey], dx
theme:

	mov ax, [topic_coosen]
	cmp ax, 3 
	je vegetablesarr
	cmp ax, 4
	je foodndefaltarr
	cmp ax, 1
	je subjectsarr
	cmp ax, 2
	jmp gamesarr


vegetablesarr:
	mov si, offset vegetables
	jmp find_string
	
foodndefaltarr:
	mov si, offset food
	jmp find_string
	
subjectsarr:
	mov si, offset subjects
	jmp find_string
	
gamesarr:
	mov si, offset games
	jmp find_string
	
find_string:
	mov cx, ax
	cmp cx, 0
	je found_it
	
skip_letters:
	mov al, [si]
	inc si
	cmp al, 0 
	jne skip_letters
	dec cx
	jmp find_string
	
found_it:
	mov [choosen_string], si
	jmp gamestart
	
;---------------------------
jumping_platform2:
	jmp guess
;---------------------------

;---------------------------
gameoffset:
	mov si, offset topicGames
	jmp topic_title
vegiesoffset:
	mov si, offset topicVegies
	jmp topic_title
subjectsoffset:
	mov si, offset topicSubjects
	jmp topic_title
foodoffset:
	mov si, offset topicFood
	jmp topic_title
	
gamestart:
	mov ah, 00h
	mov al, 13h
	int 10h 
	
	mov ax, [topic_coosen]
	cmp ax, 1
	je subjectsoffset
	cmp ax, 2
	je gameoffset
	cmp ax, 3
	je vegiesoffset
	cmp ax, 4
	je foodoffset
	jmp foodoffset

	
topic_title:
	mov ah, 02h         
    mov bh, 0            
    mov dh, 3   
    mov dl, 10          
    int 10h
    	
	print_loop8:
    mov al, [si]
    cmp al, 0
    je grafics         
    
    mov ah, 0Eh 
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loop8
	
grafics:
	mov [x], 50
	mov [y], 150
	
	mov al, [rowsY]
    add al, 2            
    mov [rowsY], al 
	
	call init_word_display
	call print_word_display
	mov dx, 0

	
stand:
	push ax
    push bx
    push cx
    
    mov al, [block_color]
    push ax
    
    mov [block_color], 105
    
    ; draw base 
    mov [block_x], 240
    mov [block_y], 155
    mov cx, 12
base_loop:
    call bigpixel
    add [block_x], 5
    loop base_loop
    
    ; draw vertical post
    mov [block_x], 260
    mov [block_y], 30
    mov cx, 26
post_loop:
    call bigpixel
    add [block_y], 5
    loop post_loop
    
    ; draw top horizontal beam
    mov [block_x], 260
    mov [block_y], 30
    mov cx, 8
top_beam_loop:
    call bigpixel
    sub [block_x], 5
    loop top_beam_loop
    
    ; draw noose support
    mov [block_x], 225
    mov [block_y], 35
    mov cx, 6
noose_loop:
    call bigpixel
    add [block_y], 5
    loop noose_loop
    
    pop ax
    mov [block_color], al
    
    pop cx
    pop bx
    pop ax
		
guess:
	push dx
	call clear_input_area
	call answer_input
	xor cx, cx
	xor dx, dx
guess_loop:
	mov bl, [userInput+2]
	mov si, [choosen_string]
	add si, cx
	mov al, [si]
	cmp al, 0
	je jumping_platform
	cmp al, bl
	je correct
	inc cx
	jmp guess_loop
	
correct:
    call clear_input_area
	mov cx, [letters_guessed]
	inc cx
	mov [letters_guessed], cx
    push ax
    push bx
    push cx
    push si
    push di
	
check_for_a_win:
    mov si, offset word_display
    mov cx, 0
check_win_loop:
    mov al, [si]
    cmp al, 0
    je check_win_done
    cmp al, '_'
    je not_won_yet
    cmp al, ' '
    je skip_space
    inc si
    jmp check_win_loop

skip_space:
    inc si
    jmp check_win_loop

check_win_done:
    ; Player won - all letters guessed
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    jmp win
	
jumping_platform:
    cmp dx, 10
    jge jumping_platform3
    jmp worng

not_won_yet:
    ; Continue with letter update logic
    mov si, [choosen_string]
    mov di, offset word_display
    mov bl, [userInput+2]
    
check_letter_loop:
    mov al, [si]
    cmp al, 0
    je update_done
    cmp al, bl
    jne next_letter
    mov [di], bl
next_letter:
    add di, 2
    inc si
    jmp check_letter_loop

update_done:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    
    call print_word_display
    
    ; Check if word is complete
    mov si, offset word_display
check_complete_loop:
    mov al, [si]
    cmp al, 0
    je word_complete
    cmp al, '_'
    je continue_guessing
    inc si
    jmp check_complete_loop

word_complete:
    jmp win

continue_guessing:
    mov ah, 02h         
    mov bh, 0            
    mov dh, [input_row]   
    mov dl, [input_col]         
    int 10h
    
    lea si, [userInput+2]
    print_loop5:
    mov al, [si]
    cmp al, 0
    je doneloop
    
    mov ah, 0Eh
    mov bh, 0            
    mov bl, 0Fh         
    int 10h           
    
    inc si
    jmp print_loop5

doneloop:
    jmp guess
jumping_platform3:
	jmp lose
	
worng:
	call clear_input_area
	mov ax, [x]
	mov [currentX], ax
	mov dx, [worng_guesses]
	inc dx
	mov [worng_guesses], dx
	
	cmp dx, 1
	je head
	cmp dx, 2
	je body
	cmp dx, 3
	je leftleg
	cmp dx, 4
	je rightleg
	cmp dx, 5
	je leftHand
	cmp dx, 6
	je rightHand
	cmp dx, 7
	je leftEye
	cmp dx, 8
	je rightEye
	cmp dx, 9
	je sadface
	cmp dx, 10
	je x2
Hangingman:

head:
	call draw_head
	jmp guess
body:
	call draw_body
	jmp guess
leftleg:
	call draw_left_leg
	jmp guess
rightleg:
	call draw_right_leg
	jmp guess
rightHand:
	call draw_right_hand
	jmp guess
leftHand:
	call draw_left_hand
	jmp guess
leftEye:
	call draw_eye1
	jmp guess
rightEye:
	call draw_eye2
	jmp guess
sadface:
	call draw_sad_face
	jmp guess
x2:
	call draw_xs
	jmp lose
lose:
	mov ah, 00h
	mov al, 13h
	int 10h 
    mov ah, 02h         
    mov bh, 0            
    mov dh, 12   
    mov dl, 15         
    int 10h
	
	mov si, offset losing
print_loop6:
    mov al, [si]
    cmp al, 0
    je wait_for_key         
    
    mov ah, 0Eh 
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loop6
	
win:
	mov ah, 00h
	mov al, 13h
	int 10h 
	
    mov ah, 02h         
    mov bh, 0            
    mov dh, 12
    mov dl, 15         
    int 10h
    
    mov si, offset Winning
    print_loop7:
    mov al, [si]
    cmp al, 0
    je wait_for_key         
    
    mov ah, 0Eh 
    mov bh, 0
    mov bl, 0Fh
    int 10h
    
    inc si
    jmp print_loop7

wait_for_key:
    mov ah, 00h
    int 16h

exit:
    mov ax, 4C00h      
    int 21h
END start