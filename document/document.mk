include $(ROOT_DIR)/core.mk

IOB_TEX:=$(ROOT_DIR)/submodules/TEX

INTEL = 1
XILINX = 1

pb: pb.pdf

ug: ug.pdf

figures:
	make -C ../figures

fpga:
	export ROOT_DIR
	../fpga2tex.sh $(COMPILE_SERVER) $(REMOTE_ROOT_DIR)/$(HW_DIR) $(INTEL) $(XILINX)

clean:
	@rm -f *~ *.aux *.out *.log *.summary *_results*
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	make -C ../figures clean

pdfclean: clean
	@rm -f *.pdf

.PHONY: pb ug clean pdfclean
