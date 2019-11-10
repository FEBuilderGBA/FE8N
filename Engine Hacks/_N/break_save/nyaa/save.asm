@define CHAPTER_BASE_ADR (0x0202bcec)
@thumb
;000a7c28
    push {r4, r5, r6, r7, lr}
    mov r7, r8
    push {r7}
    @dcw $b0ac ;sub sp, #176
    @dcw $b0ac ;sub sp, #176
    nop
    ldr r1, =$080a9abd
    mov r0, lr
    cmp r0, r1
    beq normal
    nop
    ldr r1, =$080a99c9
    cmp r0, r1
    beq start
    
    mov r0, #0
    b merge
start:
	ldr r0, =CHAPTER_BASE_ADR
	ldrb r0, [r0, 12]
;	mov r0, r9
    add r0, #1
    b merge
normal:
    mov r0, r10
    add r0, #1
merge:
    ldr r1, =0x160
    mul r0, r1
    ldr r1, =$0E007400
    add r1, r0, r1
    mov r8, r1
;ここからスキル
    mov r1, #0
    cmp r0, #0
    @dcw $D100
    mov r1, #1

    mov r0, r1
        @align 4
        ldr r1, [ADR]
        mov lr, r1
    @dcw $F800
    
;ここまでスキル
        ldr r0, =$0803144c ;=輸送隊のベースアドレスロード
        mov lr, r0
    @dcw $F800
    mov r6, r0
    @dcw $AD19
    add r5, #100
    ldr r0, =$080a7c3a
    mov pc, r0
@align 4
@ltorg
    ADR: