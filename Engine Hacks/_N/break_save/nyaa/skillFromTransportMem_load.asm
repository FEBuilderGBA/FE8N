@define EXTRACT_DATA_ADR ($03006790)
@define TRANSPORT_DATA_ADR ($0203a818)

@thumb
;I	r0 = ���[�h���B1:���f�B0:���̑�
;O	-
	push {lr}
	
		@align 4
		ldr	r3, [get_saveBaseAdr]
		mov lr, r3
	@dcw $F800
	bl extract_exSkill
end:
	pop {pc}

extract_exSkill:
;I	r0 = ���j�b�g�̃Z�[�u�x�[�X�A�h���X(0xE0000000)
;O	-
	push {lr}
	
	ldr	r1, =TRANSPORT_DATA_ADR
	mov	r2, #176
	ldr	r3, =EXTRACT_DATA_ADR
	ldr	r3, [r3, #0]
		mov lr, r3
	    @dcw $F800	
	pop {pc}
@align 4
@ltorg
get_saveBaseAdr:
	