#include "image_bits_include.h"                                         
                                                                        
	.data                                                                        

		         .balign 4                                               
define_width :   .asciz "\n#define width %d\n"
define_height:   .asciz "#define height %d\n\n"
declaration  :   .asciz "static unsigned char bits[] = {\n"
pixel:			 .asciz "0x%02x"
virgule:		 .asciz ", "
retour_ligne:	 .asciz "\n"
fin_declaration: .asciz "};\n"

#ifndef C_AFFICHER_CONTENU                                              

	.text  
	.global  afficher_contenu                               
                                                                        
afficher_contenu:
	push {lr}
	@ Charge cste BYTES
	ldr r5, adr_bytes
	@ Charge cste WIDTH
    ldr r6, adr_width
	@ Charge cste HEIGHT
    ldr r7, adr_height
	@ Charge cste LINE_LENGTH
    mov r8, #12
	@ Copie l'adresse de debut du bitmap
	mov r9, r0
	@ Initialise i et position
	@ Affichage define width
	ldr r0, adr_define_width
	mov r1, r6
	bl afficher_entier
	@ Affichage define height
	ldr r0, adr_define_height
	mov r1, r7
	bl afficher_entier
	@ Affichage de la declaration du tableau de couleur/pixels
	ldr r0, adr_declaration
	bl afficher_chaine

	mov r2,#0
	mov r3, r8

    tant_que:
		cmp r2, r5
		bge fin_tq
		@ Affichage de la couleur du pixel
		sub r3, #1
		ldr r0, adr_pixel
		ldrb r1,[r9]

		push {r1-r5}
		bl afficher_entier   
		pop {r1-r5}
			
		si :
			mov r4, r5
			sub r4, #1
			cmp r2, r4
			beq fin_si

			@ Affichage de la virgule
			ldr r0, adr_virgule
			push {r1-r5}
			bl afficher_chaine 
			pop {r1-r5}
      
		fin_si:
     
		si2:
			cmp r3, #0
			bne fin_si2
			
			@ Affichage du retour a la ligne
			ldr r0, adr_retour_ligne
			push {r1-r5}
			bl afficher_chaine
			pop {r1-r5}
			mov r3, r8
       
		fin_si2:
		
		add r9, #1
		add r2, #1
		b tant_que
      
      
	fin_tq:
	
	@ Affichage de la fin de la declaration
	ldr r0, adr_fin_declaration
	push {r1-r5}
	bl afficher_chaine
	pop {r1-r5}
	mov r0,r9
	pop {lr}
    bx lr  
@ Constantes      
adr_bytes:			  .word BYTES 
adr_width:			  .word WIDTH 
adr_height:			  .word HEIGHT
@ Chaines
adr_define_width :    .word define_width
adr_define_height :   .word define_height
adr_declaration:	  .word declaration 
adr_pixel:			  .word pixel 
adr_virgule :		  .word virgule
adr_retour_ligne :	  .word retour_ligne
adr_fin_declaration : .word fin_declaration
#endif   // C_AFFICHER_CONTENU                                          
