; mount sdmc
.org mount_archives
	b mount_hook

; unmount sdmc
.org unmount_archives
	b unmount_hook
	
; hooks for mounting stuff
.org mount_hooks_address

; mounting
	mount_hook:
        push	{lr}
        bl		mount_content_cfa
        ldr		r0, =sdmc_string
        pop		{lr}
        b		mount_sd
    unmount_hook:
        push	{lr}
        bl		unmount_romfs
        ldr		r0, =sdmc_string
        pop		{lr}
        b		unmount_archive
		.pool

; discovery
	discovery_hook:
		push	{r8, lr}
		ldr		r2, =alt_discovery_string
		bl		local_account_id_is_pretendo
		beq		discovery_hook_load_main
		b		discovery_hook_end
	discovery_hook_load_main:
		ldr		r2, =main_discovery_string
	discovery_hook_end:
		pop		{r8, lr}
		bx		lr
		
; der certs
	.include "src/frdu.s"
	
	; sets compare flags and returns
	local_account_id_is_pretendo:
		push 	{r0, lr}
		bl		get_local_account_id
		cmp		r0, #2
		pop		{r0, lr}
		bx		lr

	; loads length and start addresses of alt der cert into r8 and r1
	set_alt_der_cert:
		push	{lr}
		ldr     r8, =alt_der_cert_end-alt_der_cert_start
		ldr     r1, =alt_der_cert_start
		pop		{lr}
		bx		lr

; pem certs
	load_cave_pem_hook:
		push	{r0, lr}
		ldr		r4, =alt_cave_pem_string
		bl		local_account_id_is_pretendo
		beq		load_cave_pem_hook_main
		b		load_cave_pem_hook_end
	load_cave_pem_hook_main:
		ldr		r4, =main_cave_pem_string
	load_cave_pem_hook_end:
		pop		{r0, lr}
		bx		lr

; data
	.pool

	frdu_name:
		.asciiz "frd:u"
		
	alt_discovery_string:
		.asciiz "https://disc.olv.nonamegiven.xyz/v1/endpoint"
		
	alt_cave_pem_string:
		.asciiz "3ds/aquamarine.pem"