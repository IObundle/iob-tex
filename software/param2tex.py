#!/usr/bin/python2.7
#
#    Build Latex tables of verilog module interface signals and registers
#

import sys
import os.path
import re
import string

def param_parse (program) :
    program_out = []

    for line in program :
        flds_out = ['', '', '']
        subline = re.sub('//',' ', line)
        subline = re.sub('=', '', subline, 1)

        flds = subline.split()
        if not flds : continue #empty line
        #print flds[0]
        if (flds[0] != 'parameter'): continue #not a block description
        #print flds
        
        param_desc = str(re.sub('_','\_', string.join(flds[3:])))
        if param_desc.startswith("NODOC"): continue #undocummented parameter

        flds_out[0] = re.sub('_','\_', flds[1]) #parameter name
        flds_out[1] = re.sub('_', '\_', re.sub(',', '', flds[2])) #parameter value
        flds_out[2] = "\\noindent\parbox[c]{\hsize}{\\rule{0pt}{15pt} " + str(param_desc) + " \\vspace{2mm}}" #parameter description

        program_out.append(flds_out)

    return program_out

def main () :
    #parse command line
    if len(sys.argv) != 3:
        print("Usage: ./v2tex.py infile outfile")
        exit()
    else:
        infile = sys.argv[1]
        outfile = sys.argv[2]
        pass

    #parse input file
    fin = open (infile, 'r')
    program = fin.readlines()
    program = param_parse (program)

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
