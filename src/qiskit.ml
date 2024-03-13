(* Copyright (c) 2020-2024 Davide Gessa

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE. *)

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

let save_state (qc: qcircuit): qcircuit = 
  Py.Module.get_function qc "save_state" [| |] |> ignore; qc    

let remove_final_measurements (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "remove_final_measurements" [| |] |> ignore; qc    

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


module Qasm2 = struct 
  let qasm2 = Py.import "qiskit.qasm2" 

  let dump (qc: qcircuit): string = 
    Py.Module.get_function qasm2 "dumps" [| qc |] |> Py.String.to_string

end

module Provider = struct 
  type qprovider = Py.Object.t
  type backend = Py.Object.t
end

module BasicProvider = struct 
  let bp_providers = Py.import "qiskit.providers.basic_provider" 

  let basic_provider (_: unit): Provider.qprovider = 
    Py.Module.get_function bp_providers "BasicProvider" [||]

  let get_backend (n: string) (iprov: Provider.qprovider) : Provider.backend = 
    Py.Module.get_function iprov "get_backend" [| Py.String.of_string n |]
end

let aer_simulator (meth: string): Provider.backend = 
  let m = Py.Import.add_module "aer_wrap" in
  Py.Run.eval ~start:Py.File "import aer_wrap, qiskit_aer\naer_wrap.wrap = lambda m: qiskit_aer.AerSimulator(method=m)" |> ignore;
  Py.Module.get_function m "wrap" [| Py.String.of_string meth |]

module IBMProvider = struct 
  let qibm = Py.import "qiskit_ibm_provider"

  (* TODO: IBMPRovider class as an optional token parameter *)
  let ibm_provider ?(token="") (_: unit): Provider.qprovider = 
    if token <> "" then
      Py.Module.get_function qibm "IBMProvider" [| Py.String.of_string token |]
    else
      Py.Module.get_function qibm "IBMProvider" [||]

  let job_monitor (qj: qjob): unit =
    Py.Module.get_function qibm "job_monitor" [| qj |] |> ignore
    
  let save_account token (iprov: Provider.qprovider) = 
    Py.Module.get_function iprov "save_account" [| Py.String.of_string token |] |> ignore;
    iprov

  let get_backend (n: string) (iprov: Provider.qprovider) : Provider.backend = 
    Py.Module.get_function iprov "get_backend" [| Py.String.of_string n |]

  let backends (iprov: Provider.qprovider) : Provider.backend list = 
    Py.List.to_list (Py.Module.get_function iprov "backends" [||])
end


(* TODO: add optional shots (get_function_with_keywords) ?(shots=1024)*)
let run (qc: qcircuit) (sim: Provider.backend): qjob = 
  Py.Module.get_function sim "run" [| qc |]

let transpile (qc: qcircuit) (sim: Provider.backend): qjob = 
  Py.Module.get_function qk "transpile" [| qc; sim |]

let result (qex: qjob): qres = 
  Py.Module.get_function qex "result" [| |]

let get_statevector (qres: qres): qstatevector = 
  Py.Module.get_function qres "get_statevector" [| |]

let get_counts (qres: qres): qcounts = 
  Py.Module.get_function qres "get_counts" [| |]

let get_unitary (qres: qres) (qc: qcircuit): qunitary = 
  Py.Module.get_function qres "get_unitary" [| qc |]



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
  
  let statevector (qc: qcircuit) : qstatevector = 
    Py.Module.get_function qk_qinfo "Statevector" [| qc |]

  (* TODO *)
  (* print(average_gate_fidelity(op_a, op_b))
  print(process_fidelity(op_a, op_b)) *)
end


(* TODO *)
(* https://qiskit.org/documentation/tutorials/circuits_advanced/01_advanced_circuits.html *)