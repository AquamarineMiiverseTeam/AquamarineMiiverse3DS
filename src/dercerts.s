; include the main der cert
.org main_der_cert_address
	main_der_cert_start:
		.incbin    "rootcajuxt.der"
	main_der_cert_end:
	
; include the alt der cert
.org alt_der_cert_address
	alt_der_cert_start:
		.incbin    "rootcaaquamarine.der"
	alt_der_cert_end:
	
; sizeof max 26 instructions
; r0, r1, r4, r8
; adds root certificate
.org add_default_cert_cave
	add_root_cert:
		ldr     r0, =0x00240082             ; httpC:AddRootCA
		mrc     p15, 0x0, r4, c13, c0, 0x3  ; TLS
		ldr     r1, [r5, #0xC]              ; load HTTPC handle
		ldr     r8, [r5, #0x14]             ; load httpC handle
		str     r0, [r4, #0x80]!            ; store cmdhdr in cmdbuf[0]
		str     r1, [r4, #4]                ; store HTTPC handle in cmdbuf[1]
		mov     r0, r8                      ; move httpC handle to r0 for SVC SendSyncRequest
		ldr     r8, =main_der_cert_end-main_der_cert_start
		ldr     r1, =main_der_cert_start
		bl		local_account_id_is_pretendo
		blne	set_alt_der_cert
		str     r8, [r4, #8]                ; store cert size in cmdbuf[2]
		str     r1, [r4, #16]               ; store cert bufptr in cmdbuf[4]
		mov     r8, r8, lsl #4              ; size <<= 4
		orr     r8, r8, #0xA                ; size |= 0xA
		str     r8, [r4, #12]               ; store translate header in cmdbuf[3]
		swi     0x32                        ; finally do the request
		nop
		b       add_default_cert_cave_end   ; jump past the pool
		.pool
		nop