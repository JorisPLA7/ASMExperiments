# ASMExperiments
ARM ASM codes for simple images transformation

# Usage

Made to be compiled and used with https://wiki.debian.org/ArmEabiPort

## transformer executable : 

Transformation d'une image bitmap
A chaque changement d'image :

  1) /bin/rm image_test.bm; ln -s votre_image.bm image_test.bm
  2) Recompiler : make 
  3) Execution : 
                
         ./transformer option
  
         ./transformer n : negatif
        
         ./transformer h : symetrie horizontale
       
         ./transformer v : symetrie verticale
       
         ./transformer nv : negatif + symetrie verticale
       
         ./transformer hv : rotation = double symetrie
       



# Creators:
- Joris Placette - joris@placette.fr
- Elios Vergely
