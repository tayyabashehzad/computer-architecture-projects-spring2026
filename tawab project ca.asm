.MODEL SMALL
.STACK 100H

.DATA

MSG1 DB 10,13,'==== EXPRESSION EXECUTION SIMULATOR ====$'
MSG2 DB 10,13,'1. A + B$'
MSG3 DB 10,13,'2. A - B$'
MSG4 DB 10,13,'3. A * B$'
MSG5 DB 10,13,'4. A + B * C$'
MSG6 DB 10,13,'Choose Expression: $'

MSGA DB 10,13,'Enter A: $'
MSGB DB 10,13,'Enter B: $'
MSGC DB 10,13,'Enter C: $'

RESULTMSG DB 10,13,'Final Result: $'
STEP1 DB 10,13,'Executing MUL...$'
STEP2 DB 10,13,'Executing ADD...$'

A DW ?
B DW ?
C DW ?

CHOICE DB ?

RESULT DW ?

.CODE

MAIN PROC

MOV AX,@DATA
MOV DS,AX

; =========================
; TITLE
; =========================

LEA DX,MSG1
MOV AH,09H
INT 21H

; =========================
; MENU
; =========================

LEA DX,MSG2
MOV AH,09H
INT 21H

LEA DX,MSG3
MOV AH,09H
INT 21H

LEA DX,MSG4
MOV AH,09H
INT 21H

LEA DX,MSG5
MOV AH,09H
INT 21H

; =========================
; CHOICE INPUT
; =========================

LEA DX,MSG6
MOV AH,09H
INT 21H

MOV AH,01H
INT 21H

SUB AL,30H
MOV CHOICE,AL

; =========================
; INPUT A
; =========================

LEA DX,MSGA
MOV AH,09H
INT 21H

CALL INPUT_NUMBER
MOV A,AX

; =========================
; INPUT B
; =========================

LEA DX,MSGB
MOV AH,09H
INT 21H

CALL INPUT_NUMBER
MOV B,AX

; =========================
; INPUT C (ONLY OPTION 4)
; =========================

CMP CHOICE,4
JNE SKIP_C

LEA DX,MSGC
MOV AH,09H
INT 21H

CALL INPUT_NUMBER
MOV C,AX

SKIP_C:

; =========================
; OPTION 1 : A + B
; =========================

CMP CHOICE,1
JNE CHECK2

MOV AX,A
ADD AX,B

MOV RESULT,AX
JMP DISPLAY

; =========================
; OPTION 2 : A - B
; =========================

CHECK2:

CMP CHOICE,2
JNE CHECK3

MOV AX,A
SUB AX,B

MOV RESULT,AX
JMP DISPLAY

; =========================
; OPTION 3 : A * B
; =========================

CHECK3:

CMP CHOICE,3
JNE CHECK4

MOV AX,A
MUL B

MOV RESULT,AX
JMP DISPLAY

; =========================
; OPTION 4 : A + B * C
; =========================

CHECK4:

CMP CHOICE,4
JNE DISPLAY

LEA DX,STEP1
MOV AH,09H
INT 21H

MOV AX,B
MUL C

MOV BX,AX

LEA DX,STEP2
MOV AH,09H
INT 21H

MOV AX,A
ADD AX,BX

MOV RESULT,AX

; =========================
; DISPLAY RESULT
; =========================

DISPLAY:

LEA DX,RESULTMSG
MOV AH,09H
INT 21H

MOV AX,RESULT

CMP AX,0
JNE PRINT_NUMBER

MOV DL,'0'
MOV AH,02H
INT 21H

JMP EXIT

PRINT_NUMBER:

MOV BX,10
MOV CX,0

DIVIDE_LOOP:

MOV DX,0
DIV BX

PUSH DX

INC CX

CMP AX,0
JNE DIVIDE_LOOP

PRINT_LOOP:

POP DX

ADD DL,30H

MOV AH,02H
INT 21H

LOOP PRINT_LOOP

; =========================
; EXIT PROGRAM
; =========================

EXIT:

MOV AH,4CH
INT 21H

MAIN ENDP

; =========================
; INPUT NUMBER PROCEDURE
; =========================

INPUT_NUMBER PROC

MOV BX,0

INPUT_LOOP:

MOV AH,01H
INT 21H

CMP AL,13
JE INPUT_DONE

SUB AL,30H

MOV AH,0
MOV CX,AX

MOV AX,BX

MOV DX,10
MUL DX

ADD AX,CX

MOV BX,AX

JMP INPUT_LOOP

INPUT_DONE:

MOV AX,BX

RET

INPUT_NUMBER ENDP

END MAIN