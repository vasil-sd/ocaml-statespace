module type T =
  sig
    module State : State.T
    val solutions : unit -> State.t Lazylist.list
  end
module type MK_T =
  functor
    (S : State.T)
    (ST : Strategy.T with module State = S)
    (M : Memoization.T with module State = S)
    ->
    (T with module State = S)
module Make : MK_T
