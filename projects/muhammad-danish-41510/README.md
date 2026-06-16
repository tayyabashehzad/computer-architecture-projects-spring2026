# Ding Dong - Number Guessing Game [cite: 372, 643]

[cite_start]**Student Name:** Muhammad Danish [cite: 375, 463]  
[cite_start]**Roll Number:** 41510 [cite: 375]  
**Section:** BSSE-4A *(Note: Update if your section differs from the template example)*

### [cite_start]Group Members (Group Artist)[cite: 374, 376]:
* [cite_start]**Muhammad Danish** (Roll Number: 41510) - Project Lead & Code Architecture [cite: 375, 463]
* [cite_start]**Mohsin Ali** (Roll Number: 41420) - Procedures & Error Handling and Idea [cite: 375, 463]
* [cite_start]**Abdullah Kayani** (Roll Number: 41665) - Testing & Debugging [cite: 375, 463]
* [cite_start]**Jam Awais** (Roll Number: 41567) - Documentation & Report [cite: 375]

## Project Description
[cite_start]The Ding Dong Number Guessing Game is a fully interactive, menu-driven console application developed entirely in x86 Assembly Language using the MASM assembler and the Irvine32 library[cite: 381, 644]. [cite_start]The application challenges a user to guess a randomly generated secret number within a range determined by a chosen difficulty level[cite: 383, 645]. [cite_start]The system provides directional feedback on each guess ("Too Low" or "Too High"), records all guesses in a DWORD array, validates every input, computes a performance-based score, and maintains a cumulative score across multiple rounds[cite: 384, 646].

## Tools Used
* [cite_start]**Language:** x86 Assembly (32-bit, Flat Model) [cite: 432, 644]
* [cite_start]**Assembler:** MASM (Microsoft Macro Assembler) [cite: 432, 644]
* [cite_start]**Library:** Irvine32 Library [cite: 432, 644]
* [cite_start]**IDE:** Microsoft Visual Studio with MASM build customization [cite: 432]
* [cite_start]**OS:** Windows 10/11 (32-bit compatible mode) [cite: 432]

## Project Overview
* **What does it implement?**
  * [cite_start]**Menu-Driven Interface:** Features a 4-option main menu (New Game, View Score, How to Play, Exit) handled cleanly via comparative branching (`CMP`/`JE`)[cite: 396, 676].
  * [cite_start]**Dynamic Difficulty Levels:** Dynamically modifies the target generation limits based on Easy (1-10), Medium (1-20), and Hard (1-50) variables[cite: 396, 412].
  * [cite_start]**Array Storage:** Implements a `DWORD` array (`guessHistory`) capped at 10 slots to store each guess input per individual round[cite: 398, 650].
  * [cite_start]**Input Validation:** A robust `ValidateInput` procedure prevents crash errors by rejecting values outside the active `[1, maxRange]` boundaries and safely re-prompts the player[cite: 408, 714].
  * [cite_start]**Scoring System:** Calculates performance using the equation `Score = max(100 - attempts * 5, 5)`, tracking round totals and historical attempts[cite: 410, 531].

* **How does it work?**
  1. [cite_start]**Randomize:** The application seeds the internal random number generator on execution using Irvine32's `Randomize` procedure[cite: 417, 673].
  2. [cite_start]**Navigation Loop:** `main` runs an iterative cycle, executing `ShowMenu` and parsing selection inputs using conditional comparisons[cite: 435, 676].
  3. [cite_start]**Difficulty Update:** Selecting a new game triggers `ShowDiffMenu`, updating the `maxRange` constraints[cite: 683, 687].
  4. [cite_start]**Target Setup:** `PlayGame` clears the history array and gets a random value inside `[0, difficulty-1]`, indexing it up by 1 with `INC EAX`[cite: 692, 694].
  5. [cite_start]**Guess Tracking:** The system loops through `guessLoop`, runs input checks, and manually writes variables to `guessHistory` by multiplying the attempt index by 4 bytes to find the proper byte pointer offset[cite: 699, 703].
  6. [cite_start]**Round Summary:** Guesses are checked against the target using conditional jumps (`JL` / `JG`) to supply clues until solved[cite: 400, 713]. [cite_start]It then prints the complete array logs, adds scores, and moves back to the home view[cite: 512, 708].

## How to Run
1. [cite_start]Ensure **Microsoft Visual Studio** has MASM build customizations configured and active[cite: 432].
2. [cite_start]Configure the **Irvine32 library** paths inside the Include and Linker dependencies directories under your project property pages[cite: 432, 644].
3. [cite_start]Add `CA_lab_project.asm` into your source folder structure[cite: 415].
4. [cite_start]Compile and Run the application (`Ctrl + F5`) on a standard Windows desktop environment[cite: 432, 449].