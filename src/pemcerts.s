.org load_cave_pem + 0x8
	bl load_cave_pem_hook

; patch type to 1 (sdmc) instead of 5 (content:)
.org load_cave_pem + 0x14
	mov r2, #0x1
	
; set certificate location
.org main_cave_pem_string
	.asciiz "3ds/juxt-prod.pem"