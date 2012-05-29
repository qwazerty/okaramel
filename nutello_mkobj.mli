val get_dims : Sdlvideo.surface -> int * int
val sdl_init : unit -> unit
val gpc : Sdlvideo.surface -> x:int -> y:int -> Sdlvideo.color
val ppc : Sdlvideo.surface -> x:int -> y:int -> Sdlvideo.color -> unit
val its : int -> string
val fti : float -> int
val itf : int -> float
val sti : string -> int
val stf : string -> float
val fts : float -> string
val min2 : 'a -> 'a -> 'a
val min : 'a -> 'a -> 'a -> 'a
val max2 : 'a -> 'a -> 'a
val max : 'a -> 'a -> 'a -> 'a
val al : int -> string
val alf : int -> string
val alh : int -> string
val nl : string
val is_inlist : 'a * 'b * 'c -> ('a * 'b * 'c) list -> bool
val get_color : Sdlvideo.surface -> Sdlvideo.color list
val add_asked_height : ('a * 'b * 'c) list -> ('a * 'b * 'c * int) list
val ask_height : (int * int * int) list -> (int * int * int * int) list
val xytoz :
  int * int ->
  Sdlvideo.surface -> (int * int * int * 'a) list -> int * int * 'a
val add_height :
  Sdlvideo.surface ->
  ((int * int) * (int * int) * (int * int)) list ->
  ((int * int * int) * (int * int * int) * (int * int * int)) list
val inter : Sdlvideo.surface -> int -> (int * int) list
val trace_vertical :
  Sdlvideo.surface ->
  int -> int * int -> (int * int) list -> (int * int) list
val trace_horizontal :
  Sdlvideo.surface ->
  int -> int * int -> (int * int) list -> (int * int) list
val trace_diagonal1 :
  Sdlvideo.surface -> int -> int * 'a -> (int * int) list -> (int * int) list
val trace_diagonal2 :
  Sdlvideo.surface ->
  int -> int * int -> (int * int) list -> (int * int) list
val trace_lines :
  Sdlvideo.surface -> int -> (int * int) list -> (int * int) list
val center : (int * int) * (int * 'a) * (int * 'b) -> int * int
val close : int * int -> (int * int) list -> int * int
val is_left : int * int -> int * int -> int * int -> int
val in_triangle :
  (int * int) * (int * int) * (int * int) -> int * int -> bool
val triangle_plat : (int * int) * (int * int) * (int * int) -> bool
val check : 'a * 'b -> 'a * 'b -> 'a * 'b -> bool
val supr : 'a -> 'a list -> 'a list
val triangulation_ftw :
  int -> int * int -> ((int * int) * (int * int) * (int * int)) list
val triangle_depane :
  (int * int) list ->
  ((int * int) * (int * int) * (int * int)) list ->
  ((int * int) * (int * int) * (int * int)) list
val reduce_list : (int * int) list -> int * int -> int -> (int * int) list
val write_obj :
  ((int * int * int) * (int * int * int) * (int * int * int)) list ->
  string -> unit
val run : 'a -> int -> int * int -> 'b -> Sdlvideo.surface -> unit
val main : unit -> 'a
