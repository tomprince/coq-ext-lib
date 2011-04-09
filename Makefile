.DEFAULT: all
.PHONY: all skeleton clean-states

all: states/extlib.coq

skeleton:
	python skeleton.py $(COQDIR) | git fast-import

states/extlib.coq: states/MakeInitial.v
	${COQBIN}coqtop -q -silent ${COQLIBS} -nois -batch -notop -load-vernac-source states/MakeInitial.v -outputstate states/extlib.coq

OTHERFLAGS = -is extlib

-include Makefile.coq

clean: clean-states
clean-states:
	rm -f states/extlib.coq

install: install-states
install-states:
	mkdir -p $(COQLIB)/states
	install states/extlib.coq $(COQLIB)/states/extlib.coq

states/extlib.coq: $(INITVO)
$(INITVO): OTHERFLAGS =
$(OTHERVO): states/extlib.coq
Makefile.coq: Make.stdlib Make.extra
	coq_makefile -f Make.stdlib -f Make.extra -R . ExtLib | sed -e '/OTHERFLAGS/s/:=/=/' > Makefile.coq
