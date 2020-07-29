all:
	dune build @install @doc --profile release
	dune build
	rm -rf docs/* && cp -r _build/default/_doc/_html/* docs/

clean:
	rm -rf _build
	
run-ex1:
	./_build/default/examples/ex1.exe 
