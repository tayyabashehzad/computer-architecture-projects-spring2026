.data

# ================= SECURITY =================
password: .asciiz "1234"
input:    .space 20

attempts: .word 0
locked:   .word 0

msg_login: .asciiz "\nENTER PASSWORD: "
msg_wrong: .asciiz "\nWRONG PASSWORD!"
msg_ok: .asciiz "\nACCESS GRANTED!"
msg_lock: .asciiz "\nSYSTEM LOCKED (3 FAILS)!"

# ================= MENU =================
menu: .asciiz "\n\n===== SECURE FILE VAULT ====="
menu_opt: .asciiz "\n1.CREATE\n2.READ\n3.DELETE\n4.LIST\n5.OVERWRITE\n6.EXIT\nChoice: "

# ================= MESSAGES =================
msg_fname: .asciiz "\nEnter file name: "
msg_fcontent: .asciiz "\nEnter file content: "
msg_notfound: .asciiz "\nFILE NOT FOUND!"
msg_created: .asciiz "\nFILE CREATED!"
msg_deleted: .asciiz "\nFILE DELETED!"
msg_updated: .asciiz "\nFILE UPDATED!"
msg_show: .asciiz "\nFILE CONTENT:\n"
msg_list: .asciiz "\n--- FILE LIST ---\n"

# ================= FILE SYSTEM =================
file1_name: .space 20
file1_data: .space 100
file1_flag: .word 0

file2_name: .space 20
file2_data: .space 100
file2_flag: .word 0

file3_name: .space 20
file3_data: .space 100
file3_flag: .word 0

file4_name: .space 20
file4_data: .space 100
file4_flag: .word 0

file5_name: .space 20
file5_data: .space 100
file5_flag: .word 0

fname: .space 20
fcontent: .space 100

.text
.globl main

# ==================================================
# MAIN
# ==================================================
main:

# ================= LOGIN =================
login:
    lw $t0, locked
    li $t1, 1
    beq $t0, $t1, system_locked

    li $v0, 4
    la $a0, msg_login
    syscall

    li $v0, 8
    la $a0, input
    li $a1, 20
    syscall

    jal clean_input

    la $t0, password
    la $t1, input

cmp:
    lb $t2, 0($t0)
    lb $t3, 0($t1)
    bne $t2, $t3, wrong
    beq $t2, 0, success
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j cmp

wrong:
    lw $t4, attempts
    addi $t4, $t4, 1
    sw $t4, attempts

    li $t5, 3
    beq $t4, $t5, lock

    li $v0, 4
    la $a0, msg_wrong
    syscall
    j login

lock:
    li $t0, 1
    sw $t0, locked

system_locked:
    li $v0, 4
    la $a0, msg_lock
    syscall
    li $v0, 10
    syscall

success:
    li $v0, 4
    la $a0, msg_ok
    syscall
    j menu_system

# ==================================================
# MENU
# ==================================================
menu_system:
    li $v0, 4
    la $a0, menu
    syscall

menu_loop:
    li $v0, 4
    la $a0, menu_opt
    syscall

    li $v0, 5
    syscall
    move $t7, $v0

    li $t1, 1
    beq $t7, $t1, create_file
    li $t1, 2
    beq $t7, $t1, read_file
    li $t1, 3
    beq $t7, $t1, delete_file
    li $t1, 4
    beq $t7, $t1, list_files
    li $t1, 5
    beq $t7, $t1, overwrite_file
    li $t1, 6
    beq $t7, $t1, exit

    j menu_loop

# ==================================================
# CREATE FILE
# ==================================================
create_file:
    li $v0, 4
    la $a0, msg_fname
    syscall

    li $v0, 8
    la $a0, fname
    li $a1, 20
    syscall
    jal clean_fname

    li $v0, 4
    la $a0, msg_fcontent
    syscall

    li $v0, 8
    la $a0, fcontent
    li $a1, 100
    syscall
    jal clean_content

    la $t0, file1_flag
    lw $t1, 0($t0)
    beq $t1, 0, s1

    la $t0, file2_flag
    lw $t1, 0($t0)
    beq $t1, 0, s2

    la $t0, file3_flag
    lw $t1, 0($t0)
    beq $t1, 0, s3

    la $t0, file4_flag
    lw $t1, 0($t0)
    beq $t1, 0, s4

    la $t0, file5_flag
    lw $t1, 0($t0)
    beq $t1, 0, s5

    j menu_loop

