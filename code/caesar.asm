; ============================================================
; PROJECT   : Caesar Cipher Encryption & Decryption Tool
; COURSE    : Computer Architecture Lab (CSC223L)
; INSTRUCTOR: Faiza Ali
; SUBMITTED : Miss Tayyba Shezad
; STUDENTS  : Akash Akhlaq (Reg# 41593)
;             Shahram Bin Zahoor
; DEPT      : BSCS — Iqra University Islamabad
; SEMESTER  : Spring 2026
; DATE      : 4 June 2026
; ============================================================

.MODEL SMALL
.STACK 200h

; ============================================================
; DATA SEGMENT
; ============================================================
.DATA

    msg_welcome  DB  13,10
                 DB  "  ============================================",13,10
                 DB  "    CAESAR CIPHER ENCRYPTION & DECRYPTION    ",13,10
                 DB  "    Akash Akhlaq  |  Shahram Bin Zahoor      ",13,10
                 DB  "    CSC223L  |  Iqra University Islamabad    ",13,10
                 DB  "  ============================================",13,10,'$'

    msg_menu     DB  13,10
                 DB  "  [1] Encrypt a message",13,10
                 DB  "  [2] Decrypt a message",13,10
                 DB  "  [3] Show last 3 results (History)",13,10
                 DB  "  [4] Exit",13,10
                 DB  13,10
                 DB  "  Your choice: $"

    msg_key      DB  13,10,"  Enter shift key (1-9): $"
    msg_input    DB  13,10,"  Enter message (max 50 chars): $"
    msg_encrypted DB 13,10,"  >> Encrypted : $"
    msg_decrypted DB 13,10,"  >> Decrypted : $"
    msg_history  DB  13,10,"  === Last Results ===",13,10,'$'
    msg_empty    DB  13,10,"  [!] Error: No message entered. Try again.",13,10,'$'
    msg_badkey   DB  13,10,"  [!] Error: Invalid key. Use 1-9 only.",13,10,'$'
    msg_invalid  DB  13,10,"  [!] Invalid choice. Press 1, 2, 3 or 4.",13,10,'$'
    msg_nohist   DB  13,10,"  [!] No history yet. Encrypt or decrypt first.",13,10,'$'
    msg_bye      DB  13,10
                 DB  "  ============================================",13,10
                 DB  "  Thank you!  Akash Akhlaq & Shahram Bin Zahoor",13,10
                 DB  "  ============================================",13,10,'$'
    msg_newline  DB  13,10,'$'
    msg_label_e  DB  "  E> $"
    msg_label_d  DB  "  D> $"

    input_buf    DB  52
                 DB  0
                 DB  52 DUP(0)

    result_buf   DB  52 DUP(0)
                 DB  '$'

    hist_type    DB  3 DUP(0)
    hist_data    DB  3*53 DUP(0)
    hist_count   DB  0

    shift_key    DB  0
    cur_op       DB  0

; ============================================================
; CODE SEGMENT
; ============================================================
.CODE

PRINT MACRO str_label
    LEA  DX, str_label
    MOV  AH, 09h
    INT  21h
ENDM

PRINTDX MACRO
    MOV  AH, 09h
    INT  21h
ENDM

; ============================================================
; MACRO: FLUSH_KBD
;   Drains one extra keystroke (the Enter / CR that follows a
;   single-character read via INT 21h / 01h or 08h).
;   Uses INT 21h / 08h — reads without echo so no stray
;   character appears on screen.
;   *** FIX FOR BUG #1 ***
; ============================================================
FLUSH_KBD MACRO
    MOV  AH, 08h         ; read char, no echo, no display
    INT  21h             ; discards the buffered CR (Enter)
ENDM

; ============================================================
; MAIN PROCEDURE
; ============================================================
MAIN PROC
    MOV  AX, @DATA
    MOV  DS, AX

    PRINT msg_welcome

MENU_LOOP:
    PRINT msg_menu

    ; Read single-character menu choice
    MOV  AH, 01h         ; 01h = read char with echo
    INT  21h             ; AL = character pressed
    PRINT msg_newline

    ; *** BUG #1 FIX ***
    ; Drain the CR that the user typed after the digit.
    ; Without this, the next iteration of MENU_LOOP picks up
    ; the leftover 0Dh and immediately falls to msg_invalid.
    FLUSH_KBD

    CMP  AL, '1'
    JE   DO_ENCRYPT
    CMP  AL, '2'
    JE   DO_DECRYPT
    CMP  AL, '3'
    JE   DO_HISTORY
    CMP  AL, '4'
    JE   DO_EXIT

    PRINT msg_invalid
    JMP  MENU_LOOP

DO_ENCRYPT:
    MOV  [cur_op], 'E'
    CALL VALIDATE_KEY
    JC   MENU_LOOP
    CALL GET_INPUT
    CALL CHECK_EMPTY
    JC   MENU_LOOP
    CALL ENCRYPT
    PRINT msg_encrypted
    PRINT result_buf
    CALL SAVE_HISTORY
    JMP  MENU_LOOP

DO_DECRYPT:
    MOV  [cur_op], 'D'
    CALL VALIDATE_KEY
    JC   MENU_LOOP
    CALL GET_INPUT
    CALL CHECK_EMPTY
    JC   MENU_LOOP
    CALL DECRYPT
    PRINT msg_decrypted
    PRINT result_buf
    CALL SAVE_HISTORY
    JMP  MENU_LOOP

DO_HISTORY:
    CALL SHOW_HISTORY
    JMP  MENU_LOOP

DO_EXIT:
    PRINT msg_bye
    MOV  AH, 4Ch
    MOV  AL, 0
    INT  21h

MAIN ENDP

; ============================================================
; PROCEDURE: VALIDATE_KEY
;   Prompts for shift key digit (1-9).
;   FIX: FLUSH_KBD added after 01h read so the Enter does
;   not contaminate the subsequent GET_INPUT call.
;   (In practice 0Ah buffered input handles it, but flushing
;    here keeps behaviour consistent and safe.)
; ============================================================
VALIDATE_KEY PROC
    PRINT msg_key

    MOV  AH, 01h
    INT  21h             ; AL = digit pressed
    PRINT msg_newline

    FLUSH_KBD            ; drain Enter — keeps buffer clean

    CMP  AL, '1'
    JB   BAD_KEY
    CMP  AL, '9'
    JA   BAD_KEY

    SUB  AL, '0'
    MOV  [shift_key], AL
    CLC
    RET

BAD_KEY:
    PRINT msg_badkey
    STC
    RET
VALIDATE_KEY ENDP

; ============================================================
; PROCEDURE: GET_INPUT
; ============================================================
GET_INPUT PROC
    PRINT msg_input

    MOV  CX, 52
    LEA  DI, [input_buf+2]
CLEAR_LOOP:
    MOV  BYTE PTR [DI], 0
    INC  DI
    LOOP CLEAR_LOOP

    LEA  DX, input_buf
    MOV  AH, 0Ah
    INT  21h

    PRINT msg_newline
    RET
GET_INPUT ENDP

; ============================================================
; PROCEDURE: CHECK_EMPTY
; ============================================================
CHECK_EMPTY PROC
    MOV  AL, [input_buf+1]
    CMP  AL, 0
    JNE  NOT_EMPTY
    PRINT msg_empty
    STC
    RET
NOT_EMPTY:
    CLC
    RET
CHECK_EMPTY ENDP

; ============================================================
; PROCEDURE: ENCRYPT
; ============================================================
ENCRYPT PROC
    MOV  BL, [shift_key]
    XOR  BH, BH

    MOV  CL, [input_buf+1]
    XOR  CH, CH
    JCXZ ENC_DONE

    LEA  SI, [input_buf+2]
    LEA  DI, result_buf

ENC_LOOP:
    MOV  AL, [SI]
    INC  SI

    CMP  AL, 'A'
    JB   ENC_NOT_UPPER
    CMP  AL, 'Z'
    JA   ENC_NOT_UPPER

    SUB  AL, 'A'
    ADD  AL, BL
    XOR  AH, AH
    MOV  DL, 26
    DIV  DL
    MOV  AL, AH
    ADD  AL, 'A'
    JMP  ENC_STORE

ENC_NOT_UPPER:
    CMP  AL, 'a'
    JB   ENC_KEEP
    CMP  AL, 'z'
    JA   ENC_KEEP

    SUB  AL, 'a'
    ADD  AL, BL
    XOR  AH, AH
    MOV  DL, 26
    DIV  DL
    MOV  AL, AH
    ADD  AL, 'a'
    JMP  ENC_STORE

ENC_KEEP:
ENC_STORE:
    MOV  [DI], AL
    INC  DI
    LOOP ENC_LOOP

ENC_DONE:
    MOV  BYTE PTR [DI], '$'
    RET
ENCRYPT ENDP

; ============================================================
; PROCEDURE: DECRYPT
; ============================================================
DECRYPT PROC
    MOV  AL, 26
    SUB  AL, [shift_key]
    XOR  AH, AH
    MOV  DL, 26
    DIV  DL
    MOV  BL, AH

    XOR  BH, BH
    MOV  CL, [input_buf+1]
    XOR  CH, CH
    JCXZ DEC_DONE

    LEA  SI, [input_buf+2]
    LEA  DI, result_buf

DEC_LOOP:
    MOV  AL, [SI]
    INC  SI

    CMP  AL, 'A'
    JB   DEC_NOT_UPPER
    CMP  AL, 'Z'
    JA   DEC_NOT_UPPER

    SUB  AL, 'A'
    ADD  AL, BL
    XOR  AH, AH
    MOV  DL, 26
    DIV  DL
    MOV  AL, AH
    ADD  AL, 'A'
    JMP  DEC_STORE

DEC_NOT_UPPER:
    CMP  AL, 'a'
    JB   DEC_KEEP
    CMP  AL, 'z'
    JA   DEC_KEEP

    SUB  AL, 'a'
    ADD  AL, BL
    XOR  AH, AH
    MOV  DL, 26
    DIV  DL
    MOV  AL, AH
    ADD  AL, 'a'
    JMP  DEC_STORE

DEC_KEEP:
DEC_STORE:
    MOV  [DI], AL
    INC  DI
    LOOP DEC_LOOP

DEC_DONE:
    MOV  BYTE PTR [DI], '$'
    RET
DECRYPT ENDP

; ============================================================
; PROCEDURE: SAVE_HISTORY
;   *** BUG #3 FIX ***
;   Clarified the two exit paths from COPY_HIST:
;     Path A (found '$'): '$' already written by the MOV that
;       triggered JE, so jump straight to RET — do NOT
;       re-write [DI] (was overwriting an already-correct byte
;       with '$', harmless but confusing).
;     Path B (CX exhausted): fall through to COPY_DONE which
;       writes the terminator, then RET.
; ============================================================
SAVE_HISTORY PROC
    MOV  AL, [hist_count]
    CMP  AL, 3
    JB   HIST_HAS_ROOM

    ; Shift type bytes down
    MOV  AL, [hist_type+1]
    MOV  [hist_type+0], AL
    MOV  AL, [hist_type+2]
    MOV  [hist_type+1], AL

    ; Shift data slot 1 -> slot 0
    MOV  CX, 53
    LEA  SI, [hist_data+53]
    LEA  DI, hist_data
SHIFT0:
    MOV  AL, [SI]
    MOV  [DI], AL
    INC  SI
    INC  DI
    LOOP SHIFT0

    ; Shift data slot 2 -> slot 1
    MOV  CX, 53
    LEA  SI, [hist_data+106]
    LEA  DI, [hist_data+53]
SHIFT1:
    MOV  AL, [SI]
    MOV  [DI], AL
    INC  SI
    INC  DI
    LOOP SHIFT1

    MOV  BL, 2
    JMP  WRITE_SLOT

HIST_HAS_ROOM:
    MOV  BL, AL
    INC  AL
    MOV  [hist_count], AL

WRITE_SLOT:
    MOV  AL, [cur_op]
    XOR  BH, BH
    MOV  [hist_type+BX], AL

    MOV  AX, BX
    MOV  DX, 53
    MUL  DX
    LEA  DI, hist_data
    ADD  DI, AX

    LEA  SI, result_buf
    MOV  CX, 53

COPY_HIST:
    MOV  AL, [SI]
    MOV  [DI], AL
    CMP  AL, '$'         ; reached end-of-string?
    JE   COPY_DONE_FOUND ; -- Path A: '$' already written, just return
    INC  SI
    INC  DI
    LOOP COPY_HIST
    ; -- Path B: CX exhausted (string was exactly 52 chars, no '$' yet)
    ;    Fall through to write terminator.

COPY_DONE:
    MOV  BYTE PTR [DI], '$'  ; ensure slot is terminated
    RET

COPY_DONE_FOUND:
    ; '$' already at [DI] from the MOV AL,[SI] / MOV [DI],AL above.
    ; No need to write again — just return.
    RET

SAVE_HISTORY ENDP

; ============================================================
; PROCEDURE: SHOW_HISTORY
;   *** BUG #2 FIX ***
;   Moved PUSH CX / PUSH BX to the TOP of HIST_LOOP, before
;   any PRINT macro call.  INT 21h is free to clobber BX/CX;
;   saving them after a PRINT call is too late.
; ============================================================
SHOW_HISTORY PROC
    MOV  AL, [hist_count]
    CMP  AL, 0
    JNE  HAS_HISTORY
    PRINT msg_nohist
    RET

HAS_HISTORY:
    PRINT msg_history
    MOV  CL, [hist_count]
    XOR  CH, CH
    XOR  BL, BL

HIST_LOOP:
    ; *** FIX: save registers BEFORE any INT 21h / PRINT call ***
    PUSH CX
    PUSH BX

    ; Print type label
    MOV  AL, [hist_type+BX]
    CMP  AL, 'E'
    JE   PRINT_E_LABEL
    PRINT msg_label_d
    JMP  PRINT_DATA
PRINT_E_LABEL:
    PRINT msg_label_e

PRINT_DATA:
    ; Compute address of this slot's data string
    MOV  AX, BX
    MOV  DX, 53
    MUL  DX
    LEA  DI, hist_data
    ADD  DI, AX
    MOV  DX, DI
    PRINTDX
    PRINT msg_newline

    POP  BX
    POP  CX
    INC  BL
    LOOP HIST_LOOP
    RET
SHOW_HISTORY ENDP

END MAIN