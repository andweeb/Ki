.PHONY: docs deps

repo := $(shell git rev-parse --show-toplevel)

spoon-build:
	$(repo)/build.sh

spoon: spoon-build
	cp -r $(repo)/dist/build $(repo)/dist/Ki.spoon
	zip -r dist/Ki.spoon.zip $(repo)/dist/Ki.spoon

lint:
	luacheck src/*.lua spec/*.lua

test: clean-spoon clean-test
	-busted -c -t "$(tag)"
	luacov-console
	luacov-console -s

docs: clean-docs
	$(repo)/docs/build_docs.py --templates $(repo)/docs/templates/ --output_dir $(repo)/docs --html --markdown --standalone .

spoon-deps:
	luarocks install --tree deps fsm
	luarocks install --tree deps lustache

docs-deps:
	pip install --user jinja2 mistune pygments

test-deps:
	luarocks install busted
	luarocks install luacov-console

deps: spoon-deps docs-deps test-deps

clean-spoon:
	rm -rfv $(repo)/dist/build
	rm -rfv $(repo)/dist/Ki.spoon
	rm -fv $(repo)/dist/Ki.spoon.zip

clean-docs:
	rm -rfv $(repo)/docs/markdown $(repo)/docs/html

clean-test:
	rm -fv $(repo)/luacov.*

clean: clean-spoon clean-test
