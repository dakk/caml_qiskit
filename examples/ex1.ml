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

(* Start a simulation *)
let j = aer_simulator "statevector" |> run qc;;

j |> result |> get_counts |> Visualization.plot_histogram;;
