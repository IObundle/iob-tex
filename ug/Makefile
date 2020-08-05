SRC = ug.tex

ug.pdf: ug.tex $(SRC) rep.cls $(patsubst %.odg,%.pdf,$(wildcard figures/*.odg)) $(wildcard figures/*.png) version.txt
	git rev-parse --short HEAD > shortHash.txt
	latexmk -xelatex -pdf $<


figures/%.pdf: figures/%.odg
	make -C figures

clean:
	@rm -f $(addprefix ug, .aux .out .log .bcf .fdb_latexmk .fls .lof .lot .run.xml .toc .bbl .blg) *~ shortHash.txt version.txt
	make -C figures clean

.PHONY: clean
