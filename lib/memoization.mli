module type T =
  sig
    module State : State.T
    type t
    val initial : unit -> t
    val memoize : t -> State.t -> t
    val is_memoized : t -> State.t -> bool
  end
module type MK_T =
  functor
    (S : State.T)
    ->
    (T with module State = S)
module Hash : MK_T
module FpHash : MK_T
module FpSet : MK_T
module None : MK_T
