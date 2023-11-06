open OUnit2
open Qiskit

let qasm_bell = "OPENQASM 2.0;\ninclude \"qelib1.inc\";\nqreg q[2];\ncreg c[2];\ncreg meas[2];\nh q[0];\ncx q[0],q[1];\nbarrier q[0],q[1];\nmeasure q[0] -> meas[0];\nmeasure q[1] -> meas[1];\n";;

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
    let qc = quantum_circuit 2 2 |> h 0 |> cx 0 1 |> measure_all |> qasm in 
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
    let qc = quantum_circuit 2 2 |> h 0 |> barrier_many [0;1] |> cx 0 1 |> qasm in 
    let qc' = quantum_circuit 2 2 |> h 0 |> barrier |> cx 0 1 |> qasm in 
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