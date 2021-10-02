#paths
TEX:=$(TEX_DIR)/document
TEX_SW_DIR:=$(TEX_DIR)/software

#latex build macros
BDTAB ?=1
SP ?=0
SWREGS ?=1
SWCOMPS ?=0
TD ?=0
CUSTOM ?= 0

TEX_DEFINES=\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}
TEX_DEFINES +=\def\SP{$(SP)}\def\SWREGS{$(SWREGS)}\def\SWCOMPS{$(SWCOMPS)}
TEX_DEFINES +=\def\TD{$(TD)}\def\CUSTOM{$(CUSTOM)}

#add general interface signals to the list of tables
TAB +=gen_is_tab.tex

#add block diagram table to the list of tables
ifeq ($(BDTAB),1)
TAB +=bd_tab.tex
endif

#add synthesis parameters table to the list of tables
ifeq ($(SP),1)
TAB +=sp_tab.tex
endif

#add software accessible registers table to the list of tables
ifeq ($(SWREGS),1)
TAB +=sw_reg_tab.tex
endif 


SRC:= $(wildcard ./*.tex) $(wildcard ../*.tex)

all: figures fpga_res $(TAB) $(DOC).pdf

pb.pdf: $(TEX)/pb/pb.tex $(SRC)
	cp -u $(TEX)/pb/pb.cls .
	pdflatex '$(TEX_DEFINES)\input{$<}'
	pdflatex '$(TEX_DEFINES)\input{$<}'
	evince $@ &

ug.pdf: $(TEX)/ug/ug.tex $(SRC) $(CORE_NAME)_version.txt
	git rev-parse --short HEAD > shortHash.txt
ifeq ($(CUSTOM),1)
	make custom
endif
	pdflatex '$(TEX_DEFINES)\input{$<}'
	bibtex ug
	pdflatex '$(TEX_DEFINES)\input{$<}'
	pdflatex '$(TEX_DEFINES)\input{$<}'
	evince $@ &

presentation.pdf: presentation.tex
	pdflatex $<
	pdflatex $<
	evince $@ &

figures:
	mkdir -p ./figures
	cp -u $(TEX)/figures/* ./figures
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
	INTEL=$(INTEL) XILINX=$(XILINX) $(TEX_SW_DIR)/fpga2tex.sh


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
clean: ug-clean
	@find . -type f -not \( $(NOCLEAN) \) -delete
	@rm -rf figures

.PHONY:  all figures fpga_res ug-clean clean
