open Lazylist

module type T = sig
  module State : State.T
  type t

  val initial : unit -> t
  val strategy : t -> State.t list -> State.t list -> t * State.t list
end

module type MK_T = functor (S : State.T) -> T with module State = S

module Breadth : MK_T =
functor
  (S : State.T)
  ->
  struct
    module State = S
    type t = unit

    let initial () = ()
    open Lazylist
    let strategy () (l1 : State.t list) l2 = ((), append l2 l1)
  end

module Depth : MK_T =
functor
  (S : State.T)
  ->
  struct
    module State = S
    type t = unit

    let initial () = ()
    open Lazylist
    let strategy () (l1 : State.t list) l2 = ((), append l1 l2)
  end
