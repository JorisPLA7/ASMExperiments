                                                                                      
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE        
#include "image_bits_include.h"                                                       
										      
                                                                                      
                 .text                                                                
                                                                                      
@ r0 : parametre octet                                                                
                                                                                      
#ifndef C_NEG_OCTET                                                                   
                 .global neg_octet                                                    
                                                                                      
neg_octet:
	push {lr}
	ldrb r1, [r0]
	mvn r1, r1 
	strb r1, [r0]
	pop {lr}
	bx lr
                                                                            
                                                                                      
#endif // C_NEG_OCTET                                                                 
                                                                                      
#ifndef C_NEG_IMAGE                                                               
                 .global neg_image                                                    
@ r0 : parametre recu image                                                           
                                                                                      
                                                                                      
neg_image:                                                                            

	push {lr}

	ldr r2, adr_bytes
	add r3, r0, r2
	mov r4, r0

	tq :
		cmp r0, r3
		bge fin_tq
		bl neg_octet
		add r0, #1
		b tq
	fin_tq :
	
	mov r0, r4                                                                    
	pop {lr}
	bx lr
                                                                                      
adr_bytes:	.word BYTES                                                           
#endif // C_NEG_IMAGE                                                                 
