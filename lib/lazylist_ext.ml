type 'a orig_list = 'a list

open Lazy
open Lazylist

(*
find
fora_all
mem
exists
etc..
*)

let rec maps f s = function
  | Nil -> Nil
  | Cons (x, y) ->
      let s, x = f s x in
        Cons (x, lazy (maps f (force s) (force y)))

let mapi f l =
  let rec mapi n f = function
    | Nil -> Nil
    | Cons (x, y) ->
        Cons (lazy (f n (force x)), lazy (mapi (n + 1) f (force y)))
  in
    mapi 0 f l

let rec generates f s =
  let s, x = f s in
    Cons (x, lazy (generates f (force s)))

let rec generates_opt f s =
  match f s with
    | _, None -> Nil
    | s, Some x -> Cons (x, lazy (generates_opt f (force s)))

(*TODO: slice n list -> List.t list*)

let interleave ls = 
  let rec intlv = function
    | ([], Nil) -> Nil
    | (nl, Nil) -> intlvx ([], List.rev nl)
    | (nl, Cons (lazy Nil, lazy y)) -> intlv (nl, y)
    | (nl, Cons (lazy (Cons (x, z)), y)) -> Cons (x, lazy (intlv (force z :: nl, force y)))
  and intlvx = function
    | ([], []) -> Nil
    | (nl, []) -> intlvx ([], List.rev nl)
    | (nl, Nil :: y) -> intlvx (nl, y)
    | (nl, (Cons (x, z)):: y) -> Cons (x, lazy (intlvx (force z :: nl, y)))
  in
    intlv ([], ls)

let rec of_list : 'a orig_list -> 'a list = function
  | [] -> Nil
  | x -> Cons (lazy (List.hd x), lazy (of_list (List.tl x)))

let rec to_list : 'a list -> 'a orig_list = function
  | Nil -> []
  | Cons (lazy x, lazy y) -> x :: to_list y 
