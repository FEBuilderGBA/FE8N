@thumb
    push {r2, r3}

    ldr r0, [r4, #76]
    mov r1, #32
    and r0, r1
    cmp r0, #0
    bne got
    mov r0, r4
    ldr r1, =$0203a568
        @align 4
        ldr r3, [adr] ;bolt
        mov lr, r3
        @dcw $F800
    cmp r0, #0
    bne got
    ldr r0, =$0203a568
    mov r1, r4
        @align 4
        ldr r3, [adr] ;bolt
        mov lr, r3
        @dcw $F800
    cmp r0, #0
    beq non
    
got
    ldr r0, =$0803678e ;continue
    b end
non:
    ldr r0, =$0803679a ;end
end:
    pop {r2, r3}
    mov pc, r0
@ltorg
adr: