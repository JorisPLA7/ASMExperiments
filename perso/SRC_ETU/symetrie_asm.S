                                                                                        
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

	@ empile le link register
	push {lr}
	@ On charge l'octet
	ldrb r1, [r0]
	@ comparaison 1
	and r2, r1, #0xF0 
	asr r2, r2, #4  @ on garde le bit de signe
	and r3, r1, #0x0F 
	lsl r3, r3, #4
	orr r1, r2, r3 
	@ comparaison 2
	and r2, r1, #0xCC 
	asr r2, r2, #2  @ on garde le bit de signe
	and r3, r1, #0x33 
	lsl r3, r3, #2
	orr r1, r2, r3 
	@ comparaison 3
	and r2, r1, #0xAA 
	asr r2, r2, #1  @ on garde le bit de signe
	and r3, r1, #0x55 
	lsl r3, r3, #1
	orr r1, r2, r3 

	strb r1, [r0]

	@ depile le link register
	pop {lr}
	bx lr                                                                     
#else  // SYMTAB                                                                        
                                                                                        
@ Version tabulée                                                                       
symetrie_octet:    
	@ empile le link register
	push {lr}
	@ On charge l'octet
	ldrb r1, [r0]
	@ On trouve son symetrique 
	ldr r2, adr_tabsym
	ldrb r1, [r2, r1]
	@ On stock l'octet
	strb r1, [r0]
	@ dépile le link register
	pop {lr}
	bx lr
                                                                     
#endif  // SYMTAB                                                                       
#endif  // C_SYMETRIE_OCTET                                                             
@ r0 : parametre tab                                                                    
@ r1 : parametre col                                                                    
                                                                                        
#ifndef C_PERMUTER_COLS                                                                 

@ permuter_cols:                                                                          

@ 	@ empile le link register
@ 	push {lr}
@ 	@ On calcule l'indice du tableau
@ 	ldr r2, adr_bytes_per_line
@ 	sub r2, #1
@ 	sub r2, r1
@ 	@ On charge la valeur a l'indice du tableau 1
@ 	ldrb r3, [r0, r2]
@ 	@ On charge la valeur a l'indice du tableau 2
@ 	ldrb r4, [r0, r1]
@ 	@ On permute ces deux valeurs
@ 	strb r4, [r0, r2]
@ 	strb r3, [r0, r1]
@ 	@ dépile le link register
@ 	pop {lr}
@ 	bx lr

permuter_cols:

	@ empile le link register
	push {lr}
    
    @ tmp = tab[BYTES_PER_LINE -1 - col];
    ldrb r2, adr_bytes_per_line
    add r3, r2, r0
    sub r3, r3, #1
    sub r3, r3, r1
    ldrb r5, [r3]

    @ tab [BYTES_PER_LINE -1 - col] = tab [col];
    add r4, r0, r1
    ldrb r6, [r4]
    strb r5, [r4]
    
    @ tab[col] = tmp;
    strb r6, [r3]

    @ dépile le link register
	pop {lr}
	bx lr
                                                                          
#endif // C_PERMUTER_COLS                                                               
                                                                                    
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef C_SYMETRIE_AXE_V                                                                
                  

symetrie_axe_v:                                                                         

	@ empile le link register
	push {lr}
	@ On charge les constantes
	ldr r5, adr_bytes
	ldr r6, adr_height
	ldr r7, adr_bytes_per_line
	lsr r8, r7, #1
	@ On sauvegarde l'adresse de l'image
	mov r9, r0
	@ iterateur à 0
	mov r4, #0

	@ inversion de l'ordre des bits de chaque byte de données
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


    @ RAZ valeurs
	mov r5, #0
	@ symétrie de l'agencement des bytes en symétrie verticale 
	for_vertical : 
		cmp r5, r6 
		bge end_for_vertical
		@ On calcule l'indice
		mul r0, r5, r7
		add r0, r9
		@ RAZ iterateur boucle	
		mov r10, #0

		@ échange des bytes 
		for_vertical_elements :
			cmp r10, r8 
			bge end_for_vertical_elements
			@ Et on permute les colonnes
			mov r1, r10
			bl permuter_cols
			add r10, #1
			b for_vertical_elements
		end_for_vertical_elements :	

		@itération memoire et compteur, on avance d'une ligne
		add r5, #1
		b for_vertical
	end_for_vertical :
	@ On recupere l'adresse de l'image
	mov r0, r9
	@ dépile le link register
	pop {lr}
	bx lr



@ symetrie_axe_v:                                                                         

