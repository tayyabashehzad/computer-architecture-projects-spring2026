; ============================================================
; TITLE   : Ding Dong - Number Guessing Game
; COURSE  : CSC223L - Computer Architecture Lab
; SEMESTER: Spring 2026
; TOOL    : MASM / Irvine32 (x86 Assembly, Flat Model)
;
; DESCRIPTION:
;   A menu-driven number guessing game that demonstrates:
;     - Menu-driven interface (main menu + difficulty menu)
;     - Arrays (guessHistory stores each guess per round)
;     - Loops and branching (game loop, menu loop, validation)
;     - Procedures (ShowMenu, ShowDiffMenu, PlayGame,
;                   ShowHistory, ShowScore, ValidateInput)
;     - Input / output handling (ReadInt, WriteString, etc.)
;     - Error handling (out-of-range and non-positive input)
;     - Proper commenting throughout
; ============================================================

.686
.MODEL flat, stdcall
.STACK 4096

INCLUDE Irvine32.inc

; ============================================================
; CONSTANTS
; ============================================================
MAX_GUESSES  EQU 10          ; max guesses stored in history array
RANGE_EASY   EQU 10         ; Easy   : 1 – 10
RANGE_MED    EQU 20         ; Medium : 1 – 20
RANGE_HARD   EQU 50         ; Hard   : 1 – 50

; ============================================================
; DATA SEGMENT
; ============================================================
.DATA

    ; --- Game state variables ---
    targetNum    DWORD ?          ; the secret number
    userGuess    DWORD ?          ; current guess from user
    numAttempts  DWORD 0          ; attempt counter for current round
    totalScore   DWORD 0          ; cumulative score across rounds
    roundsPlayed DWORD 0          ; how many rounds played
    difficulty   DWORD RANGE_MED  ; active range (default medium)
    maxRange     DWORD RANGE_MED  ; displayed upper bound

    ; --- Array to record guess history (up to MAX_GUESSES per round) ---
    guessHistory DWORD MAX_GUESSES DUP(0)

    ; --- Menu strings ---
    msgLine      BYTE "============================================", 0Dh, 0Ah, 0
    msgTitle     BYTE "   DING DONG - NUMBER GUESSING GAME", 0Dh, 0Ah, 0
    msgMenu1     BYTE " [1] New Game", 0Dh, 0Ah, 0
    msgMenu2     BYTE " [2] View Score", 0Dh, 0Ah, 0
    msgMenu3     BYTE " [3] How to Play", 0Dh, 0Ah, 0
    msgMenu4     BYTE " [4] Exit", 0Dh, 0Ah, 0
    msgMenuPick  BYTE "Enter your choice (1-4): ", 0

    ; --- Difficulty menu strings ---
    msgDiffTitle BYTE "   SELECT DIFFICULTY", 0Dh, 0Ah, 0
    msgDiff1     BYTE " [1] Easy   (1 - 10)", 0Dh, 0Ah, 0
    msgDiff2     BYTE " [2] Medium (1 - 20)", 0Dh, 0Ah, 0
    msgDiff3     BYTE " [3] Hard   (1 - 50)", 0Dh, 0Ah, 0
    msgDiffPick  BYTE "Enter difficulty (1-3): ", 0

    ; --- Gameplay strings ---
    msgWelcome   BYTE "Game started! Good luck!", 0Dh, 0Ah, 0
    msgPrompt    BYTE "Guess a number between 1 and ", 0
    msgPrompt2   BYTE ": ", 0
    msgTooLow    BYTE "  >> Too low!  Try higher.", 0Dh, 0Ah, 0
    msgTooHigh   BYTE "  >> Too high! Try lower.", 0Dh, 0Ah, 0
    msgCorrect   BYTE "*** Correct! You guessed it! ***", 0Dh, 0Ah, 0
    msgAttempts  BYTE "Total attempts this round: ", 0
    msgCRLF      BYTE 0Dh, 0Ah, 0

    ; --- History / score strings ---
    msgHistory   BYTE "--- Your Guesses This Round ---", 0Dh, 0Ah, 0
    msgGuess     BYTE "  Guess #", 0
    msgGuessVal  BYTE " : ", 0
    msgScore     BYTE "=== SCORE BOARD ===", 0Dh, 0Ah, 0
    msgRounds    BYTE "  Rounds played : ", 0
    msgTotalSc   BYTE "  Total score   : ", 0
    msgScoreNote BYTE "  (Score = 100 - attempts*5, min 5 per round)", 0Dh, 0Ah, 0

    ; --- Error / info strings ---
    msgErrRange  BYTE "  [!] Input out of range. Try again.", 0Dh, 0Ah, 0
    msgErrMenu   BYTE "  [!] Invalid choice. Enter 1-4.", 0Dh, 0Ah, 0
    msgHowTo     BYTE "HOW TO PLAY:", 0Dh, 0Ah,
                      "  The computer picks a secret number.", 0Dh, 0Ah,
                      "  You guess until you find it.", 0Dh, 0Ah,
                      "  Hints tell you if you are too high or too low.", 0Dh, 0Ah,
                      "  Fewer guesses = higher score!", 0Dh, 0Ah, 0
    msgBye       BYTE "Thank you for playing. Goodbye!", 0Dh, 0Ah, 0
    msgPressKey  BYTE "Press any key to return to menu...", 0

; ============================================================
; CODE SEGMENT
; ============================================================
.CODE

; ------------------------------------------------------------
; PROCEDURE: main
; PURPOSE  : Entry point. Runs the main menu loop.
; REGISTERS: eax (menu choice), no preserved (main proc)
; ------------------------------------------------------------
main PROC
    call Clrscr
    call Randomize           ; Seed random number generator once

mainLoop:
    call ShowMenu            ; Display main menu
    call ReadInt             ; Read menu choice into EAX
    call Crlf

    cmp eax, 1
    je  doNewGame
    cmp eax, 2
    je  doScore
    cmp eax, 3
    je  doHowTo
    cmp eax, 4
    je  doExit

    ; Invalid choice
    mov edx, OFFSET msgErrMenu
    call WriteString
    jmp mainLoop

doNewGame:
    call ShowDiffMenu        ; Let user pick difficulty
    call PlayGame            ; Run one round
    jmp mainLoop

doScore:
    call ShowScore
    jmp mainLoop

doHowTo:
    call Clrscr
    mov edx, OFFSET msgHowTo
    call WriteString
    call Crlf
    mov edx, OFFSET msgPressKey
    call WriteString
    call ReadChar
    call Crlf
    jmp mainLoop

doExit:
    mov edx, OFFSET msgBye
    call WriteString
    call WaitMsg
    exit

main ENDP

; ------------------------------------------------------------
; PROCEDURE: ShowMenu
; PURPOSE  : Clears screen and displays the main menu.
; REGISTERS: edx (WriteString), all others unchanged
; ------------------------------------------------------------
ShowMenu PROC
    call Clrscr
    mov edx, OFFSET msgLine
    call WriteString
    mov edx, OFFSET msgTitle
    call WriteString
    mov edx, OFFSET msgLine
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenu1
    call WriteString
    mov edx, OFFSET msgMenu2
    call WriteString
    mov edx, OFFSET msgMenu3
    call WriteString
    mov edx, OFFSET msgMenu4
    call WriteString
    call Crlf
    mov edx, OFFSET msgMenuPick
    call WriteString
    ret
ShowMenu ENDP

; ------------------------------------------------------------
; PROCEDURE: ShowDiffMenu
; PURPOSE  : Displays difficulty selection and sets difficulty
;            and maxRange variables accordingly.
; REGISTERS: eax (ReadInt / choice), edx (WriteString)
; ------------------------------------------------------------
ShowDiffMenu PROC
    call Clrscr
    mov edx, OFFSET msgLine
    call WriteString
    mov edx, OFFSET msgDiffTitle
    call WriteString
    mov edx, OFFSET msgLine
    call WriteString
    call Crlf
    mov edx, OFFSET msgDiff1
    call WriteString
    mov edx, OFFSET msgDiff2
    call WriteString
    mov edx, OFFSET msgDiff3
    call WriteString
    call Crlf
    mov edx, OFFSET msgDiffPick
    call WriteString
    call ReadInt             ; EAX = 1, 2, or 3

    cmp eax, 1
    je  setEasy
    cmp eax, 2
    je  setMed
    cmp eax, 3
    je  setHard
    ; default to medium on invalid input
    jmp setMed

setEasy:
    mov difficulty, RANGE_EASY
    mov maxRange,   RANGE_EASY
    jmp diffDone
setMed:
    mov difficulty, RANGE_MED
    mov maxRange,   RANGE_MED
    jmp diffDone
setHard:
    mov difficulty, RANGE_HARD
    mov maxRange,   RANGE_HARD
diffDone:
    call Crlf
    ret
ShowDiffMenu ENDP

; ------------------------------------------------------------
; PROCEDURE: PlayGame
; PURPOSE  : Runs one full round of the guessing game.
;            - Generates a random target in [1, difficulty]
;            - Loops until correct guess
;            - Stores each guess in guessHistory array
;            - Updates totalScore and roundsPlayed
; REGISTERS: eax, ebx, ecx, edx, esi (loop index)
; ------------------------------------------------------------
PlayGame PROC
    ; --- Reset round state ---
    mov numAttempts, 0

    ; Clear the guessHistory array (MAX_GUESSES DWORDs)
    mov ecx, MAX_GUESSES
    lea esi, guessHistory
clearLoop:
    mov DWORD PTR [esi], 0
    add esi, 4
    loop clearLoop

    ; --- Generate secret number [1, difficulty] ---
    mov eax, difficulty
    call RandomRange         ; EAX = random in [0, difficulty-1]
    inc eax                  ; shift to [1, difficulty]
    mov targetNum, eax

    ; --- Welcome message ---
    call Clrscr
    mov edx, OFFSET msgWelcome
    call WriteString
    call Crlf

guessLoop:
    ; --- Prompt user ---
    mov edx, OFFSET msgPrompt
    call WriteString
    mov eax, maxRange
    call WriteDec            ; print upper bound
    mov edx, OFFSET msgPrompt2
    call WriteString

    ; --- Validate input (must be in [1, maxRange]) ---
    call ValidateInput       ; returns valid value in EAX
    mov userGuess, eax

    ; --- Store guess in history array (cap at MAX_GUESSES slots) ---
    mov ecx, numAttempts
    cmp ecx, MAX_GUESSES
    jge skipStore            ; array full, stop storing
    lea esi, guessHistory
    mov ebx, ecx
    imul ebx, 4              ; byte offset = index * 4
    add esi, ebx
    mov eax, userGuess
    mov [esi], eax           ; guessHistory[numAttempts] = userGuess
skipStore:

    ; --- Increment attempt counter ---
    inc numAttempts

    ; --- Compare guess to target ---
    mov eax, userGuess
    mov ebx, targetNum
    cmp eax, ebx
    jl  tooLow
    jg  tooHigh

    ; --- Correct! ---
    call Crlf
    mov edx, OFFSET msgCorrect
    call WriteString

    ; Print attempt count
    mov edx, OFFSET msgAttempts
    call WriteString
    mov eax, numAttempts
    call WriteDec
    call Crlf
    call Crlf

    ; Show guess history
    call ShowHistory

    ; --- Calculate and add score: max(100 - attempts*5, 5) ---
    mov eax, numAttempts
    imul eax, 5             ; attempts * 5
    mov ebx, 100
    sub ebx, eax            ; 100 - attempts*5
    cmp ebx, 5
    jge addScore
    mov ebx, 5              ; minimum score is 5
addScore:
    add totalScore, ebx
    inc roundsPlayed

    ; Pause before returning to menu
    call Crlf
    mov edx, OFFSET msgPressKey
    call WriteString
    call ReadChar
    call Crlf
    ret

tooLow:
    mov edx, OFFSET msgTooLow
    call WriteString
    jmp guessLoop

tooHigh:
    mov edx, OFFSET msgTooHigh
    call WriteString
    jmp guessLoop

PlayGame ENDP

; ------------------------------------------------------------
; PROCEDURE: ValidateInput
; PURPOSE  : Reads an integer and re-prompts if it is outside
;            [1, maxRange]. Returns valid value in EAX.
; REGISTERS: eax (return value), ebx (maxRange), edx
; ------------------------------------------------------------
ValidateInput PROC
validateAgain:
    call ReadInt             ; EAX = signed integer from user
    ; Check lower bound
    cmp eax, 1
    jl  badInput
    ; Check upper bound
    mov ebx, maxRange
    cmp eax, ebx
    jg  badInput
    ret                      ; EAX holds valid input

badInput:
    mov edx, OFFSET msgErrRange
    call WriteString
    mov edx, OFFSET msgPrompt
    call WriteString
    mov eax, maxRange
    call WriteDec
    mov edx, OFFSET msgPrompt2
    call WriteString
    jmp validateAgain
ValidateInput ENDP

; ------------------------------------------------------------
; PROCEDURE: ShowHistory
; PURPOSE  : Prints the guessHistory array for the round.
; REGISTERS: ecx (loop counter), esi (array pointer),
;            eax (value), edx (strings)
; ------------------------------------------------------------
ShowHistory PROC
    mov edx, OFFSET msgHistory
    call WriteString

    mov ecx, 0              ; index counter
    lea esi, guessHistory

histLoop:
    ; stop when index == numAttempts or index == MAX_GUESSES
    cmp ecx, numAttempts
    jge histDone
    cmp ecx, MAX_GUESSES
    jge histDone

    ; Print "  Guess #N : value"
    mov edx, OFFSET msgGuess
    call WriteString
    mov eax, ecx
    inc eax                 ; display 1-based index
    call WriteDec
    mov edx, OFFSET msgGuessVal
    call WriteString
    mov eax, [esi]          ; load guessHistory[ecx]
    call WriteDec
    call Crlf

    add esi, 4              ; advance pointer
    inc ecx
    jmp histLoop

histDone:
    call Crlf
    ret
ShowHistory ENDP

; ------------------------------------------------------------
; PROCEDURE: ShowScore
; PURPOSE  : Displays rounds played and total accumulated score.
; REGISTERS: eax, edx
; ------------------------------------------------------------
ShowScore PROC
    call Clrscr
    mov edx, OFFSET msgLine
    call WriteString
    mov edx, OFFSET msgScore
    call WriteString
    mov edx, OFFSET msgLine
    call WriteString
    call Crlf

    mov edx, OFFSET msgRounds
    call WriteString
    mov eax, roundsPlayed
    call WriteDec
    call Crlf

    mov edx, OFFSET msgTotalSc
    call WriteString
    mov eax, totalScore
    call WriteDec
    call Crlf

    call Crlf
    mov edx, OFFSET msgScoreNote
    call WriteString
    call Crlf

    mov edx, OFFSET msgPressKey
    call WriteString
    call ReadChar
    call Crlf
    ret
ShowScore ENDP

END main