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

open OUnit2
open Qiskit

let qasm_bell = "OPENQASM 2.0;\ninclude \"qelib1.inc\";\nqreg q[2];\ncreg c[2];\ncreg meas[2];\nh q[0];\ncx q[0],q[1];\nbarrier q[0],q[1];\nmeasure q[0] -> meas[0];\nmeasure q[1] -> meas[1];";;

let qctests = "test suite for quantum_circuit" >::: [
  "empty quantum_circuit" >:: (fun _ -> 
    let qc = quantum_circuit 1 1 in
    assert_equal 0 (depth qc)
  );
  "from qasm string" >:: (fun _ ->
    let qc = from_qasm_str qasm_bell in 
    assert_equal 3 (depth qc)    
  );
  "to qasm string" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> h 0 |> cx 0 1 |> measure_all |> Qasm2.dump in 
    assert_equal qc qasm_bell
  );
  "from qasm file" >:: (fun _ ->
    let qc = from_qasm_file "../../../test/t.qasm" in 
    assert_equal 3 (depth qc)    
  );
  "measure" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> h 0 |> cx 0 1 |> measure 0 0 |> measure 1 1 in 
    assert_equal (depth qc) 3
  );
  "measure_many" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> h 0 |> cx 0 1 |> measure_many [0;1] [0;1] in 
    assert_equal (depth qc) 3
  );
  "barrier & barrier_many" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> h 0 |> barrier_many [0;1] |> cx 0 1 |> Qasm2.dump in 
    let qc' = quantum_circuit 2 2 |> h 0 |> barrier |> cx 0 1 |> Qasm2.dump in 
    assert_equal qc qc'
  );
  "remove_final_measurements" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> h 0 |> measure 0 0 |> remove_final_measurements |> Qasm2.dump in 
    let qc' = quantum_circuit 2 0 |> h 0 |> Qasm2.dump in 
    assert_equal qc qc'
  );
  "copy & size" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> h 0 |> cx 0 1 in 
    let qc' = copy qc |> h 0 in 
    assert_equal ((size qc) + 1) (size qc')
  );
  "*bit count" >:: (fun _ ->
    let qc = quantum_circuit 2 3 |> h 0 |> cx 0 1 in 
    assert_equal (num_qubits qc) (2);
    assert_equal (num_clbits qc) (3)
  );
  "reset" >:: (fun _ ->
    let qc = quantum_circuit 2 3 |> h 0 |> cx 0 1 |> reset 0 in 
    assert_equal (size qc) (3)
  );
  "global_phase" >:: (fun _ ->
    let ph = quantum_circuit 1 0 |> global_phase in 
    assert_equal ph 0.0
  );
  "initialize_from_int" >:: (fun _ ->
    let qcs = quantum_circuit 2 0 |> initialize_from_int 10 |> size in 
    assert_equal qcs 1
  );
  "initialize_from_str" >:: (fun _ ->
    let qcs = quantum_circuit 2 0 |> initialize_from_str "10" |> size in 
    assert_equal qcs 1
  );
]

let _ = run_test_tt_main qctests