TARGET=report

default: $(TARGET).pdf

.PRECIOUS: $(TARGET).pdf

.PHONY: default clean clobber

#
# Programs and Pathnames
#
BIBTEX   = bibtex
LATEX    = pdflatex
BIBINPUTS := ~/Papers/bibtex:.

#
# Patterns for source files
#
TEXFILES = $(wildcard *.tex) $(wildcard tables/*.tex) $(wildcard alg/*.tex)
BIBFILES = $(wildcard *.bib) $(wildcard $(BIBINPUTS)/*.bib)

FIGFILES = $(wildcard figs/*.pdf)
FIGFILES += $(wildcard figs/*.tex) $(wildcard figs/*.png)
FIGFILES += $(wildcard code/*)
CONFFILES += $(wildcard *.sty) $(wildcard *.cls)

#
# Build Rules
#
$(TARGET).pdf: $(TEXFILES) $(FIGFILES) $(BIBFILES) $(CONFFILES)
	-$(RM) -f *.aux
	$(LATEX) $(TARGET).tex
	-BIBINPUTS=$(BIBINPUTS) $(BIBTEX) $(TARGET)
	$(LATEX) $(TARGET).tex
	$(LATEX) $(TARGET).tex
	@/bin/echo ""
	@/bin/echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	@/bin/echo "               ++++ ANY UNDEFINED REFERENCES ++++"
	-@grep -i undef $(TARGET).log || echo "No undefined references."
	@/bin/echo "                 ++++ ANY EMPTY REFERENCES ++++"
	-@egrep -i -n -e 'cite{ *}' -e 'ref{ *}' $(TEXFILES) $(FIGFILES) || echo "No empty references."
	@/bin/echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	@/bin/echo ""

clean:
	rm -f *.aux *.bbl *.dvi *.lof *.log *.toc *.lot *.blg *.out

clobber: clean
	rm -f $(TARGET).pdf