s1:
    la $a0, file1_name
    la $a1, fname
    jal copy
    la $a0, file1_data
    la $a1, fcontent
    jal copy
    li $t2, 1
    sw $t2, file1_flag
    j done_create

s2:
    la $a0, file2_name
    la $a1, fname
    jal copy
    la $a0, file2_data
    la $a1, fcontent
    jal copy
    li $t2, 1
    sw $t2, file2_flag
    j done_create

s3:
    la $a0, file3_name
    la $a1, fname
    jal copy
    la $a0, file3_data
    la $a1, fcontent
    jal copy
    li $t2, 1
    sw $t2, file3_flag
    j done_create

s4:
    la $a0, file4_name
    la $a1, fname
    jal copy
    la $a0, file4_data
    la $a1, fcontent
    jal copy
    li $t2, 1
    sw $t2, file4_flag
    j done_create

s5:
    la $a0, file5_name
    la $a1, fname
    jal copy
    la $a0, file5_data
    la $a1, fcontent
    jal copy
    li $t2, 1
    sw $t2, file5_flag

done_create:
    li $v0, 4
    la $a0, msg_created
    syscall
    j menu_loop

# ==================================================
# READ FILE
# ==================================================
read_file:
    li $t9, 0

    li $v0, 4
    la $a0, msg_fname
    syscall

    li $v0, 8
    la $a0, fname
    li $a1, 20
    syscall
    jal clean_fname

    la $t0, file1_name
    la $t1, file1_data
    lw $t2, file1_flag
    jal compare_read

    la $t0, file2_name
    la $t1, file2_data
    lw $t2, file2_flag
    jal compare_read

    la $t0, file3_name
    la $t1, file3_data
    lw $t2, file3_flag
    jal compare_read

    la $t0, file4_name
    la $t1, file4_data
    lw $t2, file4_flag
    jal compare_read

    la $t0, file5_name
    la $t1, file5_data
    lw $t2, file5_flag
    jal compare_read

    beq $t9, 1, menu_loop

    li $v0, 4
    la $a0, msg_notfound
    syscall
    j menu_loop

# ==================================================
# DELETE FILE
# ==================================================
delete_file:
    li $t9, 0

    li $v0, 4
    la $a0, msg_fname
    syscall

    li $v0, 8
    la $a0, fname
    li $a1, 20
    syscall
    jal clean_fname

    la $t0, file1_name
    la $t1, file1_data
    la $t2, file1_flag
    jal compare_delete

    la $t0, file2_name
    la $t1, file2_data
    la $t2, file2_flag
    jal compare_delete

    la $t0, file3_name
    la $t1, file3_data
    la $t2, file3_flag
    jal compare_delete

    la $t0, file4_name
    la $t1, file4_data
    la $t2, file4_flag
    jal compare_delete

    la $t0, file5_name
    la $t1, file5_data
    la $t2, file5_flag
    jal compare_delete

    beq $t9, 1, menu_loop

    li $v0, 4
    la $a0, msg_notfound
    syscall
    j menu_loop

# ==================================================
# LIST FILES
# ==================================================
list_files:
    li $v0, 4
    la $a0, msg_list
    syscall

    lw $t0, file1_flag
    beq $t0, 0, l2
    la $a0, file1_name
    li $v0, 4
    syscall

l2:
    lw $t0, file2_flag
    beq $t0, 0, l3
    la $a0, file2_name
    li $v0, 4
    syscall

l3:
    lw $t0, file3_flag
    beq $t0, 0, l4
    la $a0, file3_name
    li $v0, 4
    syscall

l4:
    lw $t0, file4_flag
    beq $t0, 0, l5
    la $a0, file4_name
    li $v0, 4
    syscall

l5:
    lw $t0, file5_flag
    beq $t0, 0, menu_loop
    la $a0, file5_name
    li $v0, 4
    syscall

    j menu_loop

