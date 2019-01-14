module type T = sig
  module State : State.T
  type t

  val initial : unit -> t
  val memoize : t -> State.t -> t
  val is_memoized : t -> State.t -> bool

(* 
  val find_opt : State.Fp.t -> State.t option
  val iter_fp : (State.Fp.t -> unit) -> t -> unit
  val inter_s : (State.t -> unit) -> t -> unit
*)

end

module type MK_T =
  functor
    (S : State.T)
    ->
    T with module State = S

module Hash : MK_T =
functor
  (S : State.T)
  ->
  struct
    module State = S
    type t = (State.Fp.t, State.t) Hashtbl.t

    let initial () = Hashtbl.create 1024

    let memoize t s =
      Hashtbl.add t (State.Fp.calc s) s ;
      t

    let is_memoized t s = State.Fp.calc s |> Hashtbl.mem t
  end

module FpHash : MK_T =
functor
  (S : State.T)
  ->
  struct
    module State = S
    type t = (State.Fp.t, unit) Hashtbl.t

    let initial () = Hashtbl.create 1024

    let memoize t s =
      Hashtbl.add t (State.Fp.calc s) () ;
      t

    let is_memoized t s = State.Fp.calc s |> Hashtbl.mem t
  end

module FpSet : MK_T =
functor
  (S : State.T)
  ->
  struct
    module State = S
    module Set = Set.Make (State.Fp)

    type t = Set.t

    let initial () = Set.empty
    let memoize t s = Set.add (State.Fp.calc s) t
    let is_memoized t s = Set.mem (State.Fp.calc s) t
  end

module None : MK_T =
functor
  (S : State.T)
  ->
  struct
    module State = S
    type t = unit

    let initial () = ()
    let memoize () (_ : State.t) = ()
    let is_memoized () (_ : State.t) = false
  end
