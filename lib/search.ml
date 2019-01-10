module type T = sig
  open Lazylist
  type state
  val solutions : unit -> state list
end

module type MK_T =
  functor 
    (S: State.T)
    (ST: Strategy.T with type state = S.t)
    (M: Memoization.T with type state = S.t) ->
    (T with type state = S.t)

module Make : MK_T =
  functor 
    (S: State.T)
    (ST: Strategy.T with type state = S.t)
    (M: Memoization.T with type state = S.t) ->
  struct
    type state = S.t
    let solutions () =
      let open! Lazylist in
      let initial = S.initial () in
      let memo = M.initial () |> ref in
      let rec all_solutions st = function
        | Nil -> Nil
        | Cons (lazy x, lazy y) ->
            let new_states = 
              S.step x
              |> filter (fun s -> not @@ M.is_memoized !memo s) 
            in
              memo := M.memoize !memo x;
              let st, s = ST.strategy st new_states y in
                Cons (Lazy.from_val x, lazy (all_solutions st s))
      in
        all_solutions (ST.initial ()) initial
        |> filter S.is_solution
  end
