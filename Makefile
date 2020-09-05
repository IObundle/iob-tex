all: pb ug

pb:
	make -C document/pb $@
ug:
	make -C document/ug $@
clean:
	make -C document/pb pdfclean
	make -C document/ug pdfclean

.PHONY: all pb ug clean
