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

PORT_ARG_TMPL = '{0}_in : IN STD_LOGIC_VECTOR( {1}  DOWNTO 0);\n' + \
                '{0}_out : OUT STD_LOGIC_VECTOR( {1}  DOWNTO 0)'

input_file_name = sys.argv[1]
output_file_name_no_ext = input_file_name.split('.')[0]

port_args = []
proc_body = []
with open(input_file_name) as file:
  for line in file.readlines():
    splt = line.strip().replace(' ', '').split(':')
    port_name, bit_count = splt if len(splt) > 1 else (splt[0], '1')
    port_args.append(PORT_ARG_TMPL.format(port_name, int(bit_count)-1))
    proc_body.append('{0}_out <= {0}_in'.format(port_name))

with open(output_file_name_no_ext + '.vhd', 'w') as file:
  file.write(TMPL.format(output_file_name_no_ext,
                         ';\n'.join(port_args),
                         ';\n'.join(proc_body) + ';'))
    