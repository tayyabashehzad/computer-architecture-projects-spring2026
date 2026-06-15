.model small
.stack 100h

.data
    menu  db 10, 13, '1.Vote A  2.Vote B  3.Results  4.Exit: $'
    msg   db 10, 13, 'Vote Saved!$'
    err   db 10, 13, 'Invalid Input!$'
    
    resA  db 10, 13, 'Total Votes for A: $'
    resB  db 10, 13, 'Total Votes for B: $'  
    
    vA    db 0
    vB    db 0

.code
main proc
    mov ax, @data
    mov ds, ax

menu_loop:
    lea dx, menu
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    je vote_A
    cmp al, '2'
    je vote_B
    cmp al, '3'
    je show
    cmp al, '4'
    je exit

    lea dx, err
    mov ah, 09h
    int 21h
    jmp menu_loop

vote_A:
    inc vA
    jmp saved

vote_B:
    inc vB
    jmp saved  

saved:
    lea dx, msg
    mov ah, 09h
    int 21h
    jmp menu_loop

show:
    lea dx, resA
    mov ah, 09h
    int 21h
    
    mov dl, vA
    add dl, '0'
    mov ah, 02h
    int 21h

    lea dx, resB
    mov ah, 09h
    int 21h
    
    mov dl, vB
    add dl, '0'
    mov ah, 02h
    int 21h
    
    jmp menu_loop

exit:
    mov ah, 4ch
    int 21h

main endp
end main
