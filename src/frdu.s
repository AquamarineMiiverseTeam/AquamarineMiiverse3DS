get_local_account_id:
	push    {r1, r2, r4, r11, lr}

	; we have to cache the local account id on memory
	; or the frd sysmodule will hang when trying to perform
	; a request due to call recursion
	ldr     r0, =local_account_id      ; load account id address to r0
	ldr     r0, [r0]                   ; load account id
	cmn     r0, #0                     ; check if r0 has a value
	bne     get_local_account_id_end   ; if it does, return it

	bl      get_frd_u_handle           ; get the frd_handle

	; first we use the SetClientSdkVersion command, or this wont work
	mrc     p15, 0x0, r4, c13, c0, 0x3 ; get our thread local storage and store it in r4
	ldr     r0, =0x00320042            ; load frd:u SetClientSdkVersion header into r0
	str     r0, [r4, #0x80]!           ; set cmdbuf[0] to our cmdhdr from r0
	ldr     r0, =0x70000C8             ; set sdk version, same as nimbus
	str     r0, [r4, #0x4]             ; set cmdbuf[1] to the sdk version
	mov     r0, 32                     ; set placeholder kernel process id
	str     r0, [r4, #0x8]             ; set cmdbuf[2] to the placeholder process id
	ldr     r0, =frd_handle            ; load frd_handle address to r0
	ldr     r0, [r0]                   ; load frd_handle
	swi     0x32                       ; send the request

	; now, we can make the request for the local account id
	mrc     p15, 0x0, r4, c13, c0, 0x3 ; get our thread local storage and store it in r4
	ldr     r0, =0x000B0000            ; load frd:u GetMyLocalAccountId header into r0
	str     r0, [r4, #0x80]!           ; set cmdbuf[0] to our cmdhdr from r0
	ldr     r0, =frd_handle            ; load frd_handle address to r0
	ldr     r0, [r0]                   ; load frd_handle
	swi     0x32                       ; send the request
	cmn     r0, #0                     ; check if r0 is negative
	bmi     get_local_account_id_clear ; if it is, go to the clear label to return 0
	ldr     r2, [r4, #0x4]             ; load result into r2
	cmn     r2, #0                     ; check if r2 is negative
	bmi     get_local_account_id_clear ; if it is, go to the clear label to return 0
	ldr     r0, [r4, #0x8]             ; get our localAccountId from cmdbuf[2] to return and store it in r0
	ldr     r1, =local_account_id      ; load account id address to r1
	str     r0, [r1]                   ; store the local account id to memory
	b       get_local_account_id_end   ; jump to the end
	
get_local_account_id_clear: ; 0x1ade0
	mov     r0, #0
	
get_local_account_id_end: ; 0x1adec
	pop     {r1, r2, r4, r11, lr}
	bx      lr
	
get_frd_u_handle: ; 0x1adf4
	push    {r1, r11, lr}

	ldr     r0, =frd_handle            ; load frd_handle address to r0
	ldr     r1, =frdu_name             ; load frdu name into r1
	bl      get_service_handle         ; get frd_handle

	pop     {r1, r11, lr}
	bx      lr