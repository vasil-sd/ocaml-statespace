module type T =
  sig
    type state
    type t
    val calc : state -> t
    val compare : t -> t -> int
  end
module type MK_T =
  functor (S : State.T) -> (T with type state = S.t)
module None : MK_T
module Identity : MK_T
