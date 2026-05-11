extern printf, scanf	; import library

                        ; // syscall reference "https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md"

section .data
	; seq db "Sending HTTP request:", 0x0a	; Status message
	; seqLength equ $-seq		                ; Length
    httpReqMsg db "HTTP/1.0 200 OK", 13, 10, 13, 10   ; "HTTP/1.0 200 OK\r\n\r\n"
    httpReqLen equ $-httpReqMsg             ; Length
	outFormat db "%d", 0x0a, 0x00	        ; format for outputting current number
	inputFormat db "%d", 0x00	            ; format for user input

    sockaddr:
        dw 2            ; AF_INET
        dw 0x5c11       ; Port 4444 (Big Endian = 0x115C & Little Endian = 0x5C11)
        dd 0            ; Address 0.0.0.0
        times 8 db 0    ; Padding

    readBuff:
        times 1024 db 0 ; Buffer for incoming HTTP request

    filePath:
        times 256 db 0  ; Buffer for extracted file path


section .bss
	userInput resb 8	; reserve 1 byte of buffer space for user input


section .text
global _start

_start:
	call createSocket
    call bindSocket
    call listen
    call mainLoop           ; Loop through accept and response flow
    mov r11, 0x43           ; successful program exit - full execution
    call exitProgram


;   ; Main loop functions for parent and spawning child process
;   ; ------------------------------------------------------------
;   ; mainLoop - Loop through initialisation and spawning child proc, should never reach ret instruction
;   ; forkProc - Multithreading, create child process and close parent file descriptor
;   ; accept - accept incoming connections, que set to 0 as multithreaded execution should allow for handling of multiple requests
;   ; childMain - child process only

childMain:
    mov rdi, r12        ; close listening socket
    mov rax, 0x3        ; syscall Close
    syscall
    call childRead

childRead:
    mov rdi, r13
    lea rsi, readBuff
    mov rdx, 1024       ; size of readBuff
    mov rax, 0          ; syscall Read
    syscall
    mov r14, rax        ; bytes read

    ; parse HTTP path   ; TODO; need to rework the below incoming request parser
    lea rsi, readBuff
    lea rdi, filePath
    add rsi, 4
parseLoop:
    cmp byte [rsi], ' '
    je endParse
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    jmp parseLoop
endParse:
    mov byte [rdi], 0
; open
    lea rdi, [filePath]
    xor rsi, rsi
    mov rax, 2
    syscall
    mov r15, rax
; read
    mov rdi, r15
    lea rsi, [readBuff]
    mov rdx, 1024
    mov rax, 0              ; syscall Read
    syscall
    mov r14, rax
; close
    mov rdi, r15
    mov rax, 3              ; syscall Close
    syscall
; write
    mov rdi, r13
    lea rsi, [httpReqMsg]
    mov rdx, httpReqLen
    mov rax, 1
    syscall
; write
    mov rdi, r13
    lea rsi, [readBuff]
    mov rdx, r14
    mov rax, 1
    syscall
; close
    mov rdi, r13
    mov rax, 3
    syscall
; exit
    mov r11, 0x43           ; successful program exit - full execution
    call exitProgram


mainLoop:
    call accept
    call forkProc       ; spawns child proc and cleans up parent proc
    ret

forkProc:
    mov rax, 0x39       ; syscall fork
    syscall
    test rax, rax       ; for child process rax==0
    jz childMain        ; child process
    mov rax, 0x3        ; syscall Close
    mov rdi, r13        ; clientfd
    syscall             ; close client socket
    jmp mainLoop

accept:
    mov rdi, r12                ; sockfd
    xor rsi, rsi                ; set to 0
    xor rdx, rdx                ; set to 0
    mov rax, 0x2b               ; syscall Accept
    mov r11, rax                ; Store error handling var
    syscall
    mov r13, rax                ; clientfd
    ret


;   ; Connection setup functions
;   ; ------------------------------------------------------------
;   ; createSocket - Handle new socket
;   ; bindSocket - Handle bind
;   ; listen - listen for incoming message

createSocket:
	mov rax, 0x29   ; syscall Socket
    mov r11, rax    ; set current function tracker for error tracking
	mov rdi, 2	    ; AF_INET
	mov rsi, 1	    ; SOCK_STREAM
	xor rdx, rdx    ; TCP
	syscall
    call errorCheck
    mov r12, rax    ; Save socket fd
    ret

bindSocket:
    mov rdi, r12                ; sockfd, from createSocket function
    mov rsi, sockaddr           ; Struct sockaddr *
    mov rdx, 16                 ; frame size, 16 is standard
    mov rax, 0x31               ; syscall Bind - 49	bind
    mov r11, rax                ; set current function tracker for error tracking
    syscall
    ret

listen:
    mov rdi, r12                ; sockfd
    xor rsi, rsi                ; number of requests that can stack in que = 0
    mov rax, 0x32               ; syscall Listen
    mov r11, rax                ; set current function tracker for error tracking
    syscall
    call errorCheck


;   ; Error handling & exit functions
;   ; ------------------------------------------------------------
;   ; errorCheck - specific error handling as required
;   ; exitProgram - exit with r11 as exit code

errorCheck:
    cmp rax, -1                 ; standard error
    je exitProgram
    ret

exitProgram:
    mov rdi, r11    ; Specify which function caused error
    mov rax, 0x3c   ; syscall Exit program
    syscall