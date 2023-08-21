all:
	dune build @install @runtest @doc --profile release
	rm -rf docs/* && cp -r _build/default/_doc/_html/* docs/

clean:
	rm -rf _build
	
run-ex1:
	./_build/default/examples/ex1.exe 
run-ex2_ibm:
	./_build/default/examples/ex2_ibm.exe 

.PHONY : coverage
coverage : clean
	BISECT_ENABLE=YES jbuilder runtest
	bisect-ppx-report -I _build/default/ -html _coverage/ `find . -name 'bisect*.out'`

.PHONY : pin
pin: 
	opam pin add qiskit . -n --working-dir && opam remove qiskit && opam install qiskit --working-dir
