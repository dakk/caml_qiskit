all:
	dune build @install @runtest @doc --profile release
	dune build
	rm -rf docs/* && cp -r _build/default/_doc/_html/* docs/

clean:
	rm -rf _build
	
run-test:
	./_build/default/test/test.exe 
