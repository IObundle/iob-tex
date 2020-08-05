INTEL = 0
XILINX = 1

pb.pdf: pb.tex iob_pb.cls figures/*.odg
	make -C figures
	pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'

clean:
	rm $(addprefix pb, .aux .out .log)
	@rm -f *~
	make -C figures clean

pdfclean: clean
	@rm -f *.pdf

.PHONY: clean pdfclean
