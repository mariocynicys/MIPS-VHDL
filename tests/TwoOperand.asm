main: 0xff
ldm R1, 0x5        # add 5 in R1
ldm R2, 0x19        # add 19 in R2
ldm R3, 0xffff       # FFFF
ldm R4, 0xf320       # F320
MOV R3,R5    # R5 = FFFF , flags no change 770
ADD R4,R1,R4    # R4= F325 , C-->0, N-->1, Z-->0 870
SUB R6,R5,R4    # R6= 0CDA , 970 C-->0, N-->0,Z-->0 here carry is implemented as borrow you can implement it as not borrow
AND R4,R7,R4    # R4= 0000 , C-->no change, N-->0, Z-->1 1070
IADD R2,R2,0xFFFF # R2= 0018 (C = 1,N,Z= 0) 1170
ADD R2,R1,R2    # R2= 001D (C,N,Z= 0) 1270
hlt
