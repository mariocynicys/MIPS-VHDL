vsim work.bus_controller
# Waves
add wave -position end  sim:/bus_controller/w_en
add wave -position end  sim:/bus_controller/r_en
add wave -position end  sim:/bus_controller/w_sel
add wave -position end  sim:/bus_controller/r_sel
add wave -position end  sim:/bus_controller/rst
add wave -position end  sim:/bus_controller/mem_adrs; radix signal sim:/bus_controller/mem_adrs unsigned
add wave -position end  sim:/bus_controller/d_bus; radix signal sim:/bus_controller/d_bus hexadecimal
add wave -position end  sim:/bus_controller/clk
# These don't have to be shown
add wave -position end  sim:/bus_controller/q0; radix signal sim:/bus_controller/q0 hexadecimal
add wave -position end  sim:/bus_controller/q1; radix signal sim:/bus_controller/q1 hexadecimal
add wave -position end  sim:/bus_controller/q2; radix signal sim:/bus_controller/q2 hexadecimal
add wave -position end  sim:/bus_controller/q3; radix signal sim:/bus_controller/q3 hexadecimal
add wave -position end  sim:/bus_controller/q4; radix signal sim:/bus_controller/q4 hexadecimal
# Init the memory
mem load -skip 0 -filltype dec -filldata 2BC -fillradix hexadecimal /bus_controller/m0/ram
# 1) Init zeros and reset
force -freeze sim:/bus_controller/w_en 1 0
force -freeze sim:/bus_controller/r_en 1 0
force -freeze sim:/bus_controller/w_sel 00 0
force -freeze sim:/bus_controller/r_sel 00 0
force -freeze sim:/bus_controller/rst 11111 0
force -freeze sim:/bus_controller/d_bus X\"00000000\" 0
run
# Unset the reset & unforce the data bus
force -freeze sim:/bus_controller/rst 00000 0
noforce sim:/bus_controller/d_bus
run
# Set the memory reset because we need the memory address at 10
force -freeze sim:/bus_controller/rst 10000 0
# 2) r0 <= mem[10]
force -freeze sim:/bus_controller/r_en 0 0
force -freeze sim:/bus_controller/w_en 1 0
force -freeze sim:/bus_controller/w_sel 00 0
run
# Unset the memory reset so that the next memory address becomes 9
force -freeze sim:/bus_controller/rst 00000 0
# 3) r1 <= mem[9]
force -freeze sim:/bus_controller/r_en 0 0
force -freeze sim:/bus_controller/w_en 1 0
force -freeze sim:/bus_controller/w_sel 01 0
run
# 4) r3 <= r0
force -freeze sim:/bus_controller/r_en 1 0
force -freeze sim:/bus_controller/r_sel 00 0
force -freeze sim:/bus_controller/w_en 1 0
force -freeze sim:/bus_controller/w_sel 11 0
run
# 5) mem[7] <= r1
force -freeze sim:/bus_controller/r_en 1 0
force -freeze sim:/bus_controller/r_sel 01 0
force -freeze sim:/bus_controller/w_en 0 0
run
