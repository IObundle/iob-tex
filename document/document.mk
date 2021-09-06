#this may be unnecessary. don't these vars get exported anyway?
EXPORT_LIST=\
INTEL=$(INTEL)\
XILINX=$(XILINX)\

#paths
TEX:=$(TEX_DIR)/document
TEX_SW_DIR:=$(TEX_DIR)/software
TEX_DOC_DIR:=$(TEX_DIR)/document

#latex build macros
SP ?= 0
SWREGS ?= 1
SWCOMPS ?= 0
TD ?= 0


TEX_DEFINES=\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}
TEX_DEFINES +=\def\SP{$(SP)}\def\SWREGS{$(SWREGS)}\def\SWCOMPS{$(SWCOMPS)}
TEX_DEFINES +=\def\TD{$(TD)}

#add block digram table to th elist of tables
TAB +=bd_tab.tex

#add general interface signals to the list of tables
TAB +=gen_is_tab.tex

ifneq ($(SP),)
TAB +=sp_tab.tex
endif

ifneq ($(SWREGS),)
TAB +=sw_reg_tab.tex
endif 


SRC:= $(wildcard ./*.tex) $(wildcard ../*.tex) $(TAB)

all: $(TAB) $(DOC).pdf

pb.pdf: $(TEX)/pb/pb.tex figures fpga_res
	cp -u $(TEX_DIR)/document/pb/pb.cls .
	$(EXPORT_LIST) pdflatex '$(TEX_DEFINES)\input{$<}'
	$(EXPORT_LIST) pdflatex '$(TEX_DEFINES)\input{$<}'
	evince $@ &

ug.pdf: $(TEX)/ug/ug.tex $(SRC) figures fpga_res $(CORE_NAME)_version.txt
	git rev-parse --short HEAD > shortHash.txt
	$(EXPORT_LIST) pdflatex '$(TEX_DEFINES)\input{$<}'
	$(EXPORT_LIST) pdflatex '$(TEX_DEFINES)\input{$<}'
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

#FPGA implementation results
fpga_res:
ifeq ($(XILINX),1)
	cp $(CORE_DIR)/hardware/fpga/vivado/$(XIL_FAMILY)/vivado.log .
endif
ifeq ($(INTEL),1)
	cp $(CORE_DIR)/hardware/fpga/quartus/$(INT_FAMILY)/quartus.log .
endif
	$(EXPORT_LIST) $(TEX_SW_DIR)/fpga2tex.sh


#block diagram
bd_tab.tex: $(CORE_DIR)/hardware/src/$(BD_VSRC)
	$(TEX_SW_DIR)/block2tex.py $@ $^

#synthesis parameters
sp_tab.tex: $(CORE_DIR)/hardware/src/$(TOP_MODULE).v
	$(TEX_SW_DIR)/param2tex.py $< $@ $(CORE_DIR)/hardware/include/$(TOP_MODULE).vh

#sw accessible registers
sw_reg_tab.tex: $(CORE_DIR)/hardware/include/$(CORE_NAME)sw_reg.v
	$(TEX_SW_DIR)/swreg2tex.py $< 

#general interface signals (clk and rst)
gen_is_tab.tex: $(INTERCON_DIR)/hardware/include/gen_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

#cleaning
texclean:
	@rm -f *~ *.aux *.out *.log *.summary 
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt

resultsclean:
	@rm -f *_results*

clean: texclean resultsclean
	@rm -rf figures *.cls $(TAB)

.PHONY:  all figures fpga_res texclean resultsclean clean
