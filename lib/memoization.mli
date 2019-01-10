module type FP_T = Fingerprint.T
module type T =
  sig
    type state
    type t
    val initial : unit -> t
    val memoize : t -> state -> t
    val is_memoized : t -> state -> bool
  end
module type MK_T =
  functor
    (S : State.T)
    (F : FP_T with type state = S.t)
    ->
    (T with type state = S.t)
module type MK_T_wo_FP =
  functor (S : State.T) -> (T with type state = S.t)
module Hash : MK_T
module FpHash : MK_T
module FpSet : MK_T
module None : MK_T_wo_FP
