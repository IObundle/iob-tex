CC = soffice

all: $(patsubst %.odg,%.pdf,$(wildcard *.odg)) bd.png

ifeq ($(shell pgrep soffice), )
%.pdf: %.odg
	$(CC) --headless --convert-to pdf $<

bd.png: bd.odg
	$(CC) --headless --invisible --convert-to png $<

else 	
$(error LibreOffice is running. Close it before proceeding.)
endif

clean:
	@rm -f *.pdf *.eps bd.png *~


.PHONY: clean all

