Py.initialize ()

let np = Py.import "numpy"
let qk = Py.import "qiskit"
let plt = Py.import "matplotlib.pyplot"


type qcircuit = Py.Object.t

let quantum_circuit (nq: int) (nc: int): qcircuit = 
  Py.Module.get_function qk "QuantumCircuit" [| Py.Int.of_int nq; Py.Int.of_int nc |]

let measure n nto (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "measure" [| Py.Int.of_int n; Py.Int.of_int nto |] |> ignore; qc

let measure_all (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "measure_all" [| |] |> ignore; qc

let measure_many nl ntol (qc: qcircuit): qcircuit = 
  let nl' = Py.List.of_list_map Py.Int.of_int nl in
  let ntol' = Py.List.of_list_map Py.Int.of_int ntol in
  Py.Module.get_function qc "measure" [| nl'; ntol' |] |> ignore; qc

let ag_p3 g p1 p2 p3 n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p1; Py.Float.of_float p2; Py.Float.of_float p3; Py.Int.of_int n |]

let ag_p2 g p1 p2 n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p1; Py.Float.of_float p2; Py.Int.of_int n |]
  
let ag_p1 g p n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p; Py.Int.of_int n |]

let ag g n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Int.of_int n |] |> ignore; qc

let ag2 g n1 n2 (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Int.of_int n1; Py.Int.of_int n2 |] |> ignore; qc

let ag2_p1 g p n1 n2 (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p; Py.Int.of_int n1; Py.Int.of_int n2 |] |> ignore; qc

let ag2_p2 g p1 p2 n1 n2 (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p1; Py.Float.of_float p2; Py.Int.of_int n1; Py.Int.of_int n2 |] |> ignore; qc

let ag2_p4 g p1 p2 p3 p4 n1 n2 (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p1; Py.Float.of_float p2; Py.Float.of_float p3; Py.Float.of_float p4; Py.Int.of_int n1; Py.Int.of_int n2 |] |> ignore; qc
  
let ag3 g n1 n2 n3 (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Int.of_int n1; Py.Int.of_int n2; Py.Int.of_int n3 |] |> ignore; qc

(* TODO: *)
(* qc.initialize(desired_vector, [q[0],q[1],q[2]]) *)
let initialize state qubits (qc: qcircuit) =
  qc

let barrier (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "barrier" [| |] |> ignore; qc

let barrier_many nl (qc: qcircuit): qcircuit = 
  let nl' = Py.List.of_list_map Py.Int.of_int nl in
  Py.Module.get_function qc "barrier" [| nl' |] |> ignore; qc

let draw (qc: qcircuit): qcircuit = 
  let s = Py.Module.get_function qc "draw" [| Py.String.of_string "mpl" |] in 
  Py.Module.get_function plt "show" [||] |> ignore;
  qc

(* TODO: qasm load and export *)

(* gates *)
let reset = ag "reset"
let h = ag "h"
let x = ag "x"
let y = ag "y"
let z = ag "z"
let s = ag "s"
let sdg = ag "sdg"
let t = ag "t"
let tdg = ag "tdg"
let id = ag "id"
let p = ag_p1 "p"
let rx = ag_p1 "rx"
let ry = ag_p1 "ry"
let rz = ag_p1 "rz"
let u3 = ag_p3 "u3"
let u2 = ag_p2 "u2"

let crx = ag2_p1 "rx"
let cry = ag2_p1 "ry"
let crz = ag2_p1 "rz"
let cp = ag2_p1 "cp"
let cu = ag2_p4 "cu"

let cx = ag2 "cx"
let cy = ag2 "cy"
let cz = ag2 "cz"
let ch = ag2 "ch"
let swap = ag2 "swap"

let ccx = ag3 "ccx"
let cswap = ag3 "cswap"



(* Simulation *)
type qjob = Py.Object.t
type qres = Py.Object.t

type qcounts = Py.Object.t
type qstatevector = Py.Object.t
type qunitary = Py.Object.t



module Provider = struct 
  type qprovider = Py.Object.t
  type backend = Py.Object.t

  let get_backend (n: string) (qp: qprovider) : backend = 
    Py.Module.get_function qp "get_backend" [| Py.String.of_string n |]
end

(* TODO: Use subclassing *)

module Aer = struct 
  let get_backend (n: string) : Provider.backend = 
    let qk_aer = Py.Module.get qk "Aer" in
    Py.Module.get_function qk_aer "get_backend" [| Py.String.of_string n |]
end

module IBMProvider = struct 
  (* TODO: IBMPRovider class as an optional token parameter *)
  let ibm_provider ?(token=""): Provider.qprovider = 
    let qibm = Py.import "qiskit_ibm_provider" in
    if token <> "" then
      Py.Module.get_function qibm "IBMProvider" [| Py.String.of_string token |]
    else
      Py.Module.get_function qibm "IBMProvider" [||]

  let save_account token (iprov: Provider.qprovider) = 
    Py.Module.get_function iprov "save_account" [| Py.String.of_string token |] |> ignore;
    iprov

  let get_backend (n: string) (iprov: Provider.qprovider) : Provider.backend = 
    Py.Module.get_function iprov "get_backend" [| Py.String.of_string n |]

  let backends (iprov: Provider.qprovider) : Provider.backend list = 
    Py.List.to_list (Py.Module.get_function iprov "backends" [||])
end


(* TODO: add optional shots (get_function_with_keywords) ?(shots=1024)*)
let execute (qc: qcircuit) (sim: Provider.backend): qjob = 
  Py.Module.get_function qk "execute" [| qc; sim |]

let result (qex: qjob): qres = 
  Py.Module.get_function qex "result" [| |]

let get_statevector (qres: qres): qstatevector = 
  Py.Module.get_function qres "get_statevector" [| |]

let get_counts (qres: qres): qcounts = 
  Py.Module.get_function qres "get_counts" [| |]

let get_unitary (qres: qres) (qc: qcircuit): qunitary = 
  Py.Module.get_function qres "get_unitary" [| qc |]



(* Tools *)
module Tools = struct
  module Monitor = struct 
    let job_monitor (qj: qjob): unit =
      let qk_ts = Py.Module.get qk "tools" in
      let qk_mon = Py.Module.get qk_ts "monitor" in
      Py.Module.get_function qk_mon "job_monitor" [| qj |] |> ignore
  end
end

(* Visualization *)
(* https://qiskit.org/documentation/tutorials/circuits/2_plotting_data_in_qiskit.html *)

module Visualization = struct
  let plot_histogram (c: qcounts) = 
    let qk_vis = Py.Module.get qk "visualization" in
    let s = Py.Module.get_function qk_vis "plot_histogram" [| c |] in 
    Py.Module.get_function plt "show" [||] |> ignore


  (* from qiskit.visualization import plot_state_city, plot_bloch_multivector
  from qiskit.visualization import plot_state_paulivec, plot_state_hinton
  from qiskit.visualization import plot_state_qsphere *)
end


module Quantum_info = struct 
  (* 
  print(state_fidelity(sv1, sv2))
  print(average_gate_fidelity(op_a, op_b))
  print(process_fidelity(op_a, op_b)) *)
end


(* TODO *)
(* https://qiskit.org/documentation/tutorials/circuits_advanced/01_advanced_circuits.html *)