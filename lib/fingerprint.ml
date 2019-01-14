module type T = sig
  type state_t
  type t

  val calc : state_t -> t
  val compare : t -> t -> int
end

module type MK_T = functor (S : sig type t end) -> T with type state_t = S.t

module None : MK_T =
functor
  (S : sig type t end)
  ->
  struct
    type state_t = S.t
    type t = unit

    let calc _ = ()
    let compare _ _ = 0
  end

module Identity : MK_T =
functor
  (S : sig type t end)
  ->
  struct
    type state_t = S.t
    type t = state_t

    let calc x = x
    let compare = compare
  end
