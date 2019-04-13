                                                                                        
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

symetrie_octet:                                                                         

	@ On sauvegarde l'appelant
	push {lr}
	@ On charge l'octet
	ldrb r1, [r0]
	@ Premiere comparaison
	and r2, r1, #0xF0 
	asr r2, r2, #4  @ on garde le bit de signe
	and r3, r1, #0x0F 
	lsl r3, r3, #4
	orr r1, r2, r3 
	@ Seconde comparaison
	and r2, r1, #0xCC 
	asr r2, r2, #2  @ on garde le bit de signe
	and r3, r1, #0x33 
	lsl r3, r3, #2
	orr r1, r2, r3 
	@ Troisieme comparaison
	and r2, r1, #0xAA 
	asr r2, r2, #1  @ on garde le bit de signe
	and r3, r1, #0x55 
	lsl r3, r3, #1
	orr r1, r2, r3 
	@ On stock l'octet
	strb r1, [r0]
	@ On retourne a l'appelant
	pop {lr}
	bx lr
                                                                                        
#else  // SYMTAB                                                                        


                                                                                        
@ Version tabulée                                                                       

symetrie_octet:                                                                         

	@ On sauvegarde l'appelant
	push {lr}
	@ On charge l'octet
	ldrb r1, [r0]
	@ On trouve son symetrique 
	ldr r2, adr_tabsym
	ldrb r1, [r2, r1]
	@ On stock l'octet
	strb r1, [r0]
	@ On retourne a l'appelant
	pop {lr}
	bx lr

#endif  // SYMTAB                                                                       
#endif  // C_SYMETRIE_OCTET                                                             



@ r0 : parametre tab                                                                    
@ r1 : parametre col                                                                    
                                                                                        
#ifndef C_PERMUTER_COLS                                                                 
                                                                                        
permuter_cols:                                                                          

	@ On sauvegarde l'appelant
	push {lr}
	@ On calcule l'indice du tableau
	ldr r2, adr_bytes_per_line
	sub r2, #1
	sub r2, r1
	@ On charge la valeur a l'indice du tableau 1
	ldrb r3, [r0, r2]
	@ On charge la valeur a l'indice du tableau 2
	ldrb r4, [r0, r1]
	@ On permute ces deux valeurs
	strb r4, [r0, r2]
	strb r3, [r0, r1]
	@ On retourne a l'appelant
	pop {lr}
	bx lr

#endif // C_PERMUTER_COLS                                                               
                                                                                        


@ r0 : paramètre image                                                                  
                                                                                        
#ifndef C_SYMETRIE_AXE_V                                                                

symetrie_axe_v:                                                                         

	@ On sauvegarde l'appelant
	push {lr}
	@ On charge les constantes
	ldr r5, adr_bytes
	ldr r6, adr_height
	ldr r7, adr_bytes_per_line
	lsr r8, r7, #1
	@ On sauvegarde l'adresse de l'image
	mov r9, r0
	@ On initialise la premiere boucle for
	mov r4, #0
	@ Puis on la commence
	for_bytes : 
		cmp r4, r5 
		bge end_for_bytes
		@ On calcule l'indice
		add r0, #1
		@ Et on calcule le symetrique
		bl symetrie_octet 
		add r4, #1
		b for_bytes
	end_for_bytes :
	@ On initialise la premiere boucle for
	mov r5, #0
	@ Puis on la commence
	for_height : 
		cmp r5, r6 
		bge end_for_height
		@ On calcule l'indice
		mul r0, r5, r7
		add r0, r9
		@ Puis on initialise une nouvelle boucle
		mov r10, #0
		@ Puis on la commence
		for_bytes_per_line :
			cmp r10, r8 
			bge end_for_bytes_per_line
			@ Et on permute les colonnes
			mov r1, r10
			bl permuter_cols
			add r10, #1
			b for_bytes_per_line
		end_for_bytes_per_line :	
		add r5, #1
		b for_height
	end_for_height :
	@ On recupere l'adresse de l'image
	mov r0, r9
	@ On retourne a l'appelant
	pop {lr}
	bx lr

                                                                                        
#endif // C_SYMETRIE_AXE_V                                                              



@ r0 : tab                                                                              
@ r1 : li                                                                               
                                                                                        
#ifndef C_PERMUTER_LIGNES                                                               

permuter_lignes:                                                                        
	
	@ On sauvegarde l'appelant
	push {lr}
	@ On charge tmp
	ldr r2, adr_bytes_per_line
	mul r3, r2, r1
	ldrb r4, [r0, r3]
	@ Et l'autre valeur
	ldr r5, adr_height
	sub r5, r1
	sub r5, #1
	mul r5, r2
	ldrb r6, [r0, r5] 
	@ On les permute
	strb r4, [r0, r5] 
	strb r6, [r0, r3] 
	@ On retourne a l'appelant
	pop {lr}
	bx lr

#endif // C_PERMUTER_LIGNES                                                             
                                                                                        


@ r0 : paramètre image                                                                  
                                                                                        
#ifndef  C_SYMETRIE_AXE_H                                                               

symetrie_axe_h:                                                                         

	@ On sauvegarde l'appelant
	push {lr}
	@ Et r0
	mov r9, r0
	@ On initialise les constantes et la boucle 
	ldr r7, adr_bytes_per_line
	ldr r8, adr_height
	lsr r8, #1
	mov r1, #0
	@ On la demarre
	for_height_2 :
		cmp r1, r8
		bge end_for_height_2
		@ On initialise la seconde boule
		mov r10, #0
		mov r0, r9
		for_bytes_per_line_2 :
			cmp r10, r7
			bge end_for_bytes_per_line_2
			bl permuter_lignes
			add r10, #1
			add r0, #1
			b for_bytes_per_line_2
		end_for_bytes_per_line_2 :
		add r1, #1
		b for_height_2
	end_for_height_2 :	
	@ On recupere r0
	mov r0, r9
	@ On retourne a l'appelant
	pop {lr}
	bx lr
	
                                                                                        
#endif   // C_SYMETRIE_AXE_H                                                            



adr_tabsym : .word tabsym_octet
adr_bytes_per_line : .word BYTES_PER_LINE
adr_bytes : .word BYTES
adr_height : .word HEIGHT
adr_width : .word WIDTH
