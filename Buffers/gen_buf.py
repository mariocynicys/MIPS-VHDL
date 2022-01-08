#!/usr/bin/env python3

import sys
import os.path

TMPL = '''LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY {0} IS
  PORT (
    clk : IN STD_LOGIC;
    fsh : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
{1}
    rst_in      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rst_out     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE {0}_arc OF {0} IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF fsh = "1" or rst_out = "1" THEN
{2}
        rst_out <= "0";
      ELSE
{3}
        rst_out <= rst_in;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;
'''

PORT_ARG_TMPL = '{0}_in : IN STD_LOGIC_VECTOR({1}  DOWNTO 0) := "{2}";\n' + \
                '{0}_out : OUT STD_LOGIC_VECTOR({1}  DOWNTO 0);'

input_file_name = os.path.join(os.path.dirname(__file__), sys.argv[1])
output_file_name_no_ext = input_file_name.split('.')[0]

port_args = []
flsh_body = []
proc_body = []
with open(input_file_name) as file:
  lines = [line.strip().replace(' ', '').split(';')[0].split('#')[0].split(':')
           for line in file.readlines()]
  lines = [line for line in lines if line[0].strip()]
  for line in lines:
    port_name, bit_count = line if len(line) > 1 else (line[0], '1')
    bit_c = int(bit_count)
    port_args.append(PORT_ARG_TMPL.format(port_name, bit_c - 1, bit_c * '0'))
    flsh_body.append('{0}_out <= "{1}";'.format(port_name, bit_c * '0'))
    proc_body.append('{0}_out <= {0}_in;'.format(port_name))

with open(output_file_name_no_ext + '.vhd', 'w') as file:
  file.write(TMPL.format(output_file_name_no_ext.split('/')[-1],
                         '\n'.join(port_args),
                         '\n'.join(flsh_body),
                         '\n'.join(proc_body)))
    