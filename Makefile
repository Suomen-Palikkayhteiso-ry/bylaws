# Makefile for generating PDF diffs of bylaw proposals

SHELL = /usr/bin/env bash

PROPOSALS = 00 05 01 02 03 04 06 07
PROPOSALS_ALL = $(PROPOSALS) final
PROPOSAL_FILES = $(patsubst %,%.md,$(PROPOSALS))
PDF_DIFF_FILES = $(patsubst %,%-diff.pdf,$(PROPOSALS_ALL))
PATCH_FILES = $(patsubst %,%.patch,$(PROPOSALS))

.PHONY: all clean watch update-patches

CURRENT_BYLAWS_LATEX = current.tex

all: $(PROPOSAL_FILES) $(PDF_DIFF_FILES) final.pdf

# Generate LaTeX file from current bylaws
$(CURRENT_BYLAWS_LATEX): current.md listings-setup.tex
	@echo "Generating $(CURRENT_BYLAWS_LATEX)..."
	@devenv shell -- bash -c "pandoc current.md -s --include-in-header listings-setup.tex -o $(CURRENT_BYLAWS_LATEX)"

# Merge proposals into a final version
final.md: merge_proposals.py current.md $(PROPOSAL_FILES)
	@echo "Generating final proposal..."
	@devenv shell -- python3 merge_proposals.py $(PROPOSALS)

# Generic rule for creating a .md file from a .patch file
%.md: %.patch current.md
	@echo "Generating $@ from $<..."
	@patch -o $@ current.md $<

# Generic rule for creating a .tex file from a .md file
%.tex: %.md listings-setup.tex
	@echo "Generating $@..."
	@devenv shell -- bash -c "pandoc $< -s --include-in-header listings-setup.tex -o $@"

# Generic rule for creating a .pdf file
%.pdf: %.tex
	@echo "Compiling $@..."
	@devenv shell -- bash -c "pdflatex -interaction=nonstopmode $<"
	@devenv shell -- bash -c "pdflatex -interaction=nonstopmode $<"
	@devenv shell -- bash -c "pdflatex -interaction=nonstopmode $<"

# Generic rule for creating a diff .tex file
%-diff.tex: %.tex $(CURRENT_BYLAWS_LATEX)
	@echo "Generating LaTeX diff for $*..."
	@devenv shell -- bash -c "latexdiff $(CURRENT_BYLAWS_LATEX) $< > $@"

# Generic rule for creating a diff .pdf file
%-diff.pdf: %-diff.tex
	@echo "Compiling $@..."
	@devenv shell -- bash -c "pdflatex -interaction=nonstopmode $<"
	@devenv shell -- bash -c "pdflatex -interaction=nonstopmode $<"
	@devenv shell -- bash -c "pdflatex -interaction=nonstopmode $<"

watch:
	@echo "Watching for changes in markdown files..."
	@devenv shell -- bash -c "ls -1 *.md *.patch | entr -c make all"

update-patches:
	@$(foreach f,$(PROPOSAL_FILES),diff -u current.md $(f) > $(patsubst %.md,%.patch,$(f));)

clean:
	@echo "Cleaning up generated files..."
	@rm -f $(CURRENT_BYLAWS_LATEX)
	@rm -f $(patsubst %,%.tex,$(PROPOSALS_ALL))
	@rm -f $(patsubst %,%-diff.tex,$(PROPOSALS_ALL))
	@rm -f $(PDF_DIFF_FILES)
	@rm -f *.aux *.log *.out
	@rm -f *-reject.patch
	@rm -f $(PROPOSAL_FILES)
