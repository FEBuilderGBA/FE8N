@
@�Đ�����X�L���A�j���\���̂̎擾
@�擾�ł��Ȃ���� 0 ���Ԃ����
@
@���� r0=�X�L���̎�� #0x00=�U�� #0x01=�h�q
.thumb
    push {r4,lr}

	mov		r4,r0				@�X�L���̕���

	ldr		r3, =0x0203AB40  @�ێ����Ă���Ɣ��肳�ꂽ�X�L��ID���L�^. �X�L�������̃A�j���[�V�������o�����ɗ��p����

	ldr		r0, =0x0203E188		@�퓬�A�j���ōU�����ւ�RAM�|�C���^
	ldr		r0, [r0, #0x0]		@RAM�f�[�^��

	mov		r2,#0xB
	ldrb	r2,[r0,r2]	@UnitRAMPointer->�����\ID	�F�R+0x40	�G�R+0x80
	cmp		r2,#0x80
	blt		Player		@Player or Ally

Enemy:
	add		r3, #0x02		@�G�R
	@b		Join1

Player:
	@nop
@Join1:

	cmp		r4, #0x00		@�X�L���̕��ނ�]��
	beq		AttackSkill
	b		DefenseSkill

DefenseSkill:
	add		r3,#0x01	@�h�q�X�L����+1����.
	@b		Join2

AttackSkill:
	@nop

@Join2:
	ldrb	r0, [r3]      @�L�^���Ă������X�L��ID���擾

	cmp		r0,#0x00
	beq		Exit	@�s�� �f�B�t�H���g�A�j�������̂܂ܗ��p

	ldr		r1,	adr       @SkillAnimation* SkillAnimation[SKILL_ID] skillanimation@
	lsl		r0 ,r0 ,#0x2	@r1=skill_id << 2 (�|�C���^�Q�Ƃ��邽��)
	ldr		r0,[r1,r0]      @skl_anime_table[skill_id].SkillAnime
	@cmp		r0,#0x00
	@beq		Exit        @�s�� �f�B�t�H���g�A�j�������̂܂ܗ��p
	
Exit:
    pop {r4,pc}
.align 4
.ltorg
adr: