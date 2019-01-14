module type T =
  sig
    module State : State.T
    type t
    val initial : unit -> t
    val strategy :
      t ->
      State.t Lazylist.list -> State.t Lazylist.list -> t * State.t Lazylist.list
  end
module type MK_T =
  functor (S : State.T) -> (T with module State = S)
module Breadth : MK_T
module Depth : MK_T
