                                                                                        
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
                                                    
                                                                                        
#endif // C_PERMUTER_LIGNES                                                             
                                                                                        
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef  C_SYMETRIE_AXE_H                                                               
symetrie_axe_h:	
			push {lr}
			bl EcrNdecimal32                                                                 
			pop {lr}
			
			mov r3 #HEIGHT
			mov r4 #WIDTH
			lsr r5, r4, #1 		@on parcours la moitié des lignes pour ne pas inverser deux fois
			mul r6, r3, r4
			sub r6, r6, #BYTES_PER_LINE
			mov r3, #0          @ iterateur i lignes
			mov r4, #0			@ iterateur j colonnes 
			mov r5, r0

			
debutForH:	
			cmp r3, #HEIGHT
			beq finForH

			mov r4, #0			@RAZ du compteur de colonnes
			b debutForH
appelCopieLigne:
			add r5, r5, #BYTES_PER_LINE
			sub r6, r6, #BYTES_PER_LINE

finForH: bx lr 


debutCopieLigne:
			cmp r4, #BYTES_PER_LINE
			beq finCopieLigne

			ldrb r5, [r5, r4]			@load octet du tableau fin
			ldrb r6, [r6, r4]			@load octet du tableau debut
			strb r5, [r8]			@ecriture de l'octet
			strb r6, [r0]

			add r4, r4, #1
			b debutCopieLigne

finCopieLigne:
			b appelCopieLigne

#endif   // C_SYMETRIE_AXE_H                                                            
symetrie_axe_hv: 
			mov r4, r0
			mov r3, #0
			mov r1, #HEIGHT
			mov r2, #WIDTH
			mul r8, r2, r1				@ taille du tableau en octets
			sub r8, r8, #1

debutForHV: 
			cmp r3, #HEIGHT
			beq finForLigneHV
			
			add r0, r4, r3
			bl symetrie_octet
			
			ldrb r5, [r4, r8]			@load octet du tableau fin
			ldrb r6, [r4, r3]			@load octet du tableau debut
			strb r5, [r8]			@ecriture de l'octet
			strb r6, [r0]

			sub r8, r8, #1 @aller addr suivante
			add r3, r3, #1 		@+1 iterateur case tableau
			b debutForHV

	
finForLigneHV: bx lr 
                
		                