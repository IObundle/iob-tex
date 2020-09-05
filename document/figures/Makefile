CC = soffice
CFLAGS = --headless --convert-to png 
LO_RUNNING = $(shell pgrep soffice)
OBJS = $(patsubst %.odg,%.png,$(wildcard *.odg))

all: $(OBJS)

ifeq ($(LO_RUNNING), )
%.png: %.odg
	$(CC) $(CFLAGS) $<
else 	
$(error LibreOffice is running. Close it before proceeding.)
endif

clean:
	@rm -f *.png *~

.PHONY: all clean

