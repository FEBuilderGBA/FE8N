@thumb
;@org	$0801743c
	mov	r0, r13
	ldr	r2, =$03007D6C
	cmp	r0, r2
	beq	end
	ldr	r0, [r0, #4]
	ldr	r2, =$0802A833
	cmp	r0, r2
	beq	five
	mov	r0, #0x1
	lsl	r0, r0, #16
	cmp	r6, r0
	bgt	six
	cmp	r5, r0
	blt	zero
five
	mov	r0, r5
	b	kit
six
	mov	r0, r6
	b	kit
zero
	ldr	r0, =$03004df0
	ldr	r0, [r0]
kit:
	cmp	r0, #0
	beq	end
	push {r3}
ldr	r3, [r0, #12]	;�ߊl
mov		r2,#0x80
lsl		r2, r2,#0x17
tst	r3, r2
	pop {r3}
bne	one
	
	ldr	r0, [r0, #4]
	ldrb	r0, [r0, #4]
	cmp	r0, #0x1B	;�X�i�C�|
	beq	sagi
	cmp	r0, #0x1C	;�X�i�C�|
	bne	end
sagi
	lsl	r0, r1, #24
	lsr	r0, r0, #24
	cmp	r0, #0x22
	bne	end
	add	r1, #1
end
	mov	r0, #0xF
	and	r0, r1
	bx	lr
one:
	mov	r1, #0x11
	b	end
	
	