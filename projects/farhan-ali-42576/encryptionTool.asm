TITLE XOR Encryption Tool

.686
.MODEL FLAT, STDCALL
.STACK 4096
INCLUDE Irvine32.inc

.DATA
menu BYTE 0Dh,0Ah,
     "1. Enter Text",0Dh,0Ah,
     "2. Encrypt",0Dh,0Ah,
     "3. Decrypt",0Dh,0Ah,
     "4. Exit",0Dh,0Ah,
     "Choice: ",0

msgText BYTE 0Dh,0Ah,"Text: ",0
msgKey  BYTE 0Dh,0Ah,"Key: ",0
msgRes  BYTE 0Dh,0Ah,"Result: ",0

userInput  BYTE 100 DUP(0)
len     DWORD 0
key     BYTE 0

.CODE
main PROC

menuLoop:
    mov edx, OFFSET menu
    call WriteString
    call ReadInt

    cmp eax, 1
    je inputText
    cmp eax, 2
    je process
    cmp eax, 3
    je process
    cmp eax, 4
    je quit
    jmp menuLoop

inputText:
    mov edx, OFFSET msgText
    call WriteString
    mov edx, OFFSET userInput
    mov ecx, 100
    call ReadString
    mov len, eax
    jmp menuLoop

process:
    mov edx, OFFSET msgKey
    call WriteString
    call ReadInt
    mov key, al

    mov esi, OFFSET userInput
    mov ecx, len
    mov al, key

xorLoop:
    xor BYTE PTR [esi], al
    inc esi
    loop xorLoop

    mov edx, OFFSET msgRes
    call WriteString
    mov edx, OFFSET userInput
    call WriteString
    call Crlf
    jmp menuLoop

quit:
    exit

main ENDP
END main
