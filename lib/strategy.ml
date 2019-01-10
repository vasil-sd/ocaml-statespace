open Lazylist

module type T = sig
  type state
  type t

  val initial : unit -> t
  val strategy : t -> state list -> state list -> t * state list
end

module type MK_T = functor (S : State.T) -> T with type state = S.t

module Breadth : MK_T =
functor
  (S : State.T)
  ->
  struct
    type state = S.t
    type t = unit

    let initial () = ()
    open Lazylist
    let strategy () (l1 : state list) l2 = ((), append l2 l1)
  end

module Depth : MK_T =
functor
  (S : State.T)
  ->
  struct
    type state = S.t
    type t = unit

    let initial () = ()
    open Lazylist
    let strategy () (l1 : state list) l2 = ((), append l1 l2)
  end
