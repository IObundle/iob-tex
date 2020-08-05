CC = soffice
CFLAGS = --headless --convert-to pdf
LO_RUNNING = $(shell pgrep soffice)


all: $(patsubst %.odg,%.pdf,$(wildcard *.odg))

ifeq ($(LO_RUNNING), )
%.pdf: %.odg
	$(CC) $(CFLAGS) $<
else 	
$(error LibreOffice is running. Close it before proceeding.)
endif

clean:
	@rm -f *.pdf *.eps *~

.PHONY: clean all

