#!/usr/bin/python2.7
#
#    Build Latex tables of verilog module interface signals and registers
#

import sys
import os.path
import re
import string
import math

from vhparser import header_parse

def io_parse (program, defines) :
    program_out = []
    swreg_list = []
    for line in program :
        flds_out = ['','','','']
        subline = re.sub('\[|\]|:|,|//|\;',' ', line)

        flds = subline.split()
        if not flds : continue #empty line
        #print flds[0]
        if (flds[0] != 'input') & (flds[0] != 'output') & (flds[0] != 'inout'): continue #not IO
        #print flds
        flds_out[1] = flds[0] #signal direction

        flds_w = 1
        if (flds[1] == 'reg'):
            flds_w = flds_w+1
        if (flds[1] == 'signed'):
            flds_w = flds_w+1
            
        if not('[' in line):
            flds_out[0] = re.sub('_','\\_',flds[flds_w]) #signal name
            flds_out[2] = '1' #signal width
            flds_out[3] = string.join(flds[flds_w+1:]) #signal description
        else:
            flds_out[0] = re.sub('_','\\_',flds[flds_w+2]) #signal name
            for key, val in defines.items():
                if key in str(flds[flds_w]):
                    flds[flds_w] = eval(re.sub(str(key),str(val), flds[flds_w]))
                if key in str(flds[flds_w+1]):
                    flds[flds_w+1] = eval(re.sub(str(key),str(val), flds[flds_w+1]))
                pass
            flds_out[2] = str(int(flds[flds_w]) - int(flds[flds_w+1]) + 1)  #signal width
            flds_out[3] = string.join(flds[flds_w+3:]) #signal description

        program_out.append(flds_out)

    return program_out

def main () :
    #parse command line
    if len(sys.argv) != 3 and len(sys.argv) != 4:
        vaError("Usage: ./v2tex.py infile outfile [header_file]")
    else:
        infile = sys.argv[1]
        outfile = sys.argv[2]
        if len(sys.argv) == 4:
            vhfile = sys.argv[3]
        pass

    defines = {}
    if 'vhfile' in locals():
        #Create header dictionary
        fvh = open(vhfile, 'r')
        defines = header_parse(fvh)
        fvh.close()
        
    #parse input file
    fin = open (infile, 'r')
    program = fin.readlines()
    program = io_parse (program, defines)

    #print program
    #for line in range(len(program)):
     #   print program[line]

    #write output file
    fout = open (outfile, 'w')
    for i in range(len(program)):
        if ((i%2) != 0): fout.write("\\rowcolor{iob-blue}\n")
        line = program[i]
        line_out = str(line[0])
        for l in range(1,len(line)):
            line_out = line_out + (' & %s' % line[l])
        fout.write(line_out + ' \\\ \hline\n')

    #Close files
    fin.close()
    fout.close()

if __name__ == "__main__" : main ()
