Py.initialize ()

let np = Py.import "numpy"
let qk = Py.import "qiskit"
let qk_vis = Py.import "qiskit.visualization"
let qk_qinfo = Py.import "qiskit.quantum_info"
let plt = Py.import "matplotlib.pyplot"


type qcircuit = Py.Object.t

let quantum_circuit (nq: int) (nc: int): qcircuit = 
  Py.Module.get_function qk "QuantumCircuit" [| Py.Int.of_int nq; Py.Int.of_int nc |]

let from_qasm_str (s: string): qcircuit = 
  let qc = Py.Module.get qk "QuantumCircuit" in
  Py.Module.get_function qc "from_qasm_str" [| Py.String.of_string s |]

let from_qasm_file (f: string): qcircuit = 
  let qc = Py.Module.get qk "QuantumCircuit" in
  Py.Module.get_function qc "from_qasm_file" [| Py.String.of_string f |]

let qasm (qc: qcircuit): string = 
  Py.Module.get_function qc "qasm" [||] |> Py.String.to_string

let depth (qc: qcircuit): int = 
  Py.Module.get_function qc "depth" [||] |> Py.Int.to_int

let size (qc: qcircuit): int = 
  Py.Module.get_function qc "size" [||] |> Py.Int.to_int
  
let num_clbits (qc: qcircuit): int = 
  Py.Module.get qc "num_clbits" |> Py.Int.to_int

let num_qubits (qc: qcircuit): int = 
  Py.Module.get qc "num_qubits" |> Py.Int.to_int

let global_phase (qc: qcircuit): float = 
  Py.Module.get qc "global_phase" |> Py.Float.to_float

let copy (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "copy" [||]

let reset q (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "reset" [| Py.Int.of_int q |] |> ignore; qc

let measure n nto (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "measure" [| Py.Int.of_int n; Py.Int.of_int nto |] |> ignore; qc

let measure_all (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "measure_all" [| |] |> ignore; qc

let measure_many nl ntol (qc: qcircuit): qcircuit = 
  let nl' = Py.List.of_list_map Py.Int.of_int nl in
  let ntol' = Py.List.of_list_map Py.Int.of_int ntol in
  Py.Module.get_function qc "measure" [| nl'; ntol' |] |> ignore; qc

let initialize_from_int (bm: int) (qc: qcircuit) =
  let bm' = Py.Int.of_int bm in
  Py.Module.get_function qc "initialize" [| bm' |] |> ignore; qc

let initialize_from_str (lb: string) (qc: qcircuit) =
  let lb' = Py.String.of_string lb in
  Py.Module.get_function qc "initialize" [| lb' |] |> ignore; qc
    
let barrier (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "barrier" [| |] |> ignore; qc

let barrier_many nl (qc: qcircuit): qcircuit = 
  let nl' = Py.List.of_list_map Py.Int.of_int nl in
  Py.Module.get_function qc "barrier" [| nl' |] |> ignore; qc

let draw (qc: qcircuit): qcircuit = 
  let _ = Py.Module.get_function qc "draw" [| Py.String.of_string "mpl" |] in 
  Py.Module.get_function plt "show" [||] |> ignore;
  qc
  

(* Gates utilities *)
let ag_p3 g p1 p2 p3 n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p1; Py.Float.of_float p2; Py.Float.of_float p3; Py.Int.of_int n |] |> ignore; qc

let ag_p2 g p1 p2 n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p1; Py.Float.of_float p2; Py.Int.of_int n |] |> ignore; qc
  
let ag_p1 g p n (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc g [| Py.Float.of_float p; Py.Int.of_int n |] |> ignore; qc

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


(* Gates *)
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
let toffoli = ccx
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

module Aer = struct 
  let get_backend (n: string) : Provider.backend = 
    let qk_aer = Py.Module.get qk "Aer" in
    Py.Module.get_function qk_aer "get_backend" [| Py.String.of_string n |]
end

module IBMProvider = struct 
  (* TODO: IBMPRovider class as an optional token parameter *)
  let ibm_provider ?(token="") (_: unit): Provider.qprovider = 
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
    let qk_ts = Py.Module.get qk "tools"
    let qk_mon = Py.Module.get qk_ts "monitor"

    let job_monitor (qj: qjob): unit =
      Py.Module.get_function qk_mon "job_monitor" [| qj |] |> ignore

    let status (qj: qjob): string =
      Py.Module.get_function qk_mon "status" [| qj |] |> Py.Object.to_string
  end
end


(* Visualization *)
(* https://qiskit.org/documentation/tutorials/circuits/2_plotting_data_in_qiskit.html *)
module Visualization = struct
  let plot_histogram (c: qcounts) = 
    let _ = Py.Module.get_function qk_vis "plot_histogram" [| c |] in 
    Py.Module.get_function plt "show" [||] |> ignore

  let plot_state_city (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_city" [| s |] in 
    Py.Module.get_function plt "show" [||] |> ignore

  let plot_bloch_multivector (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_bloch_multivector" [| s |] in 
    Py.Module.get_function plt "show" [||] |> ignore

  let plot_state_paulivec (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_paulivec" [| s |] in 
    Py.Module.get_function plt "show" [||] |> ignore

  let plot_state_hinton (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_hinton" [| s |] in 
    Py.Module.get_function plt "show" [||] |> ignore

  let plot_state_qsphere (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_qsphere" [| s |] in 
    Py.Module.get_function plt "show" [||] |> ignore
end


module Quantum_info = struct 
  let state_fidelity (sv1: qstatevector) (sv2: qstatevector) : float =
    let s = Py.Module.get_function qk_qinfo "state_fidelity" [| sv1; sv2 |] in 
    Py.Float.to_float s
  
  (* TODO *)
  (* print(average_gate_fidelity(op_a, op_b))
  print(process_fidelity(op_a, op_b)) *)
end


(* TODO *)
(* https://qiskit.org/documentation/tutorials/circuits_advanced/01_advanced_circuits.html *)