fnc: 3 # the function to perform.

alu_en # should the alu work?, this affects the flags.

# this is for call and int instructions together.
# this signal is also fired for ret and rti instructions.
cal_int

in_en # = the first op to the alu is the 16-bit value from the in port.
imm_en # = the first op to the alu is the 16-bit imm value.

# mem_read and mem_write can decided whether this is a push or a pop,
# or whether this is an int/cal or ret/rti. we can still diff between
# int and calls by the func code and the same for ret/rti.
mr
mw

brn # branchie

ps_pp # this signal is for push and pop together.

wb # write back.
out_en # = the first op goes directly to the output port.

dst: 3 # you know what that is.
sr1: 3 # you know what that is.
sr2: 3 # you know what that is.

pc: 32
# The in port is at the fetch stage and its value passed to the registerread
# stage through the buffers. This way we can change the value of the in port
# without affecting the instructions passed the fetch stage.
inn: 16
imm: 16


# this signals passes all the processor, as some stages perform some operations
# when they encouter a reset signal(like reseting the stack pointer).
# rst ; this is not needed any more as it is generated be default for any buffer.
