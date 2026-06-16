# SecureVault - Password-Based Digital Security Vault

**Student Name:** Abdul Hannan
**Roll Number:** 47524

**Student Name:** Mohtasim Iftikhar
**Roll Number:** 41262

**Course:** Computer Architecture
**Instructor:** Ma’am Tayyaba Shahzad

---

## Project Description

SecureVault is a password-protected digital security vault developed using **MIPS Assembly Language** and simulated in **MARS 4.5**. The project demonstrates fundamental Computer Architecture concepts including processor instruction execution, memory management, branching, looping, procedures, and system calls.

The system allows authenticated users to securely manage files stored in memory through a menu-driven interface.

---

## Tools Used

* MIPS Assembly Language
* MARS 4.5 Simulator
* Computer Architecture Concepts
* Memory-Based File Management

---

## Project Overview

### Features

* Password Authentication System
* Three Failed Login Attempt Lock Mechanism
* Secure Access Control
* Create File
* Read File
* Delete File
* Overwrite Existing File
* List All Stored Files
* Memory-Based Virtual File System

### How It Works

1. User enters a password.
2. System verifies the password character-by-character.
3. If authentication succeeds, access to the SecureVault menu is granted.
4. The user can perform file management operations:

   * Create new files
   * Read existing files
   * Delete files
   * Update file contents
   * View stored files
5. If the password is entered incorrectly three times, the system locks and terminates.

---

## Computer Architecture Concepts Implemented

* Register Operations
* Memory Addressing
* Branching Instructions
* Loops and Iteration
* Procedures and Function Calls
* System Calls (Interrupt-Based I/O)
* Fetch–Decode–Execute Cycle
* Access Control Mechanisms

---

## Memory Structure

Each file contains:

* File Name (20 Bytes)
* File Content (100 Bytes)
* Status Flag (4 Bytes)

Maximum Files Supported: **5**

Total Simulated Storage: **620 Bytes**

---

## How to Run

### Step 1

Open **MARS 4.5 Simulator**.

### Step 2

Load the source file:

```text
SecureVault.asm
```

### Step 3

Assemble the program using:

```text
Run → Assemble
```

### Step 4

Execute the program using:

```text
Run → Go
```

### Step 5

Login using the default password:

```text
1234
```

### Step 6

Use the menu options to create, read, delete, overwrite, or list files.

---

## Security Features

* Password Verification
* Failed Login Monitoring
* System Lock After Three Incorrect Attempts
* Restricted Access to Vault Operations
* Protected Memory-Based File Storage

---

## Future Enhancements

* Encrypted File Storage
* Dynamic Memory Allocation
* Persistent Disk Storage
* Multiple User Accounts
* Advanced Authentication Methods
* Audit Logging System

---

## Conclusion

SecureVault successfully demonstrates how security mechanisms can be implemented at a low level using MIPS Assembly Language. The project provides practical experience with Computer Architecture concepts while implementing a functional password-protected file management system.
