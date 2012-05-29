val get_dims : Sdlvideo.surface -> int * int
val sdl_init : unit -> unit
val wait_key : unit -> unit
val show : Sdlvideo.surface -> Sdlvideo.surface -> unit
val load_img : string -> Sdlvideo.surface
val gpc : Sdlvideo.surface -> x:int -> y:int -> Sdlvideo.color
val ppc : Sdlvideo.surface -> x:int -> y:int -> Sdlvideo.color -> unit
val sqrt : float -> float
val its : int -> string
val fti : float -> int
val itf : int -> float
val sti : string -> int
val fts : float -> string
val min2 : 'a -> 'a -> 'a
val min : 'a -> 'a -> 'a -> 'a
val max2 : 'a -> 'a -> 'a
val max : 'a -> 'a -> 'a -> 'a
val al : int -> string
val alf : int -> string
val alh : int -> string
val nl : string
val lts : (int * int) list -> string
val lts_tri : ((int * int) * (int * int) * (int * int)) list -> string
val is_inlist : 'a * 'b * 'c -> ('a * 'b * 'c) list -> bool
val get_color : Sdlvideo.surface -> Sdlvideo.color list
val ask_height : (int * int * int) list -> (int * int * int * int) list
val xytoz :
  int * int ->
  Sdlvideo.surface -> (int * int * int * int) list -> int * int * int
val add_height :
  Sdlvideo.surface ->
  ((int * int) * (int * int) * (int * int)) list ->
  ((int * int * int) * (int * int * int) * (int * int * int)) list
val inter : Sdlvideo.surface -> int -> (int * int) list
val trace_vertical :
  Sdlvideo.surface ->
  Sdlvideo.surface ->
  int -> int * int -> (int * int) list -> (int * int) list
val trace_horizontal :
  Sdlvideo.surface ->
  Sdlvideo.surface ->
  int -> int * int -> (int * int) list -> (int * int) list
val trace_diagonal1 :
  Sdlvideo.surface ->
  Sdlvideo.surface -> int -> int * 'a -> (int * int) list -> (int * int) list
val trace_diagonal2 :
  Sdlvideo.surface ->
  Sdlvideo.surface ->
  int -> int * int -> (int * int) list -> (int * int) list
val trace_lines :
  Sdlvideo.surface ->
  Sdlvideo.surface -> int -> int * int -> (int * int) list
val write_obj :
  ((int * int * int) * (int * int * int) * (int * int * int)) list ->
  string -> unit
val pt_cloud : Sdlvideo.surface -> unit
val show_cloud : Sdlvideo.surface -> (int * int) list -> unit
val draw_cloud : Sdlvideo.surface -> int -> int -> Sdlvideo.color -> unit
val show_cloud_tri :
  Sdlvideo.surface ->
  Sdlvideo.surface -> ((int * int) * (int * int) * (int * int)) list -> unit
val center : (int * int) * (int * int) * (int * int) -> int * int
val is_left : int * int -> int * int -> int * int -> int
val in_triangle :
  (int * int) * (int * int) * (int * int) -> int * int -> bool
val tri_plat : (int * int) * (int * int) * (int * int) -> bool
val delete_pts : 'a * 'a * 'a -> 'a list -> int -> 'a list
val square_career :
  (int * int) * (int * int) * (int * int) ->
  (int * int) list -> (int * int) list
val list_to_obj_str :
  ((int * int * int) * (int * int * int) * (int * int * int)) list -> string
val close : int * int -> (int * int) list -> int * int
val del :
  (int * int) list ->
  (int * int) * (int * int) * (int * int) ->
  ((int * int) * (int * int) * (int * int)) list ->
  ((int * int) * (int * int) * (int * int)) list
val run :
  int ->
  int * int ->
  Sdlvideo.surface ->
  Sdlvideo.surface -> Sdlvideo.surface -> Sdlvideo.surface -> unit
val main : unit -> 'a
