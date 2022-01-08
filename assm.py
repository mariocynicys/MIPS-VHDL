#!/usr/bin/env python3
import sys
import enum
import argparse
from typing import Dict, List, Optional, Union, Tuple


DESCRIPTION = 'An assembler for our MIPS processor.'
RES_MEM_TIL = 10
MAX_MEM_SIZ = 2 ** 20
OPCODES = {
  # OPCODE = Class[3:0] Func[6:4] Rdst[9:7] Rsrc1[12:10] Rsrc2[15:13]
  # Ideally Rdst is the 1st operand, Rsrc1 is the 2nd, and Rsrc2 is the 3rd.
  #C00
  'nop' : '0000' '000' 'xxx' 'xxx' 'xxx',
  'hlt' : '0000' '001' 'xxx' 'xxx' 'xxx',
  # NOTE: C01 & C02 are classes for ALU operations.
  # The 000 function code is reserved for the move no operation (pass the first operand).
  #C01
  'setc': '0001' '001' 'xxx' 'xxx' 'xxx',
  #C02
  'not' : '0010' '010' '1st' '1st' 'xxx',
  'and' : '0010' '011' '1st' '2nd' '3rd',
  'add' : '0010' '100' '1st' '2nd' '3rd',
  'sub' : '0010' '101' '1st' '2nd' '3rd',
  'inc' : '0010' '110' '1st' '1st' 'xxx',
  #C03
  'out' : '0011' '000' 'xxx' '1st' 'xxx',
  #C04
  'in'  : '0100' '000' '1st' 'xxx' 'xxx', # Has MOV's Func code
  #C05
  'push': '0101' '000' 'xxx' '1st' 'xxx',
  #C06
  'pop' : '0110' '000' '1st' 'xxx' 'xxx',
  #C07
  'jmp' : '0111' '000' 'xxx' '1st' 'xxx',
  'jz'  : '0111' '100' 'xxx' '1st' 'xxx',
  'jn'  : '0111' '010' 'xxx' '1st' 'xxx',
  'jc'  : '0111' '001' 'xxx' '1st' 'xxx',
  #C08
  # NOTE: MOV has it's operands swapped.
  'mov' : '0010' '000' '2nd' '1st' 'xxx',
  # NOTE: Unused class.
  #C09
  'emp1': '1001' 'xxx' 'xxx' 'xxx' 'xxx',
  #C10
  'int' : '1010' '000' 'iii' 'iii' 'iii', # The 9(i)s are replaced with the index.
  'call': '1010' '001' 'xxx' '1st' 'xxx',
  #C11
  'rti' : '1011' '000' 'xxx' 'xxx' 'xxx',
  'ret' : '1011' '001' 'xxx' 'xxx' 'xxx',
  # NOTE: Having an imm value clears Rsrc1 op slot for the ALU.
  #C12
  'iadd': '1100' '100' '1st' 'xxx' '2nd', # Has ADD's Func code
  #C13
  'ldm' : '1101' '000' '1st' 'xxx' 'xxx', # Has MOV's Func code
  # NOTE: The `offset(Rsrc)` expression breaks to -> 2nd op and `imm`.
  #C14
  'ldd' : '1110' '100' '1st' 'xxx' '2nd', # Has ADD's Func code
  #C15
  # NOTE: Rsrc1 won't reach the ALU, but will pass directly to the memory.
  'std' : '1111' '100' 'xxx' '1st' '2nd', # Has ADD's Func code
}

OPCODES.pop('emp1')

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
  # Imm has no slot in `opc`.
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
  # If we have an Imm, we are gonna return it in the tuple.
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
                      help='Prints the info and content of the code blocks found'
                      ' in the assembly code.')
  args = parser.parse_args()

  input = open(args.input_asm)
  output = open(args.output_bin, 'w') if args.output_bin else sys.stdout
  oform = Format((args.output_format or 'bin').lower())
  delim = args.delimiter or ''
  print_blocks = args.print_code_blocks

  # Capture the whole file without comments as stripped lines.
  lines = [line.split(';')[0].split('#')[0].strip()
           for line in input.readlines()]
  # Capture each instruction as a list.
  instructions = [line.lower().replace(',', ' ').split()
                  for line in lines if line]
  # Define code blocks and parse the instructions.
  index = 0
  while index < len(instructions):
    block_line = ''.join(instructions[index]).replace(' ', '')
    block_name = block_line.split(':', 1)[0]
    # Block name and address.
    if block_name.startswith(tuple(blocks.keys())):
      block_addr = block_line.split(':', 1)[1]
      # Default stopper and write back address for functions.
      stopper, wadr = 'ret',  None
      # Blocks other than functions can't be defined twice, and have different stopper.
      if not block_name.startswith('func'):
        assert isinstance(blocks.get(block_name), Block), \
          f'{block_name} is not a valid block name.'
        assert not blocks[block_name].code, f'{block_name} is already defined.'
        stopper = blocks[block_name].stopper
        wadr = blocks[block_name].wadr
      # Create a new code block.
      code_block = Block(addr=int(block_addr, 16), name=block_name,
                         stopper=stopper, wadr=wadr)
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
    if print_blocks: print(code_block, file=sys.stderr)
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
