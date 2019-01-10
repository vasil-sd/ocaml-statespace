type 'a orig_list = 'a list
val maps :
  ('a -> 'b Lazy.t -> 'a Lazy.t * 'c Lazy.t) ->
  'a -> 'b Lazylist.list -> 'c Lazylist.list
val mapi : (int -> 'a -> 'b) -> 'a Lazylist.list -> 'b Lazylist.list
val generates : ('a -> 'a Lazy.t * 'b Lazy.t) -> 'a -> 'b Lazylist.list
val generates_opt :
  ('a -> 'a Lazy.t * 'b Lazy.t option) -> 'a -> 'b Lazylist.list
val interleave : 'a Lazylist.list Lazylist.list -> 'a Lazylist.list
val of_list : 'a orig_list -> 'a Lazylist.list
val to_list : 'a Lazylist.list -> 'a orig_list