@ 	@ empile le link register
@ 	push {lr}
@ 	@ On charge les constantes
@ 	ldr r7, adr_bytes_per_line
@ 	lsr r8, r7, #1
@ 	ldr r6, adr_height
@ 	ldr r5, adr_bytes
@ 	@ On sauvegarde l'adresse de l'image
@ 	mov r3, r0
@ 	@ iterateur à 0
@ 	mov r4, #0
@ 	@ symétrie du contenu des bytes
@ 	for_bytes : 
@ 		cmp r4, r5 
@ 		bge end_for_bytes
@         bl symetrie_octet
@         add r0, #1
@         add r4, #1

@         b for_bytes
@     end_for_bytes:

@     @ RAZ valeurs
@     mov r3, r0
@ 	mov r5, #0
@ 	@ symétrie de l'agencement des bytes
@ 	for_vertical : 
@ 		cmp r5, r6 
@ 		bge end_for_vertical
		
@ 		mov r1, #0
@ 		@ symétrie des bytes d'une ligne
@ 		for_vertical_elem :
@ 			cmp r1, r8 
@ 			bge end_for_vertical_elem
@ 			@ échange d'un doublet de byte
@ 			bl permuter_cols
@ 			add r1, #1
@ 			b for_vertical_elem
@ 		end_for_vertical_elem :	
@ 		@itération memoire et compteur, on avance d'une ligne
@ 		add r5, #1
@ 		add r0, r7
@ 		b for_vertical
@ 	end_for_vertical :
		
@     mov r0, r3
@     @ dépile le link register
@ 	pop {lr}
@ 	bx lr


#endif // C_SYMETRIE_AXE_V                                                              
@ r0 : tab                                                                              
@ r1 : li                                                                               
                                                                                        
#ifndef C_PERMUTER_LIGNES                

permuter_lignes:                                                                        
	
	@ empile le link register
	push {lr}
	ldr r3, adr_bytes_per_line
	mul r2, r3, r1
	@ r2 <=> mem shift entre r0 et la ligne li, [li]
	ldr r5, adr_height
	sub r5, r1
	sub r5, #1
	mul r5, r3
	@r5 <=> mem shift entre r0  et la ligne HEIGHT - li, [HEIGHT -1 - li]
	
	@lecture des données
	ldrb r4, [r0, r2]
	ldrb r6, [r0, r5] 
	@écriture des données
	strb r6, [r0, r2] 
	strb r4, [r0, r5] 
	@ dépile le link register
	pop {lr}
	bx lr

@Version fonctionnelle toute seule mais incompatible avec sym h ASM perso
@ permuter_lignes:

@ 	@ empile le link register
@ 	push {lr}
@ 	@squvegarde adr tableau
@ 	mov r9, r0
@ 	@chargement des constantes
@ 	ldr r2, adr_bytes_per_line
@ 	ldr r4, adr_height

@ 	@calcul des adresses
@ 	mul r3, r1, r2
@ 	add r0, r0, r3
@ 	@[r0] <=> tab[li][0]
@ 	mul r5, r4, r2
@ 	add r5, r5, r9
@ 	sub r5, r5, #1
@ 	sub r5, r5, r3
@ 	@[r5] <=> tab[HEIGHT -1 -li]

@ 	@lecture et ecriture données
@ 	ldrb r6, [r0]
@ 	ldrb r7, [r5]
@ 	strb r6, [r5]
@ 	strb r7, [r0]

@ 	@ dépile le link register
@ 	pop {lr}
@ 	bx lr

                                                                                        
#endif // C_PERMUTER_LIGNES                                                             
                                                                                        
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef  C_SYMETRIE_AXE_H                                                               

symetrie_axe_h:                                                                         

	@ empile le link register
	push {lr}
	@ On initialise les constantes et la boucle 
	ldr r8, adr_height
	lsr r8, #1
	ldr r7, adr_bytes_per_line
	mov r1, #0
	mov r9, r0
	@ parcours des height/2 premières lignes
	for_lines :
		cmp r1, r8
		bge end_for_lines
		@ symétrie des bytes des lignes
		mov r0, r9
		mov r10, #0
		for_lines_elements :
			cmp r10, r7
			bge end_for_lines_elements
			@ échange d'un doublet de bytes
			bl permuter_lignes
			add r0, #1
			add r10, #1
			b for_lines_elements
		end_for_lines_elements :
		add r1, #1
		b for_lines
	end_for_lines :	
	@ restaure r0
	mov r0, r9
	@ dépile le link register
	pop {lr}
	bx lr
	
                                                           
#endif   // C_SYMETRIE_AXE_H    


adr_tabsym : .word tabsym_octet
adr_bytes_per_line : .word BYTES_PER_LINE
adr_bytes : .word BYTES
adr_height : .word HEIGHT
adr_width : .word WIDTH
                                                        
