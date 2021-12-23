vsim work.bus_controller
# Waves
add wave -position end  sim:/bus_controller/w_en
add wave -position end  sim:/bus_controller/r_en
add wave -position end  sim:/bus_controller/w_sel
add wave -position end  sim:/bus_controller/r_sel
add wave -position end  sim:/bus_controller/rst
add wave -position end  sim:/bus_controller/d_bus; radix signal sim:/bus_controller/d_bus hexadecimal
add wave -position end  sim:/bus_controller/clk
# These don't have to be shown
add wave -position end  sim:/bus_controller/q0; radix signal sim:/bus_controller/q0 hexadecimal
add wave -position end  sim:/bus_controller/q1; radix signal sim:/bus_controller/q1 hexadecimal
add wave -position end  sim:/bus_controller/q2; radix signal sim:/bus_controller/q2 hexadecimal
add wave -position end  sim:/bus_controller/q3; radix signal sim:/bus_controller/q3 hexadecimal
# Init zeros
force -freeze sim:/bus_controller/w_en 0 0
force -freeze sim:/bus_controller/r_en 0 0
force -freeze sim:/bus_controller/w_sel 00 0
force -freeze sim:/bus_controller/r_sel 00 0
force -freeze sim:/bus_controller/rst 1111 0
force -freeze sim:/bus_controller/d_bus X\"00000000\" 0
run
# REQ1: Write these values to each register
force -freeze sim:/bus_controller/rst 0000 0
force -freeze sim:/bus_controller/w_en 1 0
# r0 <= 00AA
force -freeze sim:/bus_controller/w_sel 00 0
force -freeze sim:/bus_controller/d_bus X\"000000AA\" 0
run
# r1 <= 00BB
force -freeze sim:/bus_controller/w_sel 01 0
force -freeze sim:/bus_controller/d_bus X\"000000BB\" 0
run
# r2 <= 00CC
force -freeze sim:/bus_controller/w_sel 10 0
force -freeze sim:/bus_controller/d_bus X\"000000CC\" 0
run
# r2 <= 00DD
force -freeze sim:/bus_controller/w_sel 11 0
force -freeze sim:/bus_controller/d_bus X\"000000DD\" 0
run
# REQ2: Transfer registers' content
noforce sim:/bus_controller/d_bus
force -freeze sim:/bus_controller/r_en 1 0
force -freeze sim:/bus_controller/w_en 1 0
# r1 <= r0: Read r0 to d_bus and write d_bus to r1
force -freeze sim:/bus_controller/r_sel 00 0
force -freeze sim:/bus_controller/w_sel 01 0
run
# r0 <= r2: Read r2 to d_bus and write d_bus to r0
force -freeze sim:/bus_controller/r_sel 10 0
force -freeze sim:/bus_controller/w_sel 00 0
run
# r0 <= r3: Read r3 to d_bus and write d_bus to r0
force -freeze sim:/bus_controller/r_sel 11 0
force -freeze sim:/bus_controller/w_sel 00 0
run
# Read the values from each register to d_bus to verify they were transfered correctly
force -freeze sim:/bus_controller/w_en 0 0
force -freeze sim:/bus_controller/r_en 1 0
# Read r0
force -freeze sim:/bus_controller/r_sel 00 0
run
# Read r1
force -freeze sim:/bus_controller/r_sel 01 0
run
# Read r2
force -freeze sim:/bus_controller/r_sel 10 0
run
# Read r3
force -freeze sim:/bus_controller/r_sel 11 0
run
