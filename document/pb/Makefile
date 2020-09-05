ROOT_DIR:=../..

include $(ROOT_DIR)/submodules/TEX/document/document.mk

pb.pdf: pb.tex figures fpga
	pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &
