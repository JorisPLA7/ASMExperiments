                                                                                      
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE        
#include "image_bits_include.h"                                                       
										      
                                                                                      
                 .text                                                                
                                                                                      
@ r0 : parametre octet 
                                                               
                                                                                      
#ifndef C_NEG_OCTET                                                                   
                 .global neg_octet                                                    
                                                                                      
neg_octet:                                                                            
                                                                                      
#endif // C_NEG_OCTET                                                                 
                                                                                      
#ifndef C_NEG_IMAGE                                                               
                 .global neg_image                                                    
@ r0 : parametre reçu image                                                           
debutTab:    .skip WIDTH*HEIGHT*4 @adresse du debut de tableau                                                                                
                                                                                      
neg_image:	
		@mov r1, r0
		@bl EcrNdecimal32                                                                 
                mov r7, #WIDTH      @ taille de la ligne
                mov r2, #HEIGHT     @ taille de la colonne
                                                        
              
		mov r3, #0          @ iterateur  
                @mov pc, lr    
                mov r8, r0
		mul r4, r7, r2
		sub r4, r4, #1
		
debutFor:	
		cmp r3, r4
		beq finFor
		
                
		ldrb r5, [r8]			@load octet du tableau
		mvn r5, r5			@Complément à 1 de l'octet 
ecrireDonnees:  strb r5, [r8]			@ecriture de l'octet


		add r8, r8, #1 @aller addr suivante
	  	add r3, r3, #1 @+1 iterateur case tableau
		b debutFor

	
finFor: bx lr 
                 
                 
                 
                 
                 
                 
                                                                        
ptr_debutTab : .word debutTab                                                                                      
adr_bytes:	.word BYTES                                                           
#endif // C_NEG_IMAGE                                                                 
