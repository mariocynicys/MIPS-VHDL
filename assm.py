#!/usr/bin/env python3
import sys
import enum
import argparse
from typing import Dict, List, Optional, Union, Tuple


DESCRIPTION = 'An assembler for our MIPS processor.'
RES_MEM_TIL = 10
MAX_MEM_SIZ = 2 ** 20
OPCODES = {
  # OPCODE = Rsrc2[15:13] Rsrc1[12:10] Rdst[9:7] Func[6:4] Class[3:0]
  #C00
  'nop' : 'xxx' 'xxx' 'xxx' '000' '0000',
  'hlt' : 'xxx' 'xxx' 'xxx' '001' '0000',
  'rst' : 'xxx' 'xxx' 'xxx' '010' '0000', # Should not appear in the code, it's only a signal
  #C01
  'setc': 'xxx' 'xxx' 'xxx' '001' '0001',
  #C02
  # NOTE: MOV has it's operands swapped.
  'mov' : 'xxx' '1st' '2nd' '000' '0010',
  'not' : 'xxx' '1st' '1st' '010' '0010',
  'and' : '3rd' '2nd' '1st' '011' '0010',
  'add' : '3rd' '2nd' '1st' '100' '0010',
  'sub' : '3rd' '2nd' '1st' '101' '0010',
  'inc' : 'xxx' '1st' '1st' '110' '0010',
  #C03
  'out' : 'xxx' '1st' 'xxx' '000' '0011',
  #C04
  'in'  : 'xxx' 'xxx' '1st' '000' '0100', # Has MOV's Func code
  #C05
  'push': 'xxx' '1st' 'xxx' '000' '0101',
  #C06
  'pop' : 'xxx' 'xxx' '1st' '000' '0110',
  #C07
  'jmp' : 'xxx' '1st' 'xxx' '000' '0111',
  'jz'  : 'xxx' '1st' 'xxx' '100' '0111',
  'jn'  : 'xxx' '1st' 'xxx' '010' '0111',
  'jc'  : 'xxx' '1st' 'xxx' '001' '0111',
  #C08
  'int' : 'iii' 'iii' 'iii' '000' '1010', # The 9 is are replaced with the index.
  'call': 'xxx' '1st' 'xxx' '001' '1010',
  #C09
  'rti' : 'xxx' 'xxx' 'xxx' '000' '1011',
  'ret' : 'xxx' 'xxx' 'xxx' '001' '1011',
  # NOTE: Having an imm value clears Rsrc1 op slot for the ALU.
  #C10
  'iadd': '2nd' 'xxx' '1st' '100' '1100', # Has ADD's Func code
  'ldm' : 'xxx' 'xxx' '1st' '000' '1100', # Has MOV's Func code
  # NOTE: The `offset(Rsrc)` expression breaks to -> 2nd op and `imm`.
  #C11
  'ldd' : '2nd' 'xxx' '1st' '100' '1110', # Has ADD's Func code
  # NOTE: Rsrc1 won't reach the ALU, but will pass directly to the memory.
  #C12
  'std' : '2nd' '1st' 'xxx' '100' '1111', # Has ADD's Func code
  #C13: Documenting unused operation classes.
  'emp1': 'xxx' 'xxx' 'xxx' 'xxx' '1000',
  'emp2': 'xxx' 'xxx' 'xxx' 'xxx' '1001',
  'emp3': 'xxx' 'xxx' 'xxx' 'xxx' '1101',
}

