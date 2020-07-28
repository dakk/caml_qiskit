open Qiskit

(* Create the circuit *)
let qc = quantum_circuit 4 4 
|> x 0 
|> id 1 
|> barrier
|> cx 0 1
|> barrier
|> measure 0 0
|> measure 1 1
|> draw;;

(* Start a simulation *)
Aer.get_backend "qasm_simulator" |> execute qc |> result |> get_counts |> plot_histogram
