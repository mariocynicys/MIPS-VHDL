int1: 0x2000
inv
rti          # POP PC and flags restored


main: 0x10
ldm R1, 0x30     # R1=30
ldm R2, 0x50     # R2=50
ldm R3, 0x100     # R3=100
ldm R4, 0x300     # R4=300
Push R4   # sp=FFFFFFFE, M[FFFFFFFF]=300
INT 0     # SP=FFFFFFFC, M[FFFFFFFD]=half next PC,M[FFFFFFFE]=other half next PC
hlt


func6: 0x3000
out R1, 0x30
out R2, 0x50
out R3, 0x100
out R4, 0x300
ret