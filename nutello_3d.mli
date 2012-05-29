val pi : float
val sti : string -> int
val its : int -> string
val stf : string -> float
val fts : float -> string
val itf : int -> float
val cts : char -> string
val abs : float -> float
val split : string -> string list
val debug : string -> unit
val rotx : float ref
val rotz : float ref
val h : float ref
val zoom : float ref
val mode : int ref
val col_r : float ref
val col_g : float ref
val col_b : float ref
val x_motion : float ref
val y_motion : float ref
val revert : bool ref
val is_init : bool ref
val read : in_channel -> (float * float * float) list
val d_rec : (float * float * float) list -> unit
val display : (float * float * float) list -> unit -> unit
val reshape : w:int -> h:int -> unit
val special : key:Glut.special_key_t -> x:'a -> y:'b -> unit
val keyboard : key:int -> x:'a -> y:'b -> unit
val mouse : button:Glut.button_t -> state:'a -> x:int -> y:int -> unit
val motion : x:int -> y:int -> unit
val idle : unit -> unit
val main : unit -> unit
