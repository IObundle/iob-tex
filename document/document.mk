XIL_LOG=vivado.log
INT_LOG=quartus.log
EXPORT_LIST=\
INTEL=$(INTEL)\
XILINX=$(XILINX)\
IS_CORE=$(IS_CORE)

TEX:=$(TEX_DIR)/document
TEX_SW_DIR:=$(TEX_DIR)/software

pb.pdf: pb.tex figures fpga_res
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

ug.pdf: $(SRC) figures fpga_res version.txt
	git rev-parse --short HEAD > shortHash.txt
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

export TD_FIGS
figures:
	cp -u $(TEX_DIR)/document/figures/* ../figures
	make -C ../figures

fpga_res: $(FPGA_LIST)
ifeq ($(XILINX),1)
	cp $(HW_DIR)/fpga/vivado/XCKU/vivado.log .
endif
ifeq ($(INTEL),1)
	cp $(HW_DIR)/fpga/quartus/CYCLONEV-GT/quartus.log .
endif
	$(EXPORT_LIST) $(TEX_DIR)/software/fpga2tex.sh

texclean:
	@rm -f *~ *.aux *.out *.log *.summary *_results*
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	make -C ../figures clean
	@rm -f $(TEX_SRC) $(addprefix ../figures/, $(TEX_FIG))

pdfclean: clean
	@rm -f *.pdf

.PHONY:  figures fpga_res texclean pdfclean
