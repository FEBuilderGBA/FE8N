@thumb
;0002af60
;�ǌ��s����
    
    
    ldr r0, =$03004df0
    ldr r0, [r0]
    ldrb r0, [r0, #11]
    ldr r1, [r4]
    ldrb r1, [r1, #11]
    cmp r0, r1
    bne normal ;�U���҂��ᖳ��
    
    ldr r0, =$0203a4d0
    ldrh r0, [r0]
    mov r1, #0x20
    and r0, r1
    bne normal ;���Z��`�F�b�N
    
    ldr r0, [r7]
        @align 4
        ldr r1, [adr+0] ;���؂�
        mov lr, r1
        @dcw $F800
    cmp r0, #0
    bne normal ;���؂�

    ldr r0, [r4]
        @align 4
        ldr r1, [adr+4] ;���ガ
        mov lr, r1
        @dcw $F800
    bne cancel ;�X�L������
normal
    ldr r0, [r4]
    add r0, #74
    ldrh r0, [r0]
        ldr r1, =$080174cc
        mov lr, r1
        @dcw $F800
    ldr r0, =$0802af6a
    mov pc, r0
    
cancel
    ldr r0, =$0802af80
    mov pc, r0
    
@ltorg
adr
    