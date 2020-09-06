CORE_DIR:=.
include core.mk

doc:
	make -C $(DOC_DIR)/$(DOC_TRGT) $(DOC_TRGT)

clean:
	make -C document/pb pdfclean
	make -C document/ug pdfclean

.PHONY: doc clean
