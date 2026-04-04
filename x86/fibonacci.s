global _start
extern printf, scanf	; import librarys

section .data
	seq db "Input max fibonacci number:", 0x0a	; Initial message printed
	seqLength equ $-seq		; length of seq string
	outFormat db "%d", 0x0a, 0x00	; format for outputting current number
	inputFormat db "%d", 0x00	; format for user input

section .bss
	userInput resb 1	; reserve 1 byte of buffer space for user input

section .text
_start:
	call printMessage	; print fibonacci message
	call getInput		; stdin user input
	call initFib		; start of fibonacci
	call loopFib		; iterate fibonacci
	call exitProgram	; exit with success status code

getInput:		; get user input and assign to allocated buffer
	sub rsp, 8		; align stack for function call
	mov rdi, inputFormat	; set 1st parameter (inputFormat)
	mov rsi, userInput	; set 2nd parameter (userInput buffer)
	call scanf		; scanf(inputFormat, userInput)
	add rsp, 8		; restore to initial state
	ret

printFib:		; print current fibonacci number (stored in rbx) to stdout
	push rax	; push to stack to prepare for func call
	push rbx
	mov rdi, outFormat	; set 1st argument (print format)
	mov rsi, rbx		; set 2nd argument (fibonacci number)
	call printf	; printf(outFormat, rbx)
	pop rbx		; restore stack after function call
	pop rax
	ret

printMessage:		; Print instruction for user input
	mov rax, 1	; syscall 1
	mov rdi, 1	; stdout
	mov rsi, seq	; pointer to message
	mov rdx, seqLength	; length to display
	syscall
	ret
	
initFib:		; Start fibonacci sequence
	xor rax, rax	; start fibonacci sequence
	xor rbx, rbx	; sets both parameters to 0
	inc rbx		; increment for initial number
	ret
loopFib:		; Loop / iterate fibonacci sequence
	call printFib
	add rax, rbx
	xchg rax, rbx
	cmp rbx, [userInput]	; check if greater then target (userInput buffer from user)
	js loopFib
	ret

exitProgram:		; Exit with status 0 (success)
	mov rax, 60	; exit
	mov rdi, 0	; no error
	syscall		; exit syscall

