# Start simulating.
vsim work.mips
# Load the memory.
mem load -i ins.mem /mips/fetch_stage/iram/ram
mem load -i mem.mem /mips/memory_stage/ram/inner_ram
# Log everything.
add log -r /*
# Add the clock.
add wave -position end sim:/mips/clk
radix signal sim:/mips/clk bin
# And the reset.
add wave -position end sim:/mips/reset
radix signal sim:/mips/reset bin
# Add the in port.
add wave -position end sim:/mips/in_port
radix signal sim:/mips/in_port hex
# Add the out port.
add wave -position end sim:/mips/out_port
radix signal sim:/mips/out_port hex
# Add the pc signal.
add wave -position end sim:/mips/fetch_stage/pc
radix signal sim:/mips/fetch_stage/pc hex
# Add the exception pc.
add wave -position end sim:/mips/epc
radix signal sim:/mips/epc hex
########333

add wave -position insertpoint sim:/mips/registerread_stage/rf/q0
add wave -position insertpoint sim:/mips/registerread_stage/rf/q1
add wave -position insertpoint sim:/mips/registerread_stage/rf/q2
add wave -position insertpoint sim:/mips/registerread_stage/rf/q3
add wave -position insertpoint sim:/mips/registerread_stage/rf/q4
add wave -position insertpoint sim:/mips/registerread_stage/rf/q5
add wave -position insertpoint sim:/mips/registerread_stage/rf/q6
add wave -position insertpoint sim:/mips/registerread_stage/rf/q7
radix signal sim:/mips/registerread_stage/rf/q0 hex
radix signal sim:/mips/registerread_stage/rf/q1 hex
radix signal sim:/mips/registerread_stage/rf/q2 hex
radix signal sim:/mips/registerread_stage/rf/q3 hex
radix signal sim:/mips/registerread_stage/rf/q4 hex
radix signal sim:/mips/registerread_stage/rf/q5 hex
radix signal sim:/mips/registerread_stage/rf/q6 hex
radix signal sim:/mips/registerread_stage/rf/q7 hex


add wave -position insertpoint sim:/mips/memory_stage/stack_reg
radix signal sim:/mips/memory_stage/stack_reg hex


add wave -position insertpoint sim:/mips/execute_stage/flgs

add wave -position insertpoint sim:/mips/fetch_stage/ldus
radix signal sim:/mips/fetch_stage/ldus bin

# force -freeze sim:/mips/in_port x"0005"
# Set the reset.
force -freeze sim:/mips/reset 1
run
# Reset the reset.
force -freeze sim:/mips/reset 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
