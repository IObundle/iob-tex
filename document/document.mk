EXPORT_LIST:=\
INTEL=$(INTEL) \
XILINX=$(XILINX) \
CORE_NAME=$(CORE_NAME) \
TEX_DIR=$(TEX_DIR)/document

TEX_SRC:= color.tex deliverables.tex benefits.tex
TEX_FIG:= bg.odg Logo.png

HW_DIR:=$(CORE_DIR)/hardware

XIL_LOG:=vivado.log
INT_LOG:=*.fit.summary

figures:
	cp $(addprefix $(TEX_DIR)/document/figures/, $(TEX_FIG)) ../figures
	make -C ../figures

fpga:
ifeq ($(XILINX),1)
ifeq ($(COMPILE_SERVER),localhost)
	cp $(HW_DIR)/fpga/$(FPGA_FAMILY)/$(XIL_LOG) .
else
	scp $(COMPILE_USER)@$(COMPILE_SERVER):$(COMPILE_DIR)/$(XIL_LOG) .
endif
endif
ifeq ($(INTEL),1)
ifeq ($(COMPILE_SERVER),localhost)
	cp $(HW_DIR)/fpga/$(FPGA_FAMILY)/output_files/$(INT_LOG) .
else
	scp $(COMPILE_USER)@$(COMPILE_SERVER):$(COMPILE_DIR)/output_files/*.fit.summary $(INT_LOG) 
endif
endif
	$(EXPORT_LIST) $(TEX_DIR)/software/fpga2tex.sh

texclean:
	@rm -f *~ *.aux *.out *.log *.summary *_results*
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	make -C ../figures clean
	@rm -f $(TEX_SRC) $(addprefix ../figures/, $(TEX_FIG))

pdfclean: clean
	@rm -f *.pdf

pb.pdf: pb.tex figures fpga copy_files
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

ug.pdf: $(SRC) figures fpga
	git rev-parse --short HEAD > shortHash.txt
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

copy_files:
	@cp $(addprefix $(TEX_DIR)/document/, $(TEX_SRC)) .

.PHONY: clean texclean pdfclean fpga figures
