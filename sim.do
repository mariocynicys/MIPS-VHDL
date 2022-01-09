# Start simulating.
vsim work.mips
# Load the memory.
mem load -i ins.mem /mips/fetch_stage/iram/ram
mem load -i mem.mem /mips/memory_stage/ram/inner_ram
# Log everything.
add log -r /*
# Add the clock.
add wave -position end  sim:/mips/clk
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
# Add the exception pc.
add wave -position end sim:/mips/epc
radix signal sim:/mips/epc hex
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
