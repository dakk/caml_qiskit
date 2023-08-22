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
let j = Aer.get_backend "qasm_simulator" 
  |> execute qc;;

Tools.Monitor.job_monitor j;;

j |> result |> get_counts |> Visualization.plot_histogram;;
