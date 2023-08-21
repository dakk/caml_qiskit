open OUnit2
open Qiskit


let etests = "test suite for quantum_circuit execution" >::: [
  "empty" >:: (fun _ -> assert_equal 0 0);
  "empty" >:: (fun _ -> assert_equal 0 0);
]

let _ = run_test_tt_main etests