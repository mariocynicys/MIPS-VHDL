main: 0xa0
SETC           # C --> 1
NOP            # No change
NOT R1         # R1 =FFFF , C--> no change, N --> 1, Z --> 0
INC R1	       # R1 =0000 , C --> 1 , N --> 0 , Z --> 1
in R1   # R1= 5,add 5 on the in port,flags no change	
ldm R2,  0x10  # R2= 10,add 10 on the in port, flags no change
NOT R2	       # R2= FFEF, C--> no change, N -->1,Z-->0
INC R1         # R1= 6, C --> 0, N -->0, Z-->0
OUT R1
OUT R2
HLT
