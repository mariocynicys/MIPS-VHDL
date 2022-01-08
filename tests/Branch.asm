int1: 200
AND R0,R0,R0    # N=0,Z=1
OUT R6
RTI          # POP PC and flags restored

int2: 250
SETC
AND R0,R0,R0    # N=0,Z=1
OUT R2
RTI          # POP PC and flags restored

main: 10
IN R1     # R1=30
IN R2     # R2=50
IN R3     # R3=100
IN R4     # R4=300
Push R4   # sp=FFFFFFFE, M[FFFFFFFF]=300
INT 2     # SP=FFFFFFFC, M[FFFFFFFD]=half next PC,M[FFFFFFFE]=other half next PC
JMP R1 
INC R1	  # this statement shouldn't be executed
 
# check flag fowarding  
;.ORG 30 what is thiis??
AND R5,R1,R5   # R5=0 , Z = 1
JZ  R2      # Jump taken, Z = 0
SETC        # this statement shouldn't be executed, C-->1

# check on flag updated on jump
;.ORG 50 what is this???????
JZ R1      # shouldn't be taken
JC R3      # Jump Not taken

# check destination forwarding
NOT R5     # R5=FFFF, Z= 0, C--> not change, N=1
INT 0      # SP=FFFFFFFC, M[FFFFFFFD]=half next PC,M[FFFFFFFE]=other half next PC
IN  R6     # R6=700, flag no change
JN  R6     # jump taken, N = 0
INC R1     # this statement shouldn't be executed
hlt ; end of main

# check on load use
func7: 700
SETC      # C-->1
POP R6    # R6=300, SP=FFFFFFFF
Call R6   # SP=FFFFFFFD, M[FFFFFFFE]=half next PC,M[FFFFFFFF]=other half next PC
INC R6	  # R6=401, this statement shouldn't be executed till call returns, C--> 0, N-->0,Z-->0
NOP
NOP
ret # you need to return

func3: 300
ADD R6,R3,R6 # R6=400
ADD R1,R1,R2 # R1=80, C->0,N=0, Z=0
RET
;SETC  this will not even compile         # this shouldnot be executed

func5: 500
NOP
NOP
ret