XIL_LOG:=vivado.log
INT_LOG:=*.fit.summary

figures:
	cp $(addprefix $(TEX_DIR)/document/figures/, $(TEX_FIG)) ../figures
	make -C ../figures

fpga_log:
ifeq ($(XILINX),1)
	cp $(HW_DIR)/fpga/$(FPGA_FAMILY)/$(XIL_LOG) .
endif
ifeq ($(INTEL),1)
	cp $(HW_DIR)/fpga/$(FPGA_FAMILY)/output_files/$(INT_LOG) .
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

.PHONY:  figures fpga_log texclean pdfclean copy_files

