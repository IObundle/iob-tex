#!/usr/bin/python2.7
#
#    Build Latex tables of verilog module interface signals and registers
#

import sys
import os.path
import re
import string

def parse (program) :
    program_out = []
    for line in program :
        flds_out = ['','','','']
        flds = re.sub('\[|\]|:|,|//',' ', line).split()
        if not flds : continue #empty line
        #print flds[0]
        if (flds[0] != 'input') & (flds[0] != 'output') & (flds[0] != 'inout'): continue #not an IO
        #print flds
        flds_out[1] = flds[0] #signal direction
        if not('[' in line):
            flds_out[0] = re.sub('_','\\_',flds[1]) #signal name
            flds_out[2] = '1' #signal width
            flds_out[3] = string.join(flds[2:]) #signal description
        else:
            flds_out[0] = re.sub('_','\\_',flds[3]) #signal name
            flds_out[2] = str(int(flds[1]) - int(flds[2]) + 1)  #signal width
            flds_out[3] = string.join(flds[4:]) #signal description
        program_out.append(flds_out)

         
    return program_out

            
def main () :
    #parse command line
    if len(sys.argv) != 3:
        vaError("Usage: ./v2tex.py infile outfile define_string")
    else:
        infile = sys.argv[1]
        outfile = sys.argv[2]

    #parse input file
    fin = open (infile, 'r')
    program = fin.readlines()
    program = parse (program)

    #print program
    #for line in range(len(program)):
     #   print program[line]

    #write output file
    fout = open (outfile, 'w')
    for i in range(len(program)):
        if ((i%2) != 0): fout.write("\\rowcolor{iob-blue}\n")
        line = program[i]
        fout.write('%s & %s & %s & %s \\\ \hline\n' %  (line[0], line[1], line[2], line[3]));

if __name__ == "__main__" : main ()
