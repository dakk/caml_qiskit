all:
	dune build @doc

clean:
	rm -rf _build
	
run-test:
	./_build/default/test/test.exe 
