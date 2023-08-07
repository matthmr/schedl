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

tests:
	tests/unit-ts.scm 2>/dev/null
	tests/unit-path.scm 2>/dev/null

failed-tests:
	@echo -e "\non \`unit-ts.scm':"
	@tests/unit-ts.scm -n 2>/dev/null | grep -A3 '^FAIL' || echo -e "All tests pass\n---"
	@echo -e "\non \`unit-path.scm':"
	@tests/unit-path.scm -n 2>/dev/null | grep -A3 '^FAIL' || echo -e "All tests pass\n---"

help:
	@echo "make tests: runs the test suite"
	@echo "make failed-tests: runs a simplified version of the test suite"
	@echo "make docs: make documentation"
	@echo "make install: installs to \$PREFIX"

.PHONY: tests failed-tests \
	install docs help
