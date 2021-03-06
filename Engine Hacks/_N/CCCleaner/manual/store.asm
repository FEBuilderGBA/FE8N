@define PRESS_INPUT_ADR ($085775cc)


@define MAX_NUM ADR+8
@define GETSKILL ADR+12
@define DEDUPSKILL ADR+16
@define PUSHSKILL ADR+20
@define POPSKILL ADR+24
@define REMOVESKILL ADR+28

@thumb
;0002f740
	cmp r0, #0x89
	beq	metis
	ldr	r1, =$080174E4
	mov lr, r1
	@dcw $F800
	cmp r0, #0x2E
	beq manual
	ldr	r1, =$0802f760 ;その他のアイテムへ
	mov pc, r1
metis:
	b meti
	
manual:
    mov r0, r6
    ldr r1, =$08017384 ;武器威力
    mov lr, r1
    @dcw $F800
    cmp r0, #255
    bne not_eraser
;▼消す処理
	bl Eraser
    
    mov r0, r4
    mov r1, r7
        ldr r3, =$080186a8
        mov lr, r3
        @dcw $F800
    @align 4
    ldr r0, [ADR+4] ;使用後の説明
    ldr r1, =$0802f858
    mov pc, r1
;▼スキル書の処理
    
not_eraser:
    mov r6, r0
@align 4
	ldr r1 [MAX_NUM]
	sub r1, 1
	mov r0, r4
	bl ex_getSkill
	cmp r0, #0
	beq go_normal	;まだ余裕があるから使える
    
    mov r0, r4
    bl ex_dedupSkill
@align 4
	ldr r1 [MAX_NUM]
	cmp r0, r1
	beq return	;重複も存在しない場合はreturnへ
    
    mov r1, r0
    mov r0, r4
    bl ex_removeSkill
    
go_normal:
    mov r0, r4
    mov r1, r6
    bl ex_pushSkill

return:
	mov	r0, r4
        ldr r1, =$080186a8
        mov lr, r1
    mov r1, r7
    @dcw $F800
    @align 4
    ldr r0, [ADR] ;使用後の説明
    ldr r1, =$0802f858
    mov pc, r1
    
meti:
;▼メティスの書
	ldr	r0, [r4, #12]
	mov	r1, #128
	lsl	r1, r1, #6
	orr	r0, r1
	str	r0, [r4, #12]
	mov	r0, r4
ldr	r1, =$0802f750
mov pc, r1


Eraser:
;スキルを削除する
;削除したスキルを書にする
;
	push {lr}
;重複チェック
    mov r0, r4
    bl ex_dedupSkill
@align 4
	ldr r1 [MAX_NUM]
	cmp r0, r1
	bne dedup	;重複が存在する場合は最優先で抽出
;ボタンチェック
@align 4
    ldr r0, =PRESS_INPUT_ADR
	ldr	r0, [r0]
	ldrh	r1, [r0, #4]
	mov	r0, #4
	and	r0, r1
	bne reverse
;末尾のスキルを抽出
    mov r0, r4
    bl ex_popSkill
    b merge
reverse:
;第一スキルを抽出
    mov r0, r4
    mov r1, #0
    bl ex_removeSkill
    b merge
dedup:
;重複スキルを削除
	mov r1, r0
    mov r0, r4
    bl ex_removeSkill
	
merge:
	mov r6, r0
    ldr r3, =$080172d4	;アイテムのテーブル格納アドレス
    ldr r3, [r3]
    
    mov r0, #1
    lsl r1, r0, #3
    add r1, r1, r0
    lsl r1, r1, #2	;r1 = アイテム1個分のデータサイズ

    mov r5, #0 ;カウンタ
next
    add r5, #1
    add r3, r3, r1
    ldrb	r0, [r3, #30] ;アイテム効果
    cmp r0, #0x2e
    bne next
    ldrb r0, [r3, #21] ;アイテム威力
    cmp r0, r6
    beq hit
    b next
hit:
    mov r0, r4
    add r0, #0x1E
    lsl r1, r7, #1
    add r0, r0, r1
    strb r5, [r0]		;スキルの書のIDをストア。
    mov r1, #2			;この後に減算処理があるため、
    strb r1, [r0, #1]	;残り回数を1回にするには回数2をストア。
	pop {pc}
@align 4
@ltorg
ex_getSkill:
	ldr r3, [GETSKILL]
	mov pc, r3
ex_dedupSkill:
	ldr r3, [DEDUPSKILL]
	mov pc, r3
ex_pushSkill:
	ldr r3, [PUSHSKILL]
	mov pc, r3
ex_popSkill:
	ldr r3, [POPSKILL]
	mov pc, r3
ex_removeSkill:
	ldr r3, [REMOVESKILL]
	mov pc, r3


ADR: