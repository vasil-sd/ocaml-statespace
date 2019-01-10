open Statespace
module Queens = struct
  module State = struct
    type t = int array

    let initial () = Lazylist_infix.(lazy (Array.init 8 (fun _ -> 0)) |: lazy Lazylist.Nil)

    let step s =
      let open Lazylist_infix in
      let rec step = function
        | 8 -> Lazylist.Nil
        | x ->
            let open Array in
            let old = get s x in
            if old < 7 then
              let ns = copy s in
              let () = old + 1 |> set ns x in
              Lazy.from_val ns |: lazy (x + 1 |> step)
            else x + 1 |> step
      in
      step 0

    let print s =
      let open Printf in
      printf ">" ;
      Array.iter (fun x -> printf "%i," x) s ;
      printf "\n%!"

    let is_solution_a s =
      let open! Array in
      let result = ref true in
      iteri
        (fun i x ->
          iteri
            (fun j y ->
              let d = i - j in
              let safe = x <> y && x <> y - d && x <> y + d in
              let ok = j = i || safe in
              if not ok then result := false )
            s )
        s ;
      !result

    let is_solution_b s =
      fst
      @@ Array.fold_left
           (fun (r, i) x ->
             ( r
               && fst
                  @@ Array.fold_left
                       (fun (r, j) y ->
                         if r then
                           let d = i - j in
                           let safe = x <> y && x <> y - d && x <> y + d in
                           let nr = j = i || safe in
                           (nr, j + 1)
                         else (false, 0) )
                       (true, 0) s
             , i + 1 ) )
           (true, 0) s

    let is_solution = is_solution_b
  end

  module FP = struct
    type state = State.t

    type t = int64

    let calc x =
      Array.(
        Int64.(fold_left (fun a x -> shift_left a 3 |> add (of_int x)) zero x))

    let compare = Int64.compare
  end

  module S =
    Search.Make
      (State)
      (Strategy.Depth (State))
      (Memoization.FpHash (State) (FP))
end

open Lazylist

let rec print_all = function
  | Nil -> ()
  | Cons ((lazy s), (lazy rest)) -> Queens.State.print s ; print_all rest

let () = Queens.S.solutions () |> print_all
