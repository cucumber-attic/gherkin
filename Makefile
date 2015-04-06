all: csharp/.compared go/.compared java/.compared javascript/.compared ruby/.compared
.PHONY: all

clean:
	cd csharp && make clean
	cd go && make clean
	cd java && make clean
	cd javascript && make clean
	cd ruby && make clean
.PHONY: clean

csharp/.compared:
	cd csharp && make

go/.compared:
	cd go && make

java/.compared:
	cd java && make

javascript/.compared:
	cd javascript && make

ruby/.compared:
	cd ruby && make

add-remotes:
	git remote add csharp     git@github.com:cucumber/gherkin-csharp.git
	git remote add go         git@github.com:cucumber/gherkin-go.git
	git remote add java       git@github.com:cucumber/gherkin-java.git
	git remote add javascript git@github.com:cucumber/gherkin-javascript.git
	git remote add ruby       git@github.com:cucumber/gherkin-ruby.git
.PHONY: add-remotes

push-subtrees:
	git subtree push --prefix=csharp     gherkin-csharp     master
	git subtree push --prefix=go         gherkin-go         master
	git subtree push --prefix=java       gherkin-java       master
	git subtree push --prefix=javascript gherkin-javascript master
	git subtree push --prefix=ruby       gherkin-ruby       master
.PHONY: push-subtrees

pull-subtrees:
	git subtree pull --prefix=csharp     gherkin-csharp     master
	git subtree pull --prefix=go         gherkin-go         master
	git subtree pull --prefix=java       gherkin-java       master
	git subtree pull --prefix=javascript gherkin-javascript master
	git subtree pull --prefix=ruby       gherkin-ruby       master
.PHONY: pull-subtrees
