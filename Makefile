CORE_DIR:=.
include core.mk

doc:
	make -C $(DOC_DIR)/$(DOC_TYPE) $(DOC_TYPE)

clean:
	make -C document/pb pdfclean
	make -C document/ug pdfclean

.PHONY: doc clean
