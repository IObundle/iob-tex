XIL_LOG=vivado.log
INT_LOG=quartus.log

EXPORT_LIST=\
INTEL=$(INTEL)\
XILINX=$(XILINX)\

TEX:=$(TEX_DIR)/document
TEX_SW_DIR:=$(TEX_DIR)/software


IS_TAB:=gen_is_tab.tex cpu_nat_s_is_tab.tex cpu_axi4lite_s_is_tab.tex rs232_is_tab.tex

REG_TAB:=sw_reg_tab.tex

BD_TAB:=bd_tab.tex

SRC:= $(wildcard ./*.tex) $(wildcard ../*.tex)  $(IS_TAB) $(REG_TAB) $(BD_TAB)

TD_FIGS:= #list figures here


pb.pdf: $(TEX)/pb/pb.tex figures fpga_res
	cp -u $(TEX_DIR)/document/pb/pb.cls .
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

ug.pdf: $(TEX)/ug/ug.tex $(SRC) figures fpga_res $(CORE_NAME)_version.txt
	git rev-parse --short HEAD > shortHash.txt
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

presentation.pdf: presentation.tex figures
	pdflatex $<
	pdflatex $<
	evince $@ &

figures:
	mkdir -p ./figures
	cp -u $(TEX_DIR)/document/figures/* ./figures
	cp -u ../figures/* ./figures
	make -C ./figures

fpga_res:
ifeq ($(XILINX),1)
	cp $(CORE_DIR)/hardware/fpga/vivado/$(XIL_FAMILY)/vivado.log .
endif
ifeq ($(INTEL),1)
	cp $(CORE_DIR)/hardware/fpga/quartus/$(INT_FAMILY)/quartus.log .
endif
	$(EXPORT_LIST) $(TEX_SW_DIR)/fpga2tex.sh


gen_is_tab.tex: $(INTERCON_DIR)/hardware/include/gen_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

cpu_nat_s_is_tab.tex: $(INTERCON_DIR)/hardware/include/cpu_nat_s_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

cpu_axi4_m_is_tab.tex: $(INTERCON_DIR)/hardware/include/cpu_axi4_m_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

cpu_axi4lite_s_is_tab.tex: $(INTERCON_DIR)/hardware/include/cpu_axi4lite_s_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

sw_reg_tab.tex: $($(CORE_NAME)_DIR)/hardware/include/$(CORE_NAME)sw_reg.v
	$(TEX_SW_DIR)/swreg2tex.py $<

texclean:
	@rm -f *~ *.aux *.out *.log *.summary 
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	@rm -f $(TEX_SRC)

resultsclean:
	@rm -f *_results*

clean: texclean resultsclean
	@rm -rf figures *.cls
	@rm -f $(IS_TAB) $(REG_TAB) $(BD_TAB)

.PHONY:  figures fpga_res texclean resultsclean clean
