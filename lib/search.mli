module type T =
  sig type state val solutions : unit -> state Lazylist.list end
module type MK_T =
  functor
    (S : State.T) (ST : sig
                          type state = S.t
                          type t
                          val initial : unit -> t
                          val strategy :
                            t ->
                            state Lazylist.list ->
                            state Lazylist.list -> t * state Lazylist.list
                        end) (M : sig
                                    type state = S.t
                                    type t
                                    val initial : unit -> t
                                    val memoize : t -> state -> t
                                    val is_memoized : t -> state -> bool
                                  end) ->
    sig type state = S.t val solutions : unit -> state Lazylist.list end
module Make : MK_T
