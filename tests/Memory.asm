exp1: 0x100
OUT R1
HLT

exp2: 0x150
INC R1
OUT R1
HLT

main: 0x300
ldm R2, 0x19        # R2=19 add 19 in R2
ldm R3, 0xffff        # R3=FFFF
ldm R4, 0xf320        # R4=F320
LDM R1, 0x5     # R1=5
PUSH R1      # SP=FFFFFFFE,M[FFFFFFFF]=5
PUSH R2      # SP=FFFFFFFD,M[FFFFFFFE]=19
POP R1       # SP=FFFFFFFE,R1=19
POP R2       # SP=FFFFFFFF,R2=5
ldm R5, 0x10 # 0xfd60        # R5= 10, you should run this test case another time and load R5 with FD60
STD R2,0x200(R5)   # M[210]=5, Exception in the 2nd run
STD R1,0x201(R5)   # M[211]=19
LDD R3,0x201(R5)   # R3=19
LDD R4,0x200(R5)   # R4=5
POP R3  # exception
ADD R1, R2, R3 # should not execute as their is an exception
hlt
