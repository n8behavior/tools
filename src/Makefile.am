dist_bin_SCRIPTS = create-runbook create-repo repo-labels

REPLACEMENTS = 's,@BASHLIBS@,@libexecdir@,g;\
		s,PACKAGE_VERSION,@PACKAGE_VERSION@,g;\
		s,@BINARIES@,@bindir@,g'

%: %.sh
	sed -e $(REPLACEMENTS) < "$<" > "$@"

mostlyclean-local:
	-rm -f ${dist_bin_SCRIPTS}
