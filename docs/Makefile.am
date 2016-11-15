SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
BUILDDIR      = $(builddir)

ALLSPHINXOPTS = -d $(BUILDDIR)/doctrees $(SPHINXOPTS) $(srcdir)/source

all-local: html-local

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  livehtml   to run a live-reload server for development"
	@echo "  man        to make manual pages"

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)/*

.PHONY: html
html-local:
	mkdir -p $(BUILDDIR)/html
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."


.PHONY: livehtml
livehtml:
	sphinx-autobuild -i '*.swp' -i '*.swx' -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html


install-data-local:
	find html/ -type d -exec install -m 755 -d $(DESTDIR)$(htmldir)/{} \;
	find html/ -type f -exec install -m 644 {} $(DESTDIR)$(htmldir)/{} \;



