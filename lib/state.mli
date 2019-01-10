module type T = sig
  open Lazylist

  type t

  val initial : unit -> t list
  val step : t -> t list
  val is_solution : t -> bool
end
