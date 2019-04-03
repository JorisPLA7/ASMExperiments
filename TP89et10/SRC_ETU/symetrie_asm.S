                                                                                        
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE          
#include "image_bits_include.h"                                                         
                                                                                        
                 .global symetrie_octet                                                 
                 .global permuter_cols                                                  
                 .global symetrie_axe_v                                                 
                 .global permuter_ligne                                                 
                 .global symetrie_axe_h                                                 
                 .global symetrie_axe_h                                                 
                 .global permuter_lignes                                                
                 .global symetrie_axe_v                                                 
                                                                                        
                 .text                                                                  
                                                                                        
@ r0 : parametre reçu adresse                                                           
@ r1 : variable locale octet                                                            

#ifndef C_SYMETRIE_OCTET                                                                
#ifndef SYMTAB                                                                          
                                                                                        
@  Version avec opérations bit à bit                                                    
                                                                                        
symetrie_octet: rbit r0, r0
		bx lr                                                                      
                                                                                        
@ Version tabulée                                                                       
symetrie_octet:                                                                         
#endif  // SYMTAB                                                                       
#endif  // C_SYMETRIE_OCTET                                                             
@ r0 : parametre tab                                                                    
@ r1 : parametre col                                                                    
                                                                                        
#ifndef C_PERMUTER_COLS                                                                 
                                                                                        
permuter_cols:                                                                          
#endif // C_PERMUTER_COLS                                                               
                                                                                        
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef C_SYMETRIE_AXE_V                                                                
symetrie_axe_v:                                                                         
                                                                                        
#endif // C_SYMETRIE_AXE_V                                                              
@ r0 : tab                                                                              
@ r1 : li                                                                               
                                                                                        
#ifndef C_PERMUTER_LIGNES                                                               
permuter_lignes:

debutForLigne:	mov r3, #0
		mov r1, #HEIGHT
		mov r2, #WIDTH
		mul r4, r2, r1
		sub r4, r4, #1
		add r4, r4, r0
		
		cmp r3, #BYTES_PER_LINE
		beq finForLigne
		
                
		ldrb r5, [r8]			@load octet du tableau
		mvn r5, r5			@Complément à 1 de l'octet 
ecrireDonnees:  strb r5, [r8]			@ecriture de l'octet


		add r8, r8, #1 @aller addr suivante
	  	add r3, r3, #1 @+1 iterateur case tableau
		b debutFor

	
finForLigne: bx lr 
                
		                                                                    
                                                                                        
#endif // C_PERMUTER_LIGNES                                                             
                                                                                        
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef  C_SYMETRIE_AXE_H                                                               
symetrie_axe_h:                                                                         
                                                                                        
#endif   // C_SYMETRIE_AXE_H                                                            
