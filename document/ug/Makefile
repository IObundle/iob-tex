CORE_DIR:=../..

include $(CORE_DIR)/submodules/TEX/document/document.mk

SRC:=ug.tex $(wildcard ./*.tex) $(wildcard ../*.tex)

ug.pdf: $(SRC) figures fpga
	git rev-parse --short HEAD > shortHash.txt
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

clean: texclean

.PHONY: clean
