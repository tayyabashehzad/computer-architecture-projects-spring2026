# Assembly Voting System

**Student Name:** Faraz Ahmed
**Roll Number:** 41346
**Section:** BSCS

## Project Description
A console-based voting system built in 16-bit x86 Assembly language. It allows users to cast votes for two distinct candidates (A and B), handles invalid inputs, and displays the real-time vote tally.

## Tools Used
- x86/8086 Assembly
- DOSBox / EMU8086 

## Project Overview
- **What does it implement?** A looping terminal interface where users can press `1` to vote for A, `2` for B, `3` to view results, and `4` to exit.
- **How does it work?** It utilizes DOS interrupts (`int 21h`) for character I/O and string printing. Votes are stored in memory variables (`vA`, `vB`) and incremented upon valid keypresses. The results routine translates the integer counts to ASCII for display.

## How to Run
1. Open DOSBox or EMU8086.
2. Mount the directory containing `mycode.asm`.
3. Assemble the code using MASM/TASM.
4. Execute the generated binary.
