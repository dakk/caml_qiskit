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
;;


(* Run the circuit on real quantum hardware *)
let serv = IBMRuntime.service ~token:"TOKEN" () in
let backend = IBMRuntime.least_busy serv in
let j = IBMRuntime.sampler backend |> IBMRuntime.run (transpile qc backend) in
Printf.printf "job status: %s\n" (IBMRuntime.job_status j);
j
  |> result
  |> IBMRuntime.get_counts
  |> Visualization.plot_histogram;;
