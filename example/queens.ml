open Statespace

module Queens = struct
  type state = int array

  module FP  = struct
    type state_t = state

    type t = int64

    open Array
    open Int64

    let calc x = fold_left (fun a x -> shift_left a 3 |> add (of_int x)) zero x

    let compare = compare
  end

  module State = struct
    type t = state

    module Fp = FP

    open Lazylist
    open Lazylist_infix

    let initial () = lazy (Array.init 8 (fun _ -> 0)) |: lazy Nil

    let step s =
      let rec step = function
        | 8 -> Nil
        | x ->
            let open Array in
            let old = get s x in
            if old < 7 then (
              let ns = copy s in
              set ns x (old + 1) ;
              Lazy.from_val ns |: lazy (x + 1 |> step) )
            else x + 1 |> step
      in
      step 0

    let print s =
      let open Printf in
      printf ">" ;
      Array.iter (fun x -> printf "%i," x) s ;
      printf "\n%!"

    let is_solution s =
      let open Array in
      let result = ref true in
      iteri
        (fun i x ->
          iteri
            (fun j y ->
              if !result then
                let d = i - j in
                let safe = x <> y && x <> y - d && x <> y + d in
                result := j = i || safe )
            s )
        s ;
      !result
  end

  module MState = Statespace.State.MemoFp(State)

  module S =
    Search.Make
      (MState)
      (Strategy.Depth (MState))
      (Memoization.FpHash (MState))
end

open Lazylist

let () = Queens.S.solutions () |> map Queens.MState.to_state |> iter Queens.State.print