OPCODES.pop('rst')
OPCODES.pop('emp1')
OPCODES.pop('emp2')
OPCODES.pop('emp3')

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

  def fmt(self, n_bits: int) -> str:
    if self == Format.BIN:
      return '{:0' +   str(n_bits)    + 'b}'
    else:
      return '{:0' + str(n_bits // 4) + 'x}'

  def siz(self, n_bits: int) -> int:
    if self == Format.BIN:
      return n_bits
    else:
      return n_bits // 4

blocks: Dict[str, Union[Block, List[Block]]] = {
  'main': Block(stopper='hlt', wadr=0),
  'exp1': Block(stopper='hlt', wadr=2),
  'exp2': Block(stopper='hlt', wadr=4),
  'int1': Block(stopper='rti', wadr=6),
  'int2': Block(stopper='rti', wadr=8),
  'func': [], # List of Blocks
}

def convert(instruction: List[str], ofrom: Format) -> Tuple:
  '''Converts an instruction passed as a list of operation and operands
  to its equivalent extended opcode.'''
  # opc = opr dst, rc1, rc2
  iln = len(instruction)
  opr = instruction[0]
  dst = instruction[1] if iln > 1 else '000'
  rc1 = instruction[2] if iln > 2 else '000'
  rc2 = instruction[3] if iln > 3 else '000'
  opc = OPCODES.get(opr)
  assert opc is not None, f'Bad instruction: {instruction}'
  # Imm has not slot in `opc`.
  imm = None
  if opr in {'ldd', 'std'}:
    # Extract the Imm and rc2 surrounded by it. 
    imm, rc1 = rc1[:-1].split('(')
    # Convert the Imm to a 16-bit binary number.
    imm = Format.BIN.fmt(16).format(int(imm, 0))
  elif opr == 'iadd':
    # Imm will be at rc2 location for IADD.
    imm = Format.BIN.fmt(16).format(int(rc2, 0))
  elif opr == 'ldm':
    # Imm will be at rc1 location for LDM.
    imm = Format.BIN.fmt(16).format(int(rc1, 0))
  elif opr == 'int':
    # Convert the index to a 9-bit binary number.
    ind = Format.BIN.fmt(9).format(int(dst, 0))
    opc = opc.replace(9 * 'i', ind)
  # Remove any $ and r which are the registers' identifiers
  # and format the registers' slot in binary.
  rc1 = Format.BIN.fmt(3).format(int(rc1.replace('$', '')
                                        .replace('r', ''), 0))
  rc2 = Format.BIN.fmt(3).format(int(rc2.replace('$', '')
                                        .replace('r', ''), 0))
  dst = Format.BIN.fmt(3).format(int(dst.replace('$', '')
                                        .replace('r', ''), 0))
  # Substitute the registers' identifiers in the opcode.
  opc = (opc.replace('1st', dst).replace('2nd', rc1)
            .replace('3rd', rc2).replace( 'x' , '0'))
  assert len(opc) == Format.BIN.siz(16), f'Couldn\'t parse {instruction}'
  # Format the opcode with the wanted output format.
  opc = ofrom.fmt(16).format(int(opc, 2)).upper()
  # If we have an Imm, we are gonna return a tuple.
  if imm is not None:
    assert len(imm) == Format.BIN.siz(16), f'Couldn\'t parse {instruction}'
    # Format the Imm with the requested output format.
    imm = ofrom.fmt(16).format(int(imm, 2)).upper()
    return (opc, imm)
  else:
    return (opc,)

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
  parser.add_argument('-p', '--print-code-blocks',
                      action='store_true',
                      help='Prints the info and content about the code blocks found'
                      ' in the assembly code.')
  args = parser.parse_args()

  input = open(args.input_asm)
  output = open(args.output_bin, 'w') if args.output_bin else sys.stdout
  oform = Format((args.output_format or 'bin').lower())
  delim = args.delimiter or ''
  print_blocks = args.print_code_blocks

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
        code_block.code.extend(convert(instructions[index], oform))
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
  NOP: str = convert(['nop'], oform)[0]
  converted_instructions: List[str] = [NOP for _ in range(MAX_MEM_SIZ)]
  for code_block in code_blocks:
    if print_blocks: print(code_block)
    if code_block.wadr is not None:
      addr = oform.fmt(32).format(code_block.addr).upper()
      converted_instructions[code_block.wadr]     = addr[:oform.siz(16)]
      converted_instructions[code_block.wadr + 1] = addr[oform.siz(16):]
    addr = code_block.addr
    for inst in code_block.code:
      converted_instructions[addr] = inst
      addr += 1
  output.write(delim.join(converted_instructions))

if __name__ == '__main__':
  try:
    main()
  except Exception as e:
    sys.exit(e)
