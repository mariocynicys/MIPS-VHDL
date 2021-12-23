#!/usr/bin/env python3

import sys

TMPL = '''
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY {0} IS
  PORT (
    Clk : IN STD_LOGIC;
    {1}
  );
END ENTITY;

ARCHITECTURE {0}_arc OF {0} IS
BEGIN
  PROCESS (Clk)
  BEGIN
    IF rising_edge(Clk) THEN
      {2}
    END IF;
  END PROCESS;
END ARCHITECTURE;
'''

PORT_ARG_IN_TMPL = '{}_in : IN STD_LOGIC_VECTOR( {}  DOWNTO 0)'
PORT_ARG_OUT_TMPL = '{}_out : OUT STD_LOGIC_VECTOR( {}  DOWNTO 0)'

input_file_name = sys.argv[1]
output_file_name_no_ext = input_file_name.split('.')[0]

port_args = []
proc_body = []
with open(input_file_name) as file:
  for line in file.readlines():
    line = line.strip().replace(' ', '')
    port_name, bit_count = line.split(':')
    port_args.extend([PORT_ARG_IN_TMPL.format(port_name, int(bit_count)-1),
                      PORT_ARG_OUT_TMPL.format(port_name, int(bit_count)-1)])
    proc_body.append("{0}_out <= {0}_in;".format(port_name))

with open(output_file_name_no_ext + '.vhd', 'w') as file:
  file.write(TMPL.format(output_file_name_no_ext,
                         ';\n'.join(port_args),
                         '\n'.join(proc_body)))
    