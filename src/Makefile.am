
dist_bin_SCRIPTS = create-runbook create-repo

%: %.sh
	sed -e 's,@BASHLIBS@,@libexecdir@,g;s/PACKAGE_VERSION/@PACKAGE_VERSION@/g' < "$<" > "$@"

mostlyclean-local:
	-rm -f ${dist_bin_SCRIPTS}