# ==================================================
# OVERWRITE
# ==================================================
overwrite_file:
    li $v0, 4
    la $a0, msg_fname
    syscall

    li $v0, 8
    la $a0, fname
    li $a1, 20
    syscall
    jal clean_fname

    li $v0, 4
    la $a0, msg_fcontent
    syscall

    li $v0, 8
    la $a0, fcontent
    li $a1, 100
    syscall
    jal clean_content

    la $t0, file1_name
    la $t1, file1_data
    lw $t2, file1_flag
    jal overwrite_check

    la $t0, file2_name
    la $t1, file2_data
    lw $t2, file2_flag
    jal overwrite_check

    la $t0, file3_name
    la $t1, file3_data
    lw $t2, file3_flag
    jal overwrite_check

    la $t0, file4_name
    la $t1, file4_data
    lw $t2, file4_flag
    jal overwrite_check

    la $t0, file5_name
    la $t1, file5_data
    lw $t2, file5_flag
    jal overwrite_check

    j menu_loop

# ==================================================
# FUNCTIONS
# ==================================================
copy:
    lb $t3, 0($a1)
    sb $t3, 0($a0)
    beq $t3, 0, cend
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    j copy
cend:
    jr $ra

clean_input:
    la $t0, input
ci:
    lb $t1, 0($t0)
    beq $t1, 0, ci_end
    beq $t1, 10, ci_zero
    addi $t0, $t0, 1
    j ci
ci_zero:
    sb $zero, 0($t0)
ci_end:
    jr $ra

clean_fname:
    la $t0, fname
cf:
    lb $t1, 0($t0)
    beq $t1, 0, cf_end
    beq $t1, 10, cf_zero
    addi $t0, $t0, 1
    j cf
cf_zero:
    sb $zero, 0($t0)
cf_end:
    jr $ra

clean_content:
    la $t0, fcontent
cc:
    lb $t1, 0($t0)
    beq $t1, 0, cc_end
    beq $t1, 10, cc_zero
    addi $t0, $t0, 1
    j cc
cc_zero:
    sb $zero, 0($t0)
cc_end:
    jr $ra

# ==================================================
# READ COMPARE
# ==================================================
compare_read:
    beq $t2, 0, rskip
    la $t3, fname
    move $t6, $t0

rloop:
    lb $t4, 0($t6)
    lb $t5, 0($t3)
    bne $t4, $t5, rskip
    beq $t4, 0, rfound
    addi $t6, $t6, 1
    addi $t3, $t3, 1
    j rloop

rfound:
    li $t9, 1
    li $v0, 4
    la $a0, msg_show
    syscall

    li $v0, 4
    move $a0, $t1
    syscall
    jr $ra

rskip:
    jr $ra

# ==================================================
# DELETE COMPARE
# ==================================================
compare_delete:
    beq $t2, 0, dskip
    la $t3, fname
    move $t6, $t0

dloop:
    lb $t4, 0($t6)
    lb $t5, 0($t3)
    bne $t4, $t5, dskip
    beq $t4, 0, dfound
    addi $t6, $t6, 1
    addi $t3, $t3, 1
    j dloop

dfound:
    li $t9, 1
    sw $zero, 0($t2)

    move $t7, $t0
cln:
    lb $t8, 0($t7)
    beq $t8, 0, cld
    sb $zero, 0($t7)
    addi $t7, $t7, 1
    j cln

cld:
    move $t7, $t1
cld2:
    lb $t8, 0($t7)
    beq $t8, 0, done_del
    sb $zero, 0($t7)
    addi $t7, $t7, 1
    j cld2

done_del:
    li $v0, 4
    la $a0, msg_deleted
    syscall
    jr $ra

dskip:
    jr $ra

# ==================================================
# OVERWRITE COMPARE
# ==================================================
overwrite_check:
    beq $t2, 0, oskip
    la $t3, fname
    move $t6, $t0

oloop:
    lb $t4, 0($t6)
    lb $t5, 0($t3)
    bne $t4, $t5, oskip
    beq $t4, 0, ofound
    addi $t6, $t6, 1
    addi $t3, $t3, 1
    j oloop

ofound:
    li $t9, 1

    move $t7, $t1
    la $t8, fcontent

copy_loop:
    lb $t4, 0($t8)
    sb $t4, 0($t7)
    beq $t4, 0, oend
    addi $t7, $t7, 1
    addi $t8, $t8, 1
    j copy_loop

oend:
    li $v0, 4
    la $a0, msg_updated
    syscall
    jr $ra

oskip:
    jr $ra
 
 
# ==================================================
# EXIT
# ==================================================
exit:
    li $v0, 10
    syscall