@thumb

@define ICON_LIST_SIZE 16

;@org	$08089268
	
	push	{r4, r5, r6, r7, lr}
;画像
	mov	r4, #0
    @align 4
    ldr r0, [adr+20]	;EQUIPMENT_POSITION
    ldr r0, [r0]
    
	ldr	r6, =$00007060
	mov	r5, r6	
	ldr	r1, =$000002c2
	add	r2, r0, r1
	add	r6, #8
	mov	r3, r6
	ldr	r6, =$00000302
	add	r1, r0, r6
loopE
	add	r0, r4, r5
	strh	r0, [r2, #0]
	add	r0, r4, r3
	strh	r0, [r1, #0]
	add	r2, #2
	add	r1, #2
	add	r4, #1
	cmp	r4, #7
	ble	loopE
;アイコン
    @align 4
    ldr r6, [adr+24] ;ICON_POSITION =$020040ee ;icon position($02004130)
    ldr r6, [r6]
	ldr	r7, =$02003B00	;help memory
	mov	r5, #0
	str	r5, [r7]
	str	r5, [r7, #4]
	str	r5, [r7, #8]
@align 4
	ldr	r5, [adr+16]	;skl_icon_table
	ldr	r4, =$02003BFC
	ldr	r0, [r4, #12]
	ldrh	r4, [r0, #0x3A]
    mov r0, %111111
    and r4, r0
	bl	SKILL3 ;スキル書1
@align 4
	ldr	r5, [adr+16]	;skl_icon_table
	ldr	r4, =$02003BFC
	ldr	r0, [r4, #12]
	ldrh	r4, [r0, #0x3A]
	lsr r4, r4, #6
    mov r0, %111111
    and r4, r0
	bl	SKILL3 ;スキル書2
@align 4
	ldr	r5, [adr+16]	;skl_icon_table
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldr	r4, [r4]
	add	r4, #0x26
	ldrb	r4, [r4]
	bl	SKILL3 ;下級スキル
@align 4
	ldr	r5, [adr+16]	;skl_icon_table
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldr	r0, [r4, #4] ;class
	ldr	r0, [r0, #40]
	lsl	r0, r0, #23
	bpl nomi ;上級職のみ
	ldr	r4, [r4]
	add	r4, #0x27
	ldrb	r4, [r4]
	bl	SKILL3 ;上級スキル
nomi:
@align 4
	ldr	r5, [adr+16]	;skl_icon_table
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldrb	r0, [r4, #0xB]
	lsr	r0, r0, #6
	beq nomi2 ;自軍外のみ
	ldr	r4, [r4]
	add	r4, #0x31
	ldrb	r4, [r4]
	bl	SKILL3 ;自軍外スキル
nomi2:
@align 4
	ldr	r5, [adr]	;UNIT
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldr	r4, [r4]
	ldrb	r4, [r4, #4]
	bl	SKILL
@align 4
	ldr	r5, [adr+12]	;ABILITY
	ldr	r4, =$02003BFC
	ldr	r0, [r4, #12]
	ldr	r4, [r0, #4]	;兵種
	ldr	r4, [r4, #40]
	mov	r2, #0x80
	lsl	r2, r2, #17	;兵種EXP0
	mvn	r2, r2
	and	r4, r2
	ldr	r0, [r0]	;個人
	ldr	r0, [r0, #40]
	orr	r4, r0
	bl	SKILL2
@align 4
	ldr	r5, [adr+4]	;CLASS
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldr	r4, [r4, #4]
	ldrb	r4, [r4, #4]
	bl	SKILL
@align 4
	ldr	r5, [adr+16]	;CLASS2
    ldr r4, =$02003BFC
    ldr r4, [r4, #12]
    ldr r4, [r4, #4]
    ldrb r4, [r4, #4]
    mov r3, #2;CLASS
    bl SKILL4
@align 4
	ldr r5, [adr+8]	;WEAPON
	ldr	r4, =$0203a530
	ldrb	r4, [r4]
	cmp r4, #0
	beq end
	bl	SKILL
@align 4
    ldr r5, [adr+16] ;weapon2
    ldr r4, =$0203a530
    ldrb r4, [r4]
    mov r3, #3 ;weapon2
    bl SKILL4
end
	pop	{r4, r5, r6, r7, pc}


SKILL: ;旧仕様
	push	{lr}
	b	test
restart
	mov	r0, r4
	mov	r2, #0x10
loop
	ldrb	r1, [r5, r2]
	cmp	r1,	#0
	beq jump
	cmp	r0, r1
	beq	skiller
	add	r2, #1
	cmp	r2, #0x20
	beq	jump ;LISTlimit
	b loop

skiller
	ldrh	r1, [r5, #2]
	strh	r1, [r7]
	ldrh	r1, [r5]
	mov	r2, #0xA0
	ldrb	r3, [r5, #4]
	cmp	r3, #0xFF
	bne	nonitem
	sub	r2, #0x20
nonitem
	lsl	r2, r2, #7
	mov	r0, r6
	bl	icon
    @align 4
    ldr r0, [adr+28] ;ICON_GAP
    ldr r0, [r0]
    add r6, r6, r0
	add	r7, #2	;HELP memory increment
	
jump
	add	r5, #0x20
test
	ldr	r0, [r5]
	ldr r1, =$FFFFFFFF
	cmp	r0, r1
	bne	doublecount
	pop	{pc}

doublecount: ;二重表示防止
	ldrh r0, [r5, #2]
	ldr r2 =$02003B00
loopyloopy
	cmp r2, r7
	beq limitter
	ldrh r1, [r2]
	cmp r0, r1
	beq jump ;被っていたら無視
	add r2, #2
	b loopyloopy

limitter
	lsl r0, r7, #24
	lsr r0, r0, #24
	cmp r0, #12 ;アイコン上限
	bne restart
	pop {pc}

icon
	ldr	r3, =$08003608
	mov	pc, r3



SKILL2: ;ability仕様
	push	{lr}
	cmp	r4, #0
	bne	test2
	pop	{pc}

restart2
	mov	r0, r4
	mov	r2, #0x10
loop2
	ldr	r1, [r5, r2]
	cmp	r1,	#0
	beq	jump2
	and r1, r0
	bne	skiller2
	add	r2, #4
	cmp	r2, #0x20
	beq	jump2 ;LISTlimit
	b	loop2

skiller2
	ldrh	r1, [r5, #2]
	strh	r1, [r7]
	ldrh	r1, [r5]
	mov	r2, #0xA0
	ldrb	r3, [r5, #4]
	cmp	r3, #0xFF
	bne	nonitem2
	sub	r2, #0x20
nonitem2
	lsl	r2, r2, #7
	mov	r0, r6
	bl	icon
    @align 4
    ldr r0, [adr+28] ;ICON_GAP
    ldr r0, [r0]
    add r6, r6, r0
	add	r7, #2	;HELP memory increment
	
jump2
	add	r5, #0x20
test2
	ldr	r0, [r5]
	ldr r1, =$FFFFFFFF
	cmp	r0, r1
	bne	doublecount2
	pop	{pc}

doublecount2
	ldrh r0, [r5, #2]
	ldr r2 =$02003B00
loopyloopy2
	cmp r2, r7
	beq limitter2
	ldrh r1, [r2]
	cmp r0, r1
	beq jump2
	add r2, #2
	b loopyloopy2
limitter2
	lsl r0, r7, #24
	lsr r0, r0, #24
	cmp r0, #12 ;アイコン上限
	bne restart2
	pop {pc}
	
	
SKILL3: ;新仕様1
    push {lr}
    cmp r4, #0
    bne test3
end3:
    pop {pc}
test3
    cmp r4, #127
    bge end3
    mov r0, #ICON_LIST_SIZE
    mul r0, r4
    add r5, r5, r0
    ldrh r0, [r5]
    cmp r0, #0
    beq end3

    ldr r2 =$02003B00
loopyloopy3
	cmp r2, r7
	beq limitter3
	ldrh r1, [r2]
	cmp r0, r1
	beq end3
	add r2, #2
	b loopyloopy3
limitter3
	lsl r0, r7, #24
	lsr r0, r0, #24
	cmp r0, #12 ;アイコン上限
	beq end3

    ldrh r0, [r5]
    cmp r0, #0
    beq end3 ;ヘルプが無ければ終了
    strh r0, [r7]
    add r1, r4, #1
    add r1, #255
    mov r2, #0xA0
    ldrb r3, [r5, #2]
    cmp r3, #0xFF
    bne nonitem3
    sub r2, #0x20
nonitem3
    lsl r2, r2, #7
    mov r0, r6
    bl icon
    @align 4
    ldr r0, [adr+28] ;ICON_GAP
    ldr r0, [r0]
    add r6, r6, r0
    add r7, #2	;HELP memory increment
    pop {pc}


SKILL4:
    push {r3, r4, lr} ;r4=判定ID
    cmp r4, #0
    beq end4
    mov r4, #0 ;以後r4はカウンタ
    lsl r3, r3, #2 ;リスト始点をずらす
    b next4
    
loopstart4:
    ldr r0, [r5, r3] ;リストポインタロード
    cmp r0, #0
    beq next4
;ダブりチェック
    ldrh r0, [r5]
    ldr r2 =$02003B00
loopyloopy4
    cmp r2, r7
    beq list_checker
    ldrh r1, [r2]
    cmp r0, r1
    beq next4
    add r2, #2
    b loopyloopy4
    
list_checker:
    ldr r2, [r5, r3] ;リストポインタロード
    ldr r1, [sp+4]  ;IDをロード
list_loop:
    ldrb r0, [r2]
    cmp r0, #0
    beq next4
    cmp r0, r1
    beq limitter4 ;IDが一致
    add r2, #1
    b list_loop

limitter4: ;上限チェック
    lsl r1, r7, #24
    lsr r1, r1, #24
    cmp r1, #12 ;アイコン上限
    beq end4
    ldrh r0, [r5]
    cmp r0, #0
    beq next4 ;ヘルプが無ければ次へ
    strh r0, [r7] ;ヘルプストア
    add r1, r4, #1
    add r1, #255
    mov r2, #0xA0
    ldrb r0, [r5, #2]
    cmp r0, #0xFF
    bne nonitem4
    sub r2, #0x20
nonitem4
    lsl r2, r2, #7
    mov r0, r6
    bl icon
    ldr r3, [sp]  ;r3復帰
    lsl r3, r3, #2 ;リスト始点をずらす
    @align 4
    ldr r0, [adr+28] ;ICON_GAP
    ldr r0, [r0]
    add r6, r6, r0
    add r7, #2	;HELP memory increment
next4:
    add r5, #ICON_LIST_SIZE
    add r4, #1
    cmp r4, #127 ;スキル最大数
    ble loopstart4
end4:
    pop {r3, r4, pc}


@ltorg
adr: