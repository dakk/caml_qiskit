# Caml_qiskit

[![CI](https://github.com/dakk/caml_qiskit/actions/workflows/ci.yml/badge.svg)](https://github.com/dakk/caml_qiskit/actions/workflows/ci.yml)
[![OCaml](https://img.shields.io/badge/OCaml-opam-EC6813?logo=ocaml&logoColor=white)](https://opam.ocaml.org/packages/qiskit/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

An OCaml wrapper for IBM Qiskit quantum computing toolkit.

```opam install qiskit```


## Example

```ocaml
open Qiskit

(* Create the circuit *)
let qc = quantum_circuit 2 2 
  |> h 0 
  |> id 1 
  |> barrier
  |> cx 0 1
  |> barrier
  |> measure 0 0
  |> measure 1 1
  |> draw;;
```

![Quantum circuit](https://raw.githubusercontent.com/dakk/caml_qiskit/master/media/readme_circuit.png)

```ocaml
(* Start a simulation *)
aer_simulator "statevector" 
  |> run qc 
  |> result 
  |> get_counts 
  |> Visualization.plot_histogram;
```

![Quantum sim res](https://raw.githubusercontent.com/dakk/caml_qiskit/master/media/readme_ressim.png)


```ocaml
(* Run the circuit on real quantum hardware *)
let serv = IBMRuntime.service ~token:"TOKEN" () in
let backend = IBMRuntime.least_busy serv in
let j = IBMRuntime.sampler backend |> IBMRuntime.run (transpile qc backend) in
j 
  |> result 
  |> IBMRuntime.get_counts 
  |> Visualization.plot_histogram;;
```

![Quantum sim res](https://raw.githubusercontent.com/dakk/caml_qiskit/master/media/readme_resreal.png)



## Install

```opam install qiskit```

You also need to install these python libraries (via pip):

- matplotlib
- numpy
- qiskit
- qiskit_aer
- pylatexenc

And optional for IBM quantum cloud computers:
- qiskit_ibm_runtime

Note: the legacy `IBMProvider` module (backed by `qiskit_ibm_provider`) has
been deprecated by IBM and is not compatible with qiskit >= 2.0; use the
`IBMRuntime` module instead.


## License
```
Copyright (c) 2020-2026 Davide Gessa

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
```