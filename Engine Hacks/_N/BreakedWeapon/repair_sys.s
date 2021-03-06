
UNIT_MAX_NUM = (51)

.thumb
	push {lr}
	push {r0}
	
	ldr r0, =0x0202BCFC
	ldrb r0, [r0]
	cmp r0, #0
	beq RETURN	@0ターン目なら終了
	
	bl Unit
	bl TransPort
RETURN:
	pop {r2}
	ldr	r0, =0x080aeff8
	ldr r0, [r0]
	ldrb	r1, [r0, #4]
	ldr r0, =0x080aefe4
	mov pc, r0
	
Unit:
	push {r4, r5, r6, lr}
	
	mov r6, #1	@部隊表IDは1から
outLoopUnit:
	mov r5, #0
	
	mov r0, r6
		ldr r1, =0x08019108
		mov lr, r1
		.short 0xF800
	mov r4, r0
	ldr r0, [r4]
	cmp r0, #0
	beq endOutLoopUnit	@ユニットがもういない
	add r4, #30	@アイテムアドレスまで
inLoopUnit:
	lsl r0, r5, #1
	ldrh r0, [r4, r0]
	cmp r0, #0
	beq endInLoopUnit	@アイテムがもうない
		ldr r2, =0x08017314
		mov lr, r2
		.short 0xF800
	lsl r1, r0, #21
	bmi isUnit	@竜石
	lsl r1, r0, #28
	bmi isUnit	@回数無限
	mov r1, #0x6	@魔法または杖
	and r0, r1
	beq isnotUnit
isUnit:
	lsl r0, r5, #1
	add r0, r4
	bl Repair
isnotUnit:
	add r5, #1
	cmp r5, #5
	blt inLoopUnit
endInLoopUnit:
	add r6, #1
	cmp r6, #UNIT_MAX_NUM
	blt outLoopUnit
endOutLoopUnit:
	pop {r4, r5, r6, pc}
	
TransPort:
	push {r4, r5, r6, lr}
	
	ldr r5, =0x08031450
	ldr r5, [r5]	@輸送隊のベースアドレス
	
	ldr r6, =0x08031474
	ldrb r6, [r6]	@最大値100
	
	mov r4, #0	@カウンタ初期化
loopTransPort:
	lsl r0, r4, #1
	ldrh r0, [r5, r0]
	cmp r0, #0
	beq endLoopTransPort	@アイテムがもうない
		ldr r2, =0x08017314
		mov lr, r2
		.short 0xF800
	lsl r1, r0, #21
	bmi isTransport	@竜石
	lsl r1, r0, #28
	bmi isTransport	@回数無限
	mov r1, #0x6	@魔法または杖
	and r0, r1
	beq isnotTransPort
isTransport:
	lsl r0, r4, #1
	add r0, r5
	bl Repair
isnotTransPort:
	add r4, #1
	cmp r4, r6
	blt loopTransPort
endLoopTransPort:
	pop {r4, r5, r6, pc}
	
Repair:
	push {r4, lr}
	mov r4, r0
	ldrh r0, [r4]
		ldr r2, =0x08017358
		mov lr, r2
		.short 0xF800
	cmp r0, #255
	beq falseRepair
	cmp r0, #0
	beq falseRepair
trueRepair:
	strb r0, [r4, #1]
	b endRepair
falseRepair:
	mov r0, #1
	strb r0, [r4, #1]
endRepair:
	pop {r4, pc}

