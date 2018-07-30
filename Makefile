.PHONY: docs deps

# Working directory variable
wd := $(shell git rev-parse --show-toplevel)

# Monitor file changes at filepath $(1) and trigger function $(2)
define monitor-file-changes
	fswatch -orv $(1) | xargs -n1 $(call $(2))
endef

# Run lua linter on src and spec files
define lint-command
	luacheck src/*.lua spec/*.lua
endef

# Run busted unit tests and write coverage report with optional $(tag) argument
define test-command
	-busted -c -t "$(tag)"
	luacov-console
	luacov-console -s
endef

# Generate html and markup docs and copy styles to output directory
define generate-docs-command
	$(wd)/docs/build_docs.py \
		--output_dir $(wd)/docs \
		--templates $(wd)/docs/templates/ \
		--html --markdown --standalone --validate . && \
		cp $(wd)/docs/templates/docs.css $(wd)/docs/html/docs.css
endef

spoon-build:
	$(wd)/build.sh

spoon: spoon-build
	cp -r $(wd)/dist/build $(wd)/dist/Ki.spoon
	zip -r dist/Ki.spoon.zip $(wd)/dist/Ki.spoon

lint:
	$(call lint-command)

watch-lint:
	$(call monitor-file-changes,$(wd)/src,lint-command)

test: clean-spoon clean-test
	-busted -c -t "$(tag)"
	luacov-console
	luacov-console -s

docs: clean-docs
	$(call generate-docs-command)

watch-docs:
	$(call monitor-file-changes,$(wd)/src,generate-docs-command)

spoon-deps:
	luarocks install --tree deps fsm 1.1.0-1
	luarocks install --tree deps lustache 1.3.1-0
	luarocks install --tree deps middleclass 4.1.1-0
	git clone --branch v0.5 https://github.com/andweeb/hs._asm.undocumented.spaces.git deps/spaces && \
		cd deps/spaces && \
		make install

docs-deps:
	pip install --user jinja2 mistune pygments

test-deps:
	luarocks install busted
	luarocks install luacov-console

deps: spoon-deps docs-deps test-deps

clean-spoon:
	rm -rfv $(wd)/dist/build
	rm -rfv $(wd)/dist/Ki.spoon
	rm -fv $(wd)/dist/Ki.spoon.zip

clean-docs:
	rm -rfv $(wd)/docs/markdown $(wd)/docs/html

clean-test:
	rm -fv $(wd)/luacov.*

clean: clean-spoon clean-test
