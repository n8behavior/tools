REPLACEMENTS = 's,@BASHLIBS@,@libexecdir@,g;\
		s,PACKAGE_VERSION,@PACKAGE_VERSION@,g;\
		s,@BINARIES@,@bindir@,g'

dist_libexec_SCRIPTS = shflags common github

%: %.in
	sed -e $(REPLACEMENTS) < "$<" > "$@"

mostlyclean-local:
	-rm -f ${dist_bin_SCRIPTS}
