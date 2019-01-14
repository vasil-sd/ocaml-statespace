open Lazy

(*
module List = struct
  type 'a t = 'a list
end
*)

type 'a list = Nil
             | Cons of 'a Lazy.t * 'a list Lazy.t

type 'a t = 'a list

let lhd = function
  | Cons (x, _) -> x
  | Nil -> raise (Failure "hd")

let hd l = force (lhd l)

let tl = function
  | Cons (_, (lazy x)) -> x
  | Nil -> raise (Failure "tl")

let rec append a b =
  match a with
    | Nil -> b
    | Cons (x, y) -> Cons (x, lazy (append (force y) b))

let rec map f = function
  | Nil -> Nil
  | Cons (x, y) -> Cons (lazy (f (force x)), lazy (map f (force y)))

let rec concat = function
  | Nil -> Nil
  | Cons (x, (lazy y)) -> append (force x) (concat y)

let rec filter f = function
  | Nil -> Nil
  | Cons (x, y) ->
      if f (force x) then Cons (x, lazy (filter f (force y)))
      else filter f (force y)

let partition f a = (filter f a, filter (fun x -> not (f x)) a)

let rec generate f = Cons (lazy (f ()), lazy (generate f))

let take n l =
  let rec take = function
    | _, Nil -> Nil
    | i, _ when i = n -> Nil
    | i, Cons (x, y) -> Cons (x, lazy (take (i + 1, force y)))
  in
    take (0, l)

let init n f = generate f |> take n

let rec iter f = function
  | Nil -> ()
  | Cons (lazy x, lazy y) -> f x; iter f y
(*
let rec by_arrays_of n l =
  if l = Nil then Nil
  else
    let idx = ref 0 in
    let nl = ref l in
    let form_array n = 
      Array.init n (fun i -> 
                     let r = lhd !nl in
                       nl := tl !nl;
                       idx := i;
                       r)
    in
      Cons (lazy ( try form_array n
                   with _ -> nl:= l; form_array (!idx + 1)),
            lazy (by_arrays_of n !nl))


let q = generate (fun () -> 3) |> take 6 |> by_arrays_of 5

let a = hd q
let b = hd (tl q)

let rec by_lists_of : int -> 'a list -> 'a Lazy.t List.t list =
  fun n l ->
  let rec chunk = function
    | (_, c, Nil) -> Cons (from_val c, lazy Nil)
    | (i, c, m) when i = n -> Cons (from_val c, lazy (by_lists_of n m))
    | (i, c, Cons (x, lazy y)) -> chunk (i+1, x :: c, y)
  in
    chunk (0, List.[], l)
*)