type 'a list = Nil | Cons of 'a Lazy.t * 'a list Lazy.t
type 'a t = 'a list
val hd : 'a list -> 'a
val tl : 'a list -> 'a list
val append : 'a list -> 'a list -> 'a list
val map : ('a -> 'b) -> 'a list -> 'b list
val concat : 'a list list -> 'a list
val filter : ('a -> bool) -> 'a list -> 'a list
val partition : ('a -> bool) -> 'a list -> 'a list * 'a list
val generate : (unit -> 'a) -> 'a list
val take : int -> 'a list -> 'a list
val init : int -> (unit -> 'a) -> 'a list
val iter : ('a -> unit) -> 'a list -> unit