ROOT_DIR:=../..

include $(ROOT_DIR)/submodules/TEX/document/document.mk

pb.pdf: pb.tex figures fpga
	DOC_DIR=$(TEX_DIR)/document pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	DOC_DIR=$(TEX_DIR)/document pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &
