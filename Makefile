.PHONY: docs deps

repo := $(shell git rev-parse --show-toplevel)

spoon-build: clean-spoon-build
	$(repo)/build.sh

spoon: spoon-build
	cp -r $(repo)/dist $(repo)/Ki.spoon
	zip -r Ki.spoon.zip $(repo)/Ki.spoon

lint:
	luacheck *.lua spec/*.lua

test: clean-spoon-build clean-test
	-busted -c
	luacov-console
	luacov-console -s

docs: spoon-build clean-docs
	$(repo)/docs/build_docs.py --templates $(repo)/docs/templates/ --output_dir $(repo)/docs --html --markdown --standalone .

deps:
	luarocks install --tree deps fsm
	luarocks install --tree deps lustache

docs-deps:
	pip install --user jinja2 mistune pygments

test-deps:
	luarocks install busted
	luarocks install luacov-console

clean-spoon-build:
	rm -rfv $(repo)/dist

clean-spoon: clean-spoon-build
	rm -rfv $(repo)/Ki.spoon
	rm -fv $(repo)/Ki.spoon.zip

clean-docs:
	rm -rfv $(repo)/docs/markdown $(repo)/docs/html

clean-test:
	rm -fv $(repo)/luacov.*

clean: clean-spoon clean-test
