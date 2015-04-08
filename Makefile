
MAKEFILES=$(wildcard */Makefile)

all: $(patsubst %/Makefile,%/.compared,$(MAKEFILES))
.PHONY: all
%/.compared: %
	cd $< && make

clean: $(patsubst %/Makefile,clean-%,$(MAKEFILES))
.PHONY: clean
clean-%: %
	cd $< && make clean

add-remotes: $(patsubst %/Makefile,add-remote-%,$(MAKEFILES))
.PHONY: add-remotes
add-remote-%: %
	git remote -v | grep -E 'gherkin-$<\s' 2>/dev/null >/dev/null || \
	git remote add gherkin-$< git@github.com:cucumber/gherkin-$<.git

push-subtrees: $(patsubst %/Makefile,push-subtree-%,$(MAKEFILES))
.PHONY: push-subtrees
push-subtree-%: % add-remote-%
	git subtree push --prefix=$< gherkin-$< master

pull-subtrees: $(patsubst %/Makefile,pull-subtree-%,$(MAKEFILES))
.PHONY: pull-subtrees
pull-subtree-%: % add-remote-%
	git subtree pull --prefix=$< gherkin-$< master
