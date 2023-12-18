.3ds
.open "code.bin", "build/patched_code.bin", 0x100000

; general
frd_handle equ 0x3FD938
local_account_id equ 0x3FD93C

; der certs
get_service_handle equ 0x196188

add_default_cert_cave equ 0x176F28
add_default_cert_cave_end equ 0x176F90

main_der_cert_address equ 0x3F8180 ; alt cert address + 2000
alt_der_cert_address equ 0x3F79B0

; pem certs
load_cave_pem equ 0x1E3210
main_cave_pem_string equ 0x1E3468

; mounting
mount_hooks_address equ 0x38DA90

mount_content_cfa equ 0x1D7CF4
unmount_romfs equ 0x1D8058

mount_archives equ 0x1D7FF8
unmount_archives equ 0x1D80EC

mount_sd equ 0x1B2B20
unmount_archive equ 0x232748

sdmc_string equ 0x1D819C

; discovery
discovery_jump_address equ 0x157320
main_discovery_string equ 0x15748C

.include "src/discovery.s"
.include "src/extra.s"
.include "src/pemcerts.s"
.include "src/dercerts.s"

.close