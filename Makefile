.PHONY: docs deps

# Working directory variable
wd := $(shell git rev-parse --show-toplevel)

# Monitor file changes at filepath $(1) and evaluate expression $(2) on events
define monitor-file-changes
	fswatch -rv $(1) | xargs -I {} sh -c '$(call $(2))'
endef

# Build the Ki spoon
define build-command
	$(wd)/build.sh
endef

# Run lua linter on src and spec files
define lint-command
	luacheck src/*.lua spec/*.lua
endef

# Run busted unit tests and write coverage report with optional tag argument
define test-command
	busted -c -t "$(tag)"; luacov-console; luacov-console -s;
endef

# Generate html and markup docs and copy styles to output directory
define generate-docs-command
	$(wd)/docs/build_docs.py -i "Ki" \
		--output_dir $(wd)/docs \
		--templates $(wd)/docs/templates/ \
		--html --markdown --standalone --validate . && \
		cp $(wd)/docs/templates/docs.css $(wd)/docs/html/docs.css
endef

spoon: cheatsheet
	$(call build-command)
	cp -r $(wd)/dist/build $(wd)/dist/Ki.spoon
	cd dist && zip -r Ki.spoon.zip Ki.spoon

dev: cheatsheet
	$(call build-command)

watch-dev:
	$(call monitor-file-changes,$(wd)/src,build-command)

lint:
	$(call lint-command)

watch-lint:
	$(call monitor-file-changes,$(wd)/src,lint-command)

test: clean-spoon clean-test
	$(call test-command)

watch-test:
	$(call monitor-file-changes,$(wd)/spec,test-command)

docs: clean-docs
	$(call generate-docs-command)

watch-docs:
	$(call monitor-file-changes,$(wd)/src,generate-docs-command)

src/cheatsheet/node_modules:
	cd $(wd)/src/cheatsheet && npm ci

src/cheatsheet/cheatsheet.js: src/cheatsheet/node_modules
	cd $(wd)/src/cheatsheet && npm run build

cheatsheet: src/cheatsheet/cheatsheet.js src/cheatsheet/node_modules

deps:
	luarocks install --lua-version 5.4 --tree deps fsm 1.1.0-1
	luarocks install --lua-version 5.4 --tree deps lustache 1.3.1-0
	luarocks install --lua-version 5.4 --tree deps middleclass 4.1.1-0

lint-deps:
	luarocks install luacheck

docs-deps:
	pip install --user jinja2 mistune pygments

test-deps:
	luarocks install busted
	luarocks install luacov
	luarocks install luacov-console

dev-deps: lint-deps docs-deps test-deps

clean-spoon:
	rm -rfv $(wd)/dist/build
	rm -rfv $(wd)/dist/Ki.spoon
	rm -fv $(wd)/dist/Ki.spoon.zip

clean-cheatsheet:
	rm -fv $(wd)/src/cheatsheet/cheatsheet.js
	rm -rf $(wd)/src/cheatsheet/node_modules/

clean-docs:
	rm -rfv $(wd)/docs/markdown $(wd)/docs/html

clean-test:
	rm -fv $(wd)/luacov.*

clean: clean-spoon clean-test clean-cheatsheet
