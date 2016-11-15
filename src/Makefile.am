
dist_bin_SCRIPTS = create-runbook

%: %.sh
	sed -e 's,@BASHLIBS@,@libexecdir@,g' < "$<" > "$@"

mostlyclean-local:
	-rm -f ${dist_bin_SCRIPTS}
