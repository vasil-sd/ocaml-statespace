module type T =
  sig
    type state
    val solutions : unit -> state Lazylist.list
  end
module type MK_T =
  functor
    (S : State.T)
    (ST : Strategy.T with type state = S.t)
    (M : Memoization.T with type state = S.t)
    ->
    (T with type T = S.t)
module Make : MK_T
