open Qiskit

let qc = quantum_circuit 4 4 
|> x 0 
|> id 1 
|> barrier
|> cx 0 1
|> barrier
|> measure 0 0
|> measure 1 1
|> draw

let be = Aer.get_backend "qasm_simulator"
let counts = execute qc be |> result |> get_counts |> plot_histogram
