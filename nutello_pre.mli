val get_dims : Sdlvideo.surface -> int * int
val sdl_init : unit -> unit
val ppc : Sdlvideo.surface -> x:int -> y:int -> Sdlvideo.color -> unit
val gpc : Sdlvideo.surface -> x:int -> y:int -> Sdlvideo.color
val sti : string -> int
val its : int -> string
val compare_pixel : 'a * 'b * 'c -> 'a * 'b * 'c -> bool
val coloroccur :
  int * int * int ->
  (int * int * int * int) list -> (int * int * int * int) list
val pixellist :
  int * int * int -> (int * int * int) list -> (int * int * int) list
val occur :
  Sdlvideo.surface -> 'a -> (int * int * int * int) list ref -> unit
val foi : int -> float
val compare : int * int * int -> int * int * int -> int
val check :
  int * int * int * 'a ->
  (int * int * int * int) list ->
  (int * int * int * 'a) * (int * int * int * int)
val replace :
  'a * 'b * 'c ->
  (('a * 'b * 'c * 'd) * ('a * 'b * 'c * 'e)) list -> 'a * 'b * 'c
val deletepixel :
  Sdlvideo.surface ->
  Sdlvideo.surface ->
  ((int * int * int * 'a) * (int * int * int * 'b)) list -> unit
val trace_contour :
  Sdlvideo.surface -> Sdlvideo.surface -> (int * int * int) list ref -> unit
val write : string -> string -> unit
val ask_height : (int * int * int) list -> (int * int * int * int) list
val main : unit -> 'a
