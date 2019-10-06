.equ STR_ADR, (67)	@書き込み先(AI1カウンタ)
.equ WAR_FLAG, (0xFF)	@フラグ
.equ WAR_FLAG2, (0xFE)	@フラグ

.thumb

@ 0x02bfd8

	cmp	r6, #0
	beq	RETURN
	mov	r0, r6
	mov	r1, r4
		ldr	r2, =0x0802c134
		mov	lr, r2
		.short 0xF800
@;表側
	mov	r0, r7
	mov	r1, r6
	bl Fury
	mov	r0, r7
	mov	r1, r6
	bl Jadoku
	mov	r0, r7
	bl WarSkill_back
	
@;裏側
	mov	r0, r6
	mov	r1, r7
	bl Fury
	
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
RETURN:
	ldr	r0, =0x0802bfec
	mov	pc, r0

WarSkill_back:
	mov r1, r0
	add r1, #STR_ADR
	ldrb r0, [r1]
	cmp r0, #WAR_FLAG
	beq war_jump
	cmp r0, #WAR_FLAG2
	bne war_end
war_jump:
	mov r0, #0
	strb r0, [r1]
war_end:
    bx lr

Jadoku:
	push	{r4, lr}
	mov r3, r0
	mov r4, r1
    ldrb r0, [r4, #0x13]
    cmp r0, #0
    beq falseJadoku		@;相手撃破なら終了
    
    ldrb r0, [r3, #0xB]
    lsl r0, r0, #24
    bmi isRed

    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bmi startJadoku
    b falseJadoku	@相手チェック失敗
    
isRed:
    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bpl startJadoku
    b falseJadoku	@相手チェック失敗
    
startJadoku:
    mov r0, r3
        ldr r2, ADR+8
        mov lr, r2
        .short 0xF800
    cmp r0, #0
    beq falseJadoku	@蛇毒未所持なら終了
    
    mov r0, r4
        ldr r2, ADR+0
        mov lr, r2
        .short 0xF800
    cmp r0, #0
    bne falseJadoku	@見切り持ちなら終了
@蛇毒on
    ldrb r0, [r4, #19] @;現在19
    sub r0, #10
    bgt hpOk
    mov r0, #1
hpOk:
    strb r0, [r4, #19] @;現在19
    
	mov r0, #0xB7	@妥当な音のIDが分からん
	mov r1, #0xB8
		ldr r2, =0x08014B50 @;音
		mov lr, r2
		.short 0xF800
    mov	r0, #1
    .short 0xE000
falseJadoku:
    mov	r0, #0
	pop	{r4, pc}
	
Fury:
	push	{r4, lr}
	mov	r4, r0
	mov	r0, r1
		ldr	r1, ADR+0
		mov	lr, r1
		.short 0xF800
	cmp	r0, #0
	bne	false
	mov	r0, r4
		ldr	r1, ADR+4
		mov	lr, r1
		.short 0xF800
	cmp	r0, #0
	beq false
	ldrb r2, [r4, #18] @;最大HP
	ldrb r0, [r4, #19] @;現在HP
	cmp r0, r2
	blt jump @;現在が最大よりも小さい場合
	sub	r0, #1
	strb	r0, [r4, #19]
jump:
	mov	r0, #1
	b	ret
false:
	mov	r0, #0
ret:
	pop	{r4, pc}

.align
.ltorg
ADR:
