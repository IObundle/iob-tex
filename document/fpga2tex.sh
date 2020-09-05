#!/bin/bash

#COMPILE_SERVER=$1
HW_DIR=$REMOTE_ROOT_DIR/hardware

echo $COMPILE_SERVER
#altera
if [ $INTEL = 1 ]; then \
LOG="core.fit.summary";\
RES="alt_results.tex";\
                        
if [ $COMPILE_SERVER == localhost ]; then \
    cp $HW_DIR/fpga/CYCLONEV-GT/output_files/$LOG . ;\
else \
    scp $COMPILE_SERVER:$HW_DIR/fpga/CYCLONEV-GT/output_files/$LOG . ;\
fi;
ALM=`grep ALM $LOG |grep -o '[0-9]*,\?[0-9]* \/' | sed s/'\/'//g`;\
FF=`grep registers $LOG |grep -o '[0-9]*' | sed s/'\/'//g`;\
DSP=`grep DSP $LOG |grep -o '[0-9]* \/' | sed s/'\/'//g`;\
BRAM=`grep RAM $LOG |grep -o '[0-9]* \/' | sed s/'\/'//g`;\
BRAMb=`grep 'block memory' $LOG |grep -o '[0-9]*,[0-9]* \/' | sed s/'\/'//g`;\
PIN=`grep pin $LOG |grep -o '[0-9]* \/' | sed s/'\/'//g`;\
echo "ALM & $ALM \\\\ \\hline" > $RES;\
echo "\rowcolor{iob-blue}"  >> $RES;\
echo "FF & $FF  \\\\  \\hline"  >> $RES;\
echo "DSP & $DSP \\\\ \\hline"  >> $RES;\
echo "\rowcolor{iob-blue}"  >> $RES;\
echo "BRAM blocks & $BRAM \\\\ \\hline"  >> $RES;\
echo "BRAM bits & $BRAMb \\\\ \\hline"  >> $RES;\
echo "\rowcolor{iob-blue}"  >> $RES;\
echo "PIN & $PIN \\\\ \\hline"  >> $RES;\
fi


#xilinx
if [ $XILINX = 1 ]; then \
LOG="vivado.log" ;\
RES="xil_results.tex" ;\
if [ $COMPILE_SERVER == localhost ]; then \
    cp $HW_DIR/fpga/XCKU/$LOG . ;\
else \
    scp $COMPILE_SERVER:$HW_DIR/fpga/XCKU/$LOG . ;\
fi;
LUT=`grep -o 'LUTs\ *|\ * [0-9]*' vivado.log | sed s/'| L'/L/g | sed s/\|/'\&'/g` ;\
FF=`grep -o 'Registers\ *|\ * [0-9]*' vivado.log | sed s/'| L'/L/g | sed s/\|/'\&'/g` ;\
DSP=`grep -o 'DSPs\ *|\ * [0-9]*' vivado.log | sed s/'| L'/L/g | sed s/\|/'\&'/g` ;\
BRAM=`grep -o 'Block RAM Tile \ *|\ * [0-9]*' vivado.log | sed s/'| L'/L/g | sed s/\|/'\&'/g | sed s/lock\ //g | sed s/Tile//g` ;\
PIN=`grep -o 'Bonded IOB\ *|\ * [0-9]*' vivado.log | sed s/'| L'/L/g | sed s/\|/'\&'/g | sed s/'Bonded IOB'/PIN/g` ;\
echo "$LUT \\\\ \\hline"  > $RES ;\
echo "\rowcolor{iob-blue}"  >> $RES ;\
echo "$FF  \\\\  \\hline" >> $RES ;\
echo "$DSP \\\\ \\hline" >> $RES ;\
echo "\rowcolor{iob-blue}" >> $RES ;\
echo "$BRAM \\\\ \\hline" >> $RES ;\
echo "$PIN \\\\ \\hline" >> $RES ; fi
