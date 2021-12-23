
vsim -gui work.alu
# vsim -gui work.alu 
# Start time: 15:26:36 on Oct 25,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.alu(struct)
# Loading work.parta(archa)
# Loading work.my_nadder(a_my_nadder)
# Loading work.my_adder(a_my_adder)
# Loading work.partb(archb)
# Loading work.partc(archc)
# Loading work.partd(archd)
add wave -position insertpoint sim:/alu/*
force -freeze sim:/alu/A x\"0f0f\" 0
force -freeze sim:/alu/sel 0000 0
force -freeze sim:/alu/Cin 0 0
run
force -freeze sim:/alu/B x\"0001\" 0
force -freeze sim:/alu/sel 0001 0
run
force -freeze sim:/alu/A x\"ffff\" 0
run
force -freeze sim:/alu/sel 0010 0
run
force -freeze sim:/alu/sel 0011 0
run
force -freeze sim:/alu/sel 0000 0
force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/A x\"0f0e\" 0
run
force -freeze sim:/alu/sel 0001 0
force -freeze sim:/alu/A x\"ffff\" 0
run
force -freeze sim:/alu/sel 0010 0
force -freeze sim:/alu/A x\"0f0f\" 0
run
force -freeze sim:/alu/sel 0011 0
run
force -freeze sim:/alu/sel 0100 0
force -freeze sim:/alu/B x\"000a\" 0
run
force -freeze sim:/alu/sel 0101 0
run
force -freeze sim:/alu/sel 0110 0
run
force -freeze sim:/alu/sel 0111 0
run
force -freeze sim:/alu/sel 1000 0
run
force -freeze sim:/alu/sel 1001 0
run
force -freeze sim:/alu/sel 1111 0
run
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/sel 1010 0
run
force -freeze sim:/alu/Cin 1 0
run
force -freeze sim:/alu/sel 1100 0
run
force -freeze sim:/alu/sel 1101 0
force -freeze sim:/alu/A x\"f0f0\" 0
run
force -freeze sim:/alu/sel 1101 0
run
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/sel 1110 0
run
force -freeze sim:/alu/Cin 1 0
run
force -freeze sim:/alu/sel 1011 0
run
