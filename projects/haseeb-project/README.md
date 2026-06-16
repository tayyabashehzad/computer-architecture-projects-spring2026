\# Parking Management System



\*\*Student Name:\*\* Rana Haseeb Haseeb  

\*\*Course:\*\* Computer Architecture  

\*\*Project Focus:\*\* Native x64 Assembly Infrastructure Configuration  



\## Project Description

A high-performance, interactive, console-driven Parking Management System written in pure x64 Microsoft Macro Assembler (MASM). The system coordinates space allocation, tracks incoming vehicle categories, and calculates real-time fiscal balances directly within hardware processing environments.



\## Tools Used

\- Microsoft Macro Assembler (MASM)

\- Microsoft Visual Studio 2022 Integrated Workspace

\- Windows Console / Universal C-Runtime Linker Dependencies



\## Project Overview

\- \*\*What does it do?\*\* It tracks a maximum capacity bounds allocation of up to 8 vehicles, sorting them into three distinct financial categories (Rickshaws @ 200, Cars @ 300, Buses @ 400). It supports an interactive menu flag processing structure, data segment logging, and an instant system storage flush routine.

\- \*\*How does it work at hardware level?\*\* The system relies entirely on native 64-bit general-purpose CPU registers (rax, rcx, rdx). It utilizes conditional branch prediction logic (CMP and JE), maintains hardware stack alignment protocols by booking a 32-byte shadow space frame via memory pointers (sub rsp, 40), and interfaces directly with C-Runtime functions using explicit linker calls.



\## How to Run

1\. Open Visual Studio 2022 and establish an empty C++ Windows Console Project.

2\. Toggle the build target from x86 to x64.

3\. Enable MASM configurations by right-clicking the project -> Build Customizations -> checking masm.

4\. Add the main.asm file into the Source Files directory.

5\. Open file properties, change Item Type to Microsoft Macro Assembler.

6\. Access project Properties -> Linker -> Advanced -> Change Entry Point to main.

7\. Access Linker -> Input -> Add legacy\_stdio\_definitions.lib;ucrt.lib;msvcrt.lib; into Additional Dependencies.

8\. Press F5 to build and run.

