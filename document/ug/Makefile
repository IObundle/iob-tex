ROOT_DIR:=../..

include ../document.mk

SRC:=$(wildcard *.tex)

ug.pdf: $(SRC) figures fpga
	git rev-parse --short HEAD > shortHash.txt
	pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &


