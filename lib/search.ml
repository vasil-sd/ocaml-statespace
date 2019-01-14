module type T = sig
  open Lazylist
  module State : State.T
  val solutions : unit -> State.t list
end

module type MK_T =
  functor 
    (S: State.T)
    (ST: Strategy.T with module State = S)
    (M: Memoization.T with module State = S) ->
    (T with module State = S)

module Make : MK_T =
  functor 
    (S: State.T)
    (ST: Strategy.T with module State = S)
    (M: Memoization.T with module State = S) ->
  struct
    module State = S
    let solutions () =
      let open! Lazylist in
      let initial = State.initial () in
      let memo = M.initial () |> ref in
      let rec all_solutions st = function
        | Nil -> Nil
        | Cons (lazy x, lazy y) ->
            let new_states = 
              State.step x
              |> filter (fun s -> not @@ M.is_memoized !memo s) 
            in
              memo := M.memoize !memo x;
              let st, s = ST.strategy st new_states y in
                Cons (Lazy.from_val x, lazy (all_solutions st s))
      in
        all_solutions (ST.initial ()) initial
        |> filter State.is_solution
  end
