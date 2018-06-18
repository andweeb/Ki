source:
	./build.sh

test-dependencies:
	luarocks install busted luacov-console

test: clean
	busted
	luacov-console
	luacov-console -s

clean:
	rm -rfv ./dist
	rm -vf luacov.*
