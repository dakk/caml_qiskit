open Qiskit
open OUnit2


let etests = "test suite for quantum_circuit execution" >::: [
  "aer qasm_simulator" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> id 1 |> measure 0 0 in
    let j = Aer.get_backend "qasm_simulator" |> execute qc in
    let c = j |> result |> get_counts in
    assert_equal true (c<>Py.none)
  );
  "aer statevector_simulator" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> id 1 |> measure 0 0 in
    let j = Aer.get_backend "statevector_simulator" |> execute qc in
    let c = j |> result |> get_statevector in
    assert_equal true (c<>Py.none)
  );
  "aer unitary_simulator" >:: (fun _ ->
    let qc = quantum_circuit 2 2 |> cx 0 1 in
    let j = Aer.get_backend "unitary_simulator" |> execute qc in
    let c = j |> result in
    let r = get_unitary c qc in
    assert_equal true (r<>Py.none)
  )
]

let _ = run_test_tt_main etests