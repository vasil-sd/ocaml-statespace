module type T =
  sig
    type state
    type t
    val initial : unit -> t
    val strategy :
      t ->
      state Lazylist.list -> state Lazylist.list -> t * state Lazylist.list
  end
module type MK_T =
  functor (S : State.T) -> (T with type state = S.t)
module Breadth : MK_T
module Depth : MK_T
