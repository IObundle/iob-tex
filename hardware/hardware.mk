#add itself to MODULES list
MODULES+=$(shell make -C $(TEX_DIR) corename | grep -v make)
