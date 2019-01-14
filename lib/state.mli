module type T = sig
  open Lazylist

  type t
  module Fp : Fingerprint.T with type state_t = t

  val initial : unit -> t list
  val step : t -> t list
  val is_solution : t -> bool
end

module type MT = sig
  include T
  module S : T
  val to_state : t -> S.t
end

module MemoFp :
  functor (S : T) -> (MT with module S = S)