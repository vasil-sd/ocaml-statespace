module type T = sig
  type state
  type t

  val calc : state -> t
  val compare : t -> t -> int
end

module type MK_T = functor (S : State.T) -> T with type state = S.t

module None : MK_T =
functor
  (S : State.T)
  ->
  struct
    type state = S.t
    type t = unit

    let calc _ = ()
    let compare _ _ = 0
  end

module Identity : MK_T =
functor
  (S : State.T)
  ->
  struct
    type state = S.t
    type t = S.t

    let calc x = x
    let compare = compare
  end
