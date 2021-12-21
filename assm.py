#!/usr/bin/env python3
import sys
import enum
import argparse
from typing import Dict, List, Optional, Union, Tuple


DESCRIPTION = 'An assembler for our MIPS processor.'
RES_MEM_TIL = 10
MAX_MEM_SIZ = 2 ** 20
OPCODES = {
  #C00
  'nop' : '000''0000',
  'hlt' : '001''0000',
  'rst' : '010''0000',
  #C01
  'setc': '001''0001',
  #C02
  'mov' : '000''0010',
  'not' : '010''0010',
  'and' : '011''0010',
  'add' : '100''0010',
  'sub' : '101''0010',
  'inc' : '110''0010',
  #C03
  'out' : '000''0011',
  #C04
  'in'  : '000''0100', # Has MOV's func code
  #C05
  'push': '000''0101',
  #C06
  'pop' : '000''0110',
  #C07
  'jmp' : '000''0111',
  'jz'  : '100''0111',
  'jn'  : '010''0111',
  'jc'  : '001''0111',
  #C08
  'int' : '000''1010',
  'call': '001''1010',
  #C09
  'rti' : '000''1011',
  'ret' : '001''1011',
  #C10
  'iadd': '100''1100', # Has ADD's func code
  #C11
  'ldm' : '000''1101', # Has MOV's func code
  #C12
  'ldd' : '100''1101', # Has ADD's func code
  #C13
  'std' : '100''1111', # Has ADD's func code
  #C14: Documenting unused opcode classes.
  'emp1': 'xxx''1000',
  'emp1': 'xxx''1001',
}

class Block:
  addr: int = 0
  name: str = ''
  # Controls where addr will be written.
  wadr: Optional[int] = None
  stopper: str = ''
  code: List[str] = []

  def __init__(self, addr=0, name='', stopper='', wadr=None):
    self.addr = addr
    self.name = name
    self.wadr = wadr
    self.stopper = stopper
    self.code = []

  def __str__(self):
    return (f'addr: {self.addr}\n'
            f'name: {self.name}\n'
            f'wadr: {self.wadr}\n'
            f'code:\n\t' +
            '\n\t'.join(self.code))

class Format(enum.Enum):
  HEX = 'hex'
  BIN = 'bin'

  def fmt(self):
    if self == Format.HEX:
      return '{:08x}'
    elif self == Format.BIN:
      return '{:032b}'

  def siz(self):
    return int(int(self.fmt()[3:-2])/2)

def convert(instruction: List[str], ofrom: Format) -> Union[str, Tuple[str, str]]:
  '''Converts an instruction passed as a list of operation and operands
  to its equivalent extended opcode.'''

  op = instruction[0]
  return OPCODES[op]
  

blocks: Dict[str, Union[Block, List[Block]]] = {
  'main': Block(stopper='hlt', wadr=0),
  'exp1': Block(stopper='hlt', wadr=2),
  'exp2': Block(stopper='hlt', wadr=4),
  'int1': Block(stopper='rti', wadr=6),
  'int2': Block(stopper='rti', wadr=8),
  'func': [], # List of Blocks
}

def main():
  parser = argparse.ArgumentParser(description=DESCRIPTION)

  parser.add_argument('-i', '--input-asm',
                      required=True,
                      help='The path to the assembly input file (required).')
  parser.add_argument('-o', '--output-bin',
                      help='The path to the binary output file. ' +
                            'If not provided, the assembler will write to stdout.')
  parser.add_argument('-f', '--output-format',
                      help='The format of the output instructions (hex or bin)')
  parser.add_argument('-d', '--delimiter',
                      help='The delimiter to insert between each two memory words.')
  args = parser.parse_args()

  input = open(args.input_asm)
  output = open(args.output_bin, 'w') if args.output_bin else sys.stdout
  delim = args.delimiter or ''
  oform = Format((args.output_format or 'bin').lower())

  # Capture the whole file without comments as stripped lines.
  lines = [line.split(';', 1)[0].strip() for line in input.readlines()]
  # Capture each instruction as a list.
  instructions = [line.lower().replace(',', ' ').split()
                  for line in lines if line]
  # Define code blocks and parse the instructions.
  index = 0
  while index < len(instructions):
    if instructions[index][0].startswith(tuple(blocks.keys())):
      # Block name without the colon.
      block_name = instructions[index][0][:-1]
      # Default stopper and write back address for functions.
      stopper = 'ret'
      wadr = None
      # Blocks other than functions can't be defined twice, and have different stopper.
      if not block_name.startswith('func'):
        assert isinstance(blocks[block_name], Block)
        assert not blocks[block_name].code, f'{block_name} is already defined.'
        stopper = blocks[block_name].stopper
        wadr = blocks[block_name].wadr
      # Create a new code block.
      code_block = Block(addr=int(instructions[index][1], 16),
                         name=block_name, stopper=stopper, wadr=wadr)
      index += 1
      while True:
        ins = convert(instructions[index], oform)
        if isinstance(ins, str):
          code_block.code.append(ins)
        else:
          code_block.code.append(ins[0]), code_block.code.append(ins[1])
        if instructions[index][0] == code_block.stopper:
          break
        index += 1
      if not block_name.startswith('func'):
        blocks[block_name] = code_block
      else:
        blocks['func'].append(code_block)
    else:
      raise RuntimeError(f'{instructions[index]} outside a code block.')
    # Advance to the next block.
    index += 1
  # Keep only the filled blocks.
  code_blocks: List[Block] = []
  for block_name, block in blocks.items():
    if block_name != 'func':
      if block.code:
        code_blocks.append(block)
    elif block_name == 'func':
      code_blocks.extend(block)
  # Assert the blocks comply with the constrains.
  for block1 in code_blocks:
    assert block1.addr + len(block1.code) < MAX_MEM_SIZ, (
      f'{block1.name} is exceeding the memory size.')
    assert block1.addr > RES_MEM_TIL, (
      f'{block1.name} starts from address {block1.addr} which is reserved')
    for block2 in code_blocks:
      if block1 != block2:
        assert not bool(set(range(block1.addr, block1.addr + len(block1.code))) &
                        set(range(block2.addr, block2.addr + len(block2.code)))), (
                          f'{block1.name} and {block2.name} intersect.')
  # Write the parsed instructions to the output file.
  NOP: str = convert(['nop'], oform)
  converted_instructions: List[str] = [NOP for _ in range(MAX_MEM_SIZ)]
  for code_block in code_blocks:
    if code_block.wadr is not None:
      addr = oform.fmt().format(code_block.addr).upper()
      converted_instructions[code_block.wadr]     = addr[:oform.siz()]
      converted_instructions[code_block.wadr + 1] = addr[oform.siz():]
    addr = code_block.addr
    for inst in code_block.code:
      converted_instructions[addr] = inst
      addr += 1
  output.write(delim.join(converted_instructions))


if __name__ == '__main__':
  main()
  try:
    pass
  except Exception as e:
    sys.exit(e)
