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

(** OCaml wrapper for the IBM Qiskit quantum computing toolkit.

    Quantum circuits are built by piping a {!qcircuit} through gate and
    circuit manipulation functions, and then executed on a backend such as
    {!aer_simulator} or a real IBM quantum computer through {!IBMRuntime}:

    {[
      let qc = quantum_circuit 2 2 |> h 0 |> cx 0 1 |> measure 0 0 |> measure 1 1 in
      aer_simulator "statevector" |> run qc |> result |> get_counts
      |> Visualization.plot_histogram
    ]}

    Every value is a thin wrapper around the corresponding qiskit Python
    object (through pyml), so unwrapped features remain accessible with the
    [Py] module. *)

Py.initialize ()

let np = Py.import "numpy"
let qk = Py.import "qiskit"
let qk_vis = Py.import "qiskit.visualization"
let qk_qinfo = Py.import "qiskit.quantum_info"
let plt = Py.import "matplotlib.pyplot"


(** A quantum circuit (wraps qiskit [QuantumCircuit]). *)
type qcircuit = Py.Object.t

(** [quantum_circuit nq nc] creates a new circuit with [nq] qubits and [nc]
    classical bits. *)
let quantum_circuit (nq: int) (nc: int): qcircuit =
  Py.Module.get_function qk "QuantumCircuit" [| Py.Int.of_int nq; Py.Int.of_int nc |]

(** [from_qasm_str s] creates a circuit from an OpenQASM 2 string. *)
let from_qasm_str (s: string): qcircuit =
  let qc = Py.Module.get qk "QuantumCircuit" in
  Py.Module.get_function qc "from_qasm_str" [| Py.String.of_string s |]

(** [from_qasm_file f] creates a circuit from an OpenQASM 2 file. *)
let from_qasm_file (f: string): qcircuit =
  let qc = Py.Module.get qk "QuantumCircuit" in
  Py.Module.get_function qc "from_qasm_file" [| Py.String.of_string f |]

(** [depth qc] returns the depth of the circuit. *)
let depth (qc: qcircuit): int =
  Py.Module.get_function qc "depth" [||] |> Py.Int.to_int

(** [size qc] returns the total number of instructions in the circuit. *)
let size (qc: qcircuit): int =
  Py.Module.get_function qc "size" [||] |> Py.Int.to_int

(** [num_clbits qc] returns the number of classical bits. *)
let num_clbits (qc: qcircuit): int =
  Py.Module.get qc "num_clbits" |> Py.Int.to_int

(** [num_qubits qc] returns the number of qubits. *)
let num_qubits (qc: qcircuit): int =
  Py.Module.get qc "num_qubits" |> Py.Int.to_int

(** [global_phase qc] returns the global phase of the circuit in radians. *)
let global_phase (qc: qcircuit): float =
  Py.Module.get qc "global_phase" |> Py.Float.to_float

