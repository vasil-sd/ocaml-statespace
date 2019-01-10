open Lazy

type 'a list = Nil | Cons of 'a Lazy.t * 'a list Lazy.t

type 'a t = 'a list

let hd = function Cons (x, _) -> force x | Nil -> raise (Failure "hd")

let tl = function Cons (_, (lazy x)) -> x | Nil -> raise (Failure "tl")

let rec append a b =
  match a with Nil -> b | Cons (x, y) -> Cons (x, lazy (append (force y) b))

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
