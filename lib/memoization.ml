  module type FP_T = Fingerprint.T

  module type T = sig
    type state
    type t
    val initial : unit -> t
    val memoize : t -> state -> t
    val is_memoized : t -> state -> bool
    (* val iter f t *)
  end

  module type MK_T =
    functor 
      (S : State.T)
      (F : FP_T with type state = S.t) -> 
      (T with type state = S.t)

  module type MK_T_wo_FP =
    functor
      (S : State.T) ->
      (T with type state = S.t)

  module Hash : MK_T =
    functor
      (S : State.T)
      (F : FP_T) ->
    struct
      type state = S.t
      type t = (F.t, state) Hashtbl.t
      let initial () = Hashtbl.create 1024
      let memoize t s =
        Hashtbl.add t (F.calc s) s;
        t
      let is_memoized t s =
        F.calc s |> Hashtbl.mem t
    end

  module FpHash : MK_T =
    functor
      (S : State.T)
      (F : FP_T) ->
    struct
      type state = S.t
      type t = (F.t, unit) Hashtbl.t
      let initial () = Hashtbl.create 1024
      let memoize t s =
        Hashtbl.add t (F.calc s) ();
        t
      let is_memoized t s =
        F.calc s |> Hashtbl.mem t
    end

  module FpSet : MK_T =
    functor
      (S : State.T)
      (F : FP_T) ->
    struct
      type state = S.t
      module Set = Set.Make (F)
      type t = Set.t
      let initial () = Set.empty 
      let memoize t s = Set.add (F.calc s) t
      let is_memoized t s = Set.mem (F.calc s) t
    end

  module None : MK_T_wo_FP =
    functor
      (S : State.T) ->
    struct
      type state = S.t
      type t = unit
      let initial () = ()
      let memoize () (_ : state) = ()
      let is_memoized () (_ : state) = false
    end
