(* Copyright (c) 2020-2024 Davide Gessa

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
OTHER DEALINGS IN THE SOFTWARE. *)

open Qiskit
open OUnit2

let etests = "test suite for quantum_circuit execution" >::: [
  "aer_simulator statevector" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> id 1 |> measure 0 0 in
    let j = aer_simulator "statevector" |> run qc in
    let c = j |> result |> get_counts in
    assert_equal true (c<>Py.none)
  );
  "aer_simulator statevector2" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> id 1 |> measure 0 0 in
    let c = qc |> remove_final_measurements |> Quantum_info.statevector in
    assert_equal true (c<>Py.none)
  );
  "aer_simulator unitary" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> cx 0 1 |> save_state in
    let j = aer_simulator "unitary" |> run qc in
    let c = j |> result in
    let r = get_unitary c qc in
    assert_equal true (r<>Py.none)
  )
]

let _ = run_test_tt_main etests