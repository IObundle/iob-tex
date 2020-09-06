CORE_NAME:=core

SIM_DIR:=$(CORE_DIR)/hardware/simulation/icarus

#FPGA_DIR:=hardware/fpga/CYCLONEV-GT
FPGA_DIR:=$(CORE_DIR)/hardware/fpga/XCKU

DOC_TRGT:=pb
#DOC_TRGT:=ug
DOC_DIR:=$(CORE_DIR)/document

INTEL:=1
XILINX:=1

SUBMODULES_DIR:=$(CORE_DIR)/submodules
TEX_DIR:=$(SUBMODULES_DIR)/TEX/document

COMPILE_SERVER:=localhost
REMOTE_ROOT_DIR=$(CORE_DIR)

