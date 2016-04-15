default: clean lib/parser.ex test

test:
	mix test
.PHONY: test

lib/parser.ex: ../gherkin.berp parser.elixir.razor ../bin/berp.exe
	mono ../bin/berp.exe -g ../gherkin.berp -t parser.elixir.razor -o $@
	# Remove BOM
	tail -c +4 $@ > $@.nobom
	mv $@.nobom $@

clean:
	rm -rf lib/parser.ex
.PHONY: clean
