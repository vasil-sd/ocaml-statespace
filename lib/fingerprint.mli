module type T =
  sig
    type state_t
    type t
    val calc : state_t -> t
    val compare : t -> t -> int
  end
module type MK_T =
  functor (S : sig type t end) -> (T with type state_t = S.t)
module None : MK_T
module Identity : MK_T
