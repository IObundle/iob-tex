include $(CORE_DIR)/core.mk

pb: pb.pdf

ug: ug.pdf

EXPORT_LIST:=\
COMPILE_SERVER=$(COMPILE_SERVER) \
REMOTE_ROOT_DIR=$(REMOTE_ROOT_DIR) \
INTEL=$(INTEL) \
XILINX=$(XILINX) \
CORE_NAME=$(CORE_NAME) \
TEX_DIR=$(TEX_DIR)
HW_DIR:=$(CORE_DIR)/hardware
SW_DIR:=$(TEX_DIR)/../software

figures:
	make -C ../figures

fpga: vivado.log $(CORE_NAME).fit.summary
	$(EXPORT_LIST) $(SW_DIR)/fpga2tex.sh

$(CORE_NAME).fit.summary:
ifeq ($(COMPILE_SERVER),localhost)
	cp $(HW_DIR)/fpga/CYCLONEV-GT/output_files/$@ .
else
	scp $(IOB_USER)@$(COMPILE_SERVER):$(REMOTE_ROOT_DIR)/hardware/fpga/CYCLONEV-GT/output_files/*.fit.summary $@ 
endif

vivado.log:
ifeq ($(COMPILE_SERVER),localhost)
	cp $(HW_DIR)/fpga/XCKU/$@ .
else
	scp $(IOB_USER)@$(COMPILE_SERVER):$(REMOTE_ROOT_DIR)/hardware/fpga/XCKU/$@ .
endif


texclean:
	@rm -f *~ *.aux *.out *.log *.summary *_results*
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	make -C ../figures clean

pdfclean: clean
	@rm -f *.pdf

.PHONY: pb ug texclean pdfclean
