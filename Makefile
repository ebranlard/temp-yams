MAIN=SymbolicFlexible
WINDOWS=1

SVGDIR=svg
SVGOUTDIR=figs_svg

SVGTEXDIR=svgtex

SVGTEXOUTDIR=figs_svgtex
SVGTEXS=$(notdir $(wildcard $(SVGTEXDIR)/*.svg))
SVGTEXS2PDFS=$(patsubst %,$(SVGTEXOUTDIR)/%,$(SVGTEXS:.svg=.pdf))
SVGS=$(notdir $(wildcard $(SVGDIR)/*.svg))
SVGS2PDFS=$(patsubst %,$(SVGOUTDIR)/%,$(SVGS:.svg=.pdf))



INKSCAPE=inkscape
RM=rm -f
MV=mv
SLASH="/"
# Windows specific
ifeq ($(WINDOWS),1)
   INKSCAPE="C:/Program Files/Inkscape/inkscape.exe"
   RM=del
   MV=move /Y 
   SLASH="\\"
else
   INKSCAPE=inkscape
   RM=rm
   MV=mv
   SLASH="/"
endif

all: figspdf pdf

pdf: figspdf
	pdflatex -synctex=1 --file-line-error-style --shell-escape --interaction=nonstopmode $(MAIN)
	bibtex $(MAIN).aux

bibtex:
	bibtex $(MAIN).aux

figspdf: $(SVGOUTDIR) $(SVGTEXOUTDIR) $(SVGS2PDFS) $(SVGTEXS2PDFS)

$(SVGTEXOUTDIR)/%.pdf:$(SVGTEXDIR)/%.svg 
	$(INKSCAPE) -z -D --file="$<" --export-pdf="$(SVGTEXOUTDIR)/$*.pdf" --export-latex
	$(MV) "$(SVGTEXOUTDIR)$(SLASH)$*.pdf_tex" "$(SVGTEXOUTDIR)$(SLASH)$*.tex"

$(SVGOUTDIR)/%.pdf: $(SVGDIR)/%.svg
	$(INKSCAPE) -D -A "$@" "$<"
 
$(SVGTEXOUTDIR):
	mkdir $@
$(SVGOUTDIR):
	mkdir $@

clean:
	$(RM) *.log *.aux *.out *.bbl *.blg *.toc *.pag

typos:
	python C:/Config/scripts/fixTypos.py $(MAIN).tex $(MAIN)_typos.tex


doc:
	pandoc --wrap=preserve -F pandoc-citeproc -s $(MAIN).tex -o $(MAIN).md --bibliography=Bibliography.bib --reference-doc=_Template.docx
# 	pandoc --number-section  --filter pandoc-citeproc -s $(MAIN).tex -o $(MAIN).docx --bibliography=Bibliography.bib --reference-doc=_Template.docx
	python C:/Config/scripts/parseMarkdown.py $(MAIN).md $(MAIN)-clean.md NoRef
	pandoc --number-section --filter pandoc-citeproc -s $(MAIN)-clean.md -o $(MAIN).docx --bibliography=Bibliography.bib --reference-doc=_Template.docx
# 	pandoc -F pandoc-crossref -s $(MAIN).md -o $(MAIN).docx --number-section --bibliography=Bibliography.bib
# 	pandoc -F pandoc-eqnos -s $(MAIN).md -o $(MAIN).docx --number-section --bibliography=Bibliography.bib
# 	pandoc -F pandoc-crossref -s $(MAIN).md -o $(MAIN).docx --number-section --bibliography=Bibliography.bib
	start "" "$(MAIN).docx"

diff:
	latexdiff $(MAIN)_old.tex $(MAIN).tex > $(MAIN)-diff.tex
	cp $(MAIN).aux $(MAIN)-diff.aux
	cp $(MAIN).bbl $(MAIN)-diff.bbl
	cp $(MAIN).blg $(MAIN)-diff.blg
	pdflatex --interaction=nonstopmode $(MAIN)-diff.tex

diff2:
	pdflatex --interaction=nonstopmode $(MAIN)-diff.tex

final:
	python C:/Config/scripts/MakeStandaloneFigs.py --toeps --fullwidth --cropafter --border 10 --folder _final $(MAIN).tex
# 	python C:/Config/scripts/MakeStandaloneFigs.py --toeps --fullwidth --cropafter --folder _final $(MAIN).tex


