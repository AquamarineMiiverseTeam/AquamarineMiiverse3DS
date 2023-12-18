.org discovery_jump_address
	discovery_jump:
		bl		discovery_hook	// jump to our hook function
		mov		r0, r8			// copy r8 back into r0 because r0 got nuked
	
.org main_discovery_string
	.asciiz "https://discovery.olv.pretendo.cc/v1/endpoint"