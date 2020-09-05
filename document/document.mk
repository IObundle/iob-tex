include $(ROOT_DIR)/core.mk

pb: pb.pdf

ug: ug.pdf

EXPORT_LIST:=COMPILE_SERVER=$(COMPILE_SERVER)  REMOTE_ROOT_DIR=$(REMOTE_ROOT_DIR) INTEL=$(INTEL) XILINX=$(XILINX)

figures:
	make -C ../figures

fpga:
	$(EXPORT_LIST) $(TEX_DIR)/document/fpga2tex.sh

clean:
	@rm -f *~ *.aux *.out *.log *.summary *_results*
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	make -C ../figures clean

pdfclean: clean
	@rm -f *.pdf

.PHONY: pb ug clean pdfclean
