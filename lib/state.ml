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

module MemoFp =
  functor (S : T) -> 
  struct
    open Lazylist
    module S = S
    type t = { state: S.t; fp: S.Fp.t }
    module Fp : (Fingerprint.T with type state_t = t and type t = S.Fp.t )= struct
      type state_t = t
      type t = S.Fp.t
      let calc s =  s.fp
      let compare = S.Fp.compare
    end
    let initial () =
      S.initial ()
      |> map (fun state -> 
              let fp = S.Fp.calc state in
              {state; fp})
    let step {state; _} =
      S.step state
      |> map (fun state ->
              let fp = S.Fp.calc state in
              {state; fp})
    let is_solution {state; _} = S.is_solution state
    let to_state {state; _} = state
  end
