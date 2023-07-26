PREFIX?=/usr/local/
DOCS?=y
INFODIR?=${PREFIX}/info/dir

install:
	mkdir -p ${PREFIX}/bin/
	install -v -m 0755 schedl ${PREFIX}/bin/
	install -v -m 0755 utils/edit-jobfile.sh ${PREFIX}/bin/schedl-edit
ifeq (${DOCS},y)
	emacs --batch --eval "(progn (require 'org)\
	                             (find-file \"README.org\")\
	                             (org-texinfo-export-to-info))" && \
		gzip -vkc README.info > schedl.info.gz && \
		install -v -m 0644 schedl.info.gz ${PREFIX}/share/info/ && \
		install-info -f ${PREFIX}/share/info/schedl.info.gz ${INFODIR}
endif

docs:
	emacs --batch --eval "(progn (require 'org)\
	                             (find-file \"README.org\")\
	                             (org-texinfo-export-to-info))"

test:
	tests/unit.scm 2>/dev/null

help:
	@echo "make test: runs the test suite"
	@echo "make install: installs to \$PREFIX"