(** [copy qc] returns a copy of the circuit. *)
let copy (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "copy" [||]

(** [reset q qc] resets the qubit [q] to the |0> state. *)
let reset q (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "reset" [| Py.Int.of_int q |] |> ignore; qc

(** [measure n nto qc] measures the qubit [n] into the classical bit [nto]. *)
let measure n nto (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "measure" [| Py.Int.of_int n; Py.Int.of_int nto |] |> ignore; qc

(** [measure_all qc] measures every qubit into a new classical register. *)
let measure_all (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "measure_all" [| |] |> ignore; qc

(** [measure_many nl ntol qc] measures the qubits [nl] into the classical
    bits [ntol]. *)
let measure_many nl ntol (qc: qcircuit): qcircuit =
  let nl' = Py.List.of_list_map Py.Int.of_int nl in
  let ntol' = Py.List.of_list_map Py.Int.of_int ntol in
  Py.Module.get_function qc "measure" [| nl'; ntol' |] |> ignore; qc

(** [initialize_from_int bm qc] initializes the circuit state from the bitmap
    [bm] (e.g. [2] for |10>). *)
let initialize_from_int (bm: int) (qc: qcircuit) =
  let bm' = Py.Int.of_int bm in
  Py.Module.get_function qc "initialize" [| bm' |] |> ignore; qc

(** [initialize_from_str lb qc] initializes the circuit state from the label
    [lb] (e.g. ["10"] for |10>). *)
let initialize_from_str (lb: string) (qc: qcircuit) =
  let lb' = Py.String.of_string lb in
  Py.Module.get_function qc "initialize" [| lb' |] |> ignore; qc

(* importing qiskit_aer injects the save_* methods into QuantumCircuit *)
let qk_aer = lazy (Py.import "qiskit_aer")

(** [save_state qc] saves the simulator state (requires qiskit_aer). *)
let save_state (qc: qcircuit): qcircuit =
  Lazy.force qk_aer |> ignore;
  Py.Module.get_function qc "save_state" [| |] |> ignore; qc

(** [remove_final_measurements qc] removes the final measurements (and the
    classical registers left unused) from the circuit. *)
let remove_final_measurements (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "remove_final_measurements" [| |] |> ignore; qc

(** [barrier qc] applies a barrier on all qubits. *)
let barrier (qc: qcircuit): qcircuit =
  Py.Module.get_function qc "barrier" [| |] |> ignore; qc

(** [barrier_many nl qc] applies a barrier on the qubits [nl]. *)
let barrier_many nl (qc: qcircuit): qcircuit =
  let nl' = Py.List.of_list_map Py.Int.of_int nl in
  Py.Module.get_function qc "barrier" [| nl' |] |> ignore; qc

(** [draw qc] shows the circuit using the matplotlib drawer. *)
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

(** [h n qc] applies an Hadamard gate on qubit [n]. *)
let h = ag "h"

(** [x n qc] applies a Pauli-X (NOT) gate on qubit [n]. *)
let x = ag "x"

(** [y n qc] applies a Pauli-Y gate on qubit [n]. *)
let y = ag "y"

(** [z n qc] applies a Pauli-Z gate on qubit [n]. *)
let z = ag "z"

(** [s n qc] applies an S gate (sqrt(Z)) on qubit [n]. *)
let s = ag "s"

(** [sdg n qc] applies an S-dagger gate on qubit [n]. *)
let sdg = ag "sdg"

(** [t n qc] applies a T gate on qubit [n]. *)
let t = ag "t"

(** [tdg n qc] applies a T-dagger gate on qubit [n]. *)
let tdg = ag "tdg"

(** [id n qc] applies an identity gate on qubit [n]. *)
let id = ag "id"

(** [p theta n qc] applies a phase gate with angle [theta] on qubit [n]. *)
let p = ag_p1 "p"

(** [rx theta n qc] applies a rotation around the X axis on qubit [n]. *)
let rx = ag_p1 "rx"

(** [ry theta n qc] applies a rotation around the Y axis on qubit [n]. *)
let ry = ag_p1 "ry"

(** [rz theta n qc] applies a rotation around the Z axis on qubit [n]. *)
let rz = ag_p1 "rz"

(** [u theta phi lam n qc] applies a generic single-qubit rotation. *)
let u = ag_p3 "u"

(** [u3 theta phi lam n qc] is {!u} (the u3 gate was removed from qiskit). *)
let u3 = ag_p3 "u"

(** [u2 phi lam n qc] applies [u pi/2 phi lam n] (the u2 gate was removed
    from qiskit). *)
let u2 phi lam = ag_p3 "u" (2.0 *. atan 1.0) phi lam

(** [crx theta nctl ntgt qc] applies a controlled-RX gate. *)
let crx = ag2_p1 "crx"

(** [cry theta nctl ntgt qc] applies a controlled-RY gate. *)
let cry = ag2_p1 "cry"

(** [crz theta nctl ntgt qc] applies a controlled-RZ gate. *)
let crz = ag2_p1 "crz"

(** [cp theta nctl ntgt qc] applies a controlled phase gate. *)
let cp = ag2_p1 "cp"

(** [cu theta phi lam gamma nctl ntgt qc] applies a controlled-U gate. *)
let cu = ag2_p4 "cu"

(** [cx nctl ntgt qc] applies a controlled-X (CNOT) gate. *)
let cx = ag2 "cx"

(** [cy nctl ntgt qc] applies a controlled-Y gate. *)
let cy = ag2 "cy"

(** [cz nctl ntgt qc] applies a controlled-Z gate. *)
let cz = ag2 "cz"

(** [ch nctl ntgt qc] applies a controlled-Hadamard gate. *)
let ch = ag2 "ch"

(** [swap n1 n2 qc] applies a SWAP gate. *)
let swap = ag2 "swap"

(** [ccx nctl1 nctl2 ntgt qc] applies a Toffoli (CCX) gate. *)
let ccx = ag3 "ccx"

(** Alias of {!ccx}. *)
let toffoli = ccx

(** [cswap nctl n1 n2 qc] applies a controlled-SWAP (Fredkin) gate. *)
let cswap = ag3 "cswap"



(* Simulation *)

(** An execution job. *)
type qjob = Py.Object.t

(** The result of an execution job. *)
type qres = Py.Object.t

(** Measurement counts. *)
type qcounts = Py.Object.t

(** A statevector. *)
type qstatevector = Py.Object.t

(** A unitary matrix. *)
type qunitary = Py.Object.t


(** OpenQASM 2 serialization. *)
module Qasm2 = struct
  let qasm2 = Py.import "qiskit.qasm2"

  (** [dump qc] returns the OpenQASM 2 representation of the circuit. *)
  let dump (qc: qcircuit): string =
    Py.Module.get_function qasm2 "dumps" [| qc |] |> Py.String.to_string

end

(** Provider and backend types. *)
module Provider = struct
  (** A backend provider. *)
  type qprovider = Py.Object.t

  (** An execution backend (simulator or real hardware). *)
  type backend = Py.Object.t
end

(** Qiskit built-in, pure python simulator provider. *)
module BasicProvider = struct
  let bp_providers = Py.import "qiskit.providers.basic_provider"

  (** [basic_provider ()] returns the provider instance. *)
  let basic_provider (_: unit): Provider.qprovider =
    Py.Module.get_function bp_providers "BasicProvider" [||]

  (** [get_backend n prov] returns the backend named [n]. *)
  let get_backend (n: string) (iprov: Provider.qprovider) : Provider.backend =
    Py.Module.get_function iprov "get_backend" [| Py.String.of_string n |]
end

(** [aer_simulator meth] creates an AerSimulator backend using the simulation
    method [meth] (e.g. ["automatic"], ["statevector"], ["unitary"]). *)
let aer_simulator (meth: string): Provider.backend =
  Py.Module.get_function_with_keywords (Lazy.force qk_aer) "AerSimulator"
    [||] [("method", Py.String.of_string meth)]

(** IBM quantum cloud access through the legacy qiskit_ibm_provider package.

    @deprecated qiskit_ibm_provider has been retired by IBM and does not work
    with qiskit >= 2.0; use {!IBMRuntime} instead. *)
module IBMProvider = struct
  (* deprecated in qiskit>=2, importing lazily *)
  let qibm = lazy (Py.import "qiskit_ibm_provider")

  (* TODO: IBMPRovider class as an optional token parameter *)
  let ibm_provider ?(token="") (_: unit): Provider.qprovider =
    if token <> "" then
      Py.Module.get_function (Lazy.force qibm) "IBMProvider" [| Py.String.of_string token |]
    else
      Py.Module.get_function (Lazy.force qibm) "IBMProvider" [||]

  let job_monitor (qj: qjob): unit =
    Py.Module.get_function (Lazy.force qibm) "job_monitor" [| qj |] |> ignore

  let save_account token (iprov: Provider.qprovider) =
    Py.Module.get_function iprov "save_account" [| Py.String.of_string token |] |> ignore;
    iprov

  let get_backend (n: string) (iprov: Provider.qprovider) : Provider.backend =
    Py.Module.get_function iprov "get_backend" [| Py.String.of_string n |]

  let backends (iprov: Provider.qprovider) : Provider.backend list =
    Py.List.to_list (Py.Module.get_function iprov "backends" [||])
end

(** IBM quantum cloud access through qiskit-ibm-runtime, the supported
    package for qiskit >= 1.0.

    Real hardware only accepts primitives, so circuits must be transpiled
    for the backend and run through a {!IBMRuntime.sampler}:

    {[
      let serv = IBMRuntime.service ~token:"TOKEN" () in
      let backend = IBMRuntime.least_busy serv in
      let j = IBMRuntime.sampler backend |> IBMRuntime.run (transpile qc backend) in
      j |> result |> IBMRuntime.get_counts |> Visualization.plot_histogram
    ]}

    Passing an Aer backend (e.g. {!aer_simulator}) to {!IBMRuntime.sampler}
    runs the circuit locally instead. *)
module IBMRuntime = struct
  (** A SamplerV2 primitive bound to a backend. *)
  type qsampler = Py.Object.t

  let qruntime = lazy (Py.import "qiskit_ibm_runtime")

  (** [service ()] connects to the IBM quantum platform using the saved
      account, or with [~token] if given. *)
  let service ?(token="") (_: unit): Provider.qprovider =
    let m = Lazy.force qruntime in
    if token <> "" then
      Py.Module.get_function_with_keywords m "QiskitRuntimeService"
        [||] [("token", Py.String.of_string token)]
    else
      Py.Module.get_function m "QiskitRuntimeService" [||]

  (** [save_account token] saves the IBM quantum platform account credentials
      on disk; [~instance] selects a specific cloud instance (CRN) and
      [~overwrite] replaces previously saved credentials. *)
  let save_account ?(instance="") ?(overwrite=false) (token: string): unit =
    let cls = Py.Module.get (Lazy.force qruntime) "QiskitRuntimeService" in
    let kw = [("channel", Py.String.of_string "ibm_quantum_platform");
              ("token", Py.String.of_string token);
              ("overwrite", Py.Bool.of_bool overwrite)] in
    let kw = if instance <> "" then ("instance", Py.String.of_string instance)::kw else kw in
    Py.Module.get_function_with_keywords cls "save_account" [||] kw |> ignore

  (** [get_backend n serv] returns the backend named [n]. *)
  let get_backend (n: string) (serv: Provider.qprovider): Provider.backend =
    Py.Module.get_function serv "backend" [| Py.String.of_string n |]

  (** [backends serv] returns the available backends. *)
  let backends (serv: Provider.qprovider): Provider.backend list =
    Py.List.to_list (Py.Module.get_function serv "backends" [||])

  (** [least_busy serv] returns the least busy operational backend. *)
  let least_busy (serv: Provider.qprovider): Provider.backend =
    Py.Module.get_function serv "least_busy" [||]

  (** [sampler b] creates a SamplerV2 primitive running on backend [b]. *)
  let sampler (b: Provider.backend): qsampler =
    Py.Module.get_function_with_keywords (Lazy.force qruntime) "SamplerV2"
      [||] [("mode", b)]

  (** [run qc s] submits the circuit to the sampler; [qc] must be transpiled
      for the sampler backend (see {!transpile}). *)
  let run (qc: qcircuit) (s: qsampler): qjob =
    Py.Module.get_function s "run" [| Py.List.of_list [qc] |]

  (** [job_status j] returns the job status as a string. *)
  let job_status (j: qjob): string =
    Py.Module.get_function j "status" [||] |> Py.Object.to_string

  (** [get_counts r] returns the counts of the first pub result, with all
      classical registers joined. *)
  let get_counts (r: qres): qcounts =
    let pub = Py.Sequence.get_item r 0 in
    let data = Py.Module.get_function pub "join_data" [||] in
    Py.Module.get_function data "get_counts" [||]
end


(* TODO: add optional shots (get_function_with_keywords) ?(shots=1024)*)

(** [run qc sim] runs the circuit on the backend and returns the job. *)
let run (qc: qcircuit) (sim: Provider.backend): qjob =
  Py.Module.get_function sim "run" [| qc |]

(** [transpile qc sim] transpiles the circuit for the backend. *)
let transpile (qc: qcircuit) (sim: Provider.backend): qjob =
  Py.Module.get_function qk "transpile" [| qc; sim |]

(** [result j] waits for the job to complete and returns its result. *)
let result (qex: qjob): qres =
  Py.Module.get_function qex "result" [| |]

(** [get_statevector res] returns the final statevector. *)
let get_statevector (qres: qres): qstatevector =
  Py.Module.get_function qres "get_statevector" [| |]

(** [get_counts res] returns the measurement counts. *)
let get_counts (qres: qres): qcounts =
  Py.Module.get_function qres "get_counts" [| |]

(** [get_unitary res qc] returns the unitary matrix of the circuit. *)
let get_unitary (qres: qres) (qc: qcircuit): qunitary =
  Py.Module.get_function qres "get_unitary" [| qc |]



(* https://qiskit.org/documentation/tutorials/circuits/2_plotting_data_in_qiskit.html *)

(** Matplotlib based visualization helpers; every function opens the plot in
    a matplotlib window. *)
module Visualization = struct
  (** [plot_histogram c] plots the counts as a histogram. *)
  let plot_histogram (c: qcounts) =
    let _ = Py.Module.get_function qk_vis "plot_histogram" [| c |] in
    Py.Module.get_function plt "show" [||] |> ignore

  (** [plot_state_city s] plots the state as a cityscape. *)
  let plot_state_city (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_city" [| s |] in
    Py.Module.get_function plt "show" [||] |> ignore

  (** [plot_bloch_multivector s] plots the state on Bloch spheres. *)
  let plot_bloch_multivector (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_bloch_multivector" [| s |] in
    Py.Module.get_function plt "show" [||] |> ignore

  (** [plot_state_paulivec s] plots the state in the Pauli basis. *)
  let plot_state_paulivec (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_paulivec" [| s |] in
    Py.Module.get_function plt "show" [||] |> ignore

  (** [plot_state_hinton s] plots the state as a Hinton diagram. *)
  let plot_state_hinton (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_hinton" [| s |] in
    Py.Module.get_function plt "show" [||] |> ignore

  (** [plot_state_qsphere s] plots the state on a qsphere. *)
  let plot_state_qsphere (s: qstatevector) =
    let _ = Py.Module.get_function qk_vis "plot_state_qsphere" [| s |] in
    Py.Module.get_function plt "show" [||] |> ignore
end


(** Quantum information utilities. *)
module Quantum_info = struct
  (** [state_fidelity sv1 sv2] computes the fidelity between two states. *)
  let state_fidelity (sv1: qstatevector) (sv2: qstatevector) : float =
    let s = Py.Module.get_function qk_qinfo "state_fidelity" [| sv1; sv2 |] in
    Py.Float.to_float s

  (** [statevector qc] computes the exact statevector of the circuit. *)
  let statevector (qc: qcircuit) : qstatevector =
    Py.Module.get_function qk_qinfo "Statevector" [| qc |]

  (* TODO *)
  (* print(average_gate_fidelity(op_a, op_b))
  print(process_fidelity(op_a, op_b)) *)
end


(* TODO *)
(* https://qiskit.org/documentation/tutorials/circuits_advanced/01_advanced_circuits.html *)
