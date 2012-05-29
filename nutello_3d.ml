(* FUUUUUUUUUUUUUUUUUUUUUUUUU *)

(*
		nutello - 3D part
		Load and display the map
		in a 3D engine
*)

(* fun *)
let pi = 4.0 *. atan 1.0
let sti = int_of_string
let its = string_of_int
let stf = float_of_string
let fts = string_of_float
let itf = float_of_int
let cts x = its (int_of_char x)
let abs x = 
	if x >= 0. then
		x
	else
		x *. -1.
let split = Str.split (Str.regexp_string " ")
let debug str = 
	print_string (str^"\n");
	flush stdout

(* Ugly global var *)
let (rotx, rotz) = (ref (-1. *. pi /. 2.), ref (-1. *. pi /. 2.))
let h = ref 0.
let zoom = ref 1.
let mode = ref 0
let motion = ref 0
let (col_r, col_g, col_b) = (ref 1., ref 1., ref 1.)
let (x_motion, y_motion) = (ref 0., ref 0.)
let revert = ref false
let is_init = ref false

(* read the .obj
	// sp : String of point
	// str : readed .obj
*)
let read str =
	let rec read_rec sp str =
		match try Some(split (input_line str)) with _ -> None with
		| None -> sp
		| Some["v";x;y;z] -> read_rec ((stf x, stf y, stf z)::sp) str
		| Some["f";a;b;c] -> sp
		| Some _ -> read_rec sp str
	in read_rec [] str
	
(* Clear and display *)
let rec d_rec l = match l with
		[] -> ()
	|	(a,b,c)::l -> 
		begin
			GlDraw.color (0.5 *. c *. !col_r, c *. !col_g, !col_b *. 0.5 *. (1.-.c));
			GlDraw.vertex3 (a,b,c *. !h);
			d_rec l;
		end

let display l () =
	GlClear.color (0.0, 0.0, 0.0);
	GlClear.clear[`color;`depth];
	begin
		match !mode with
		| 1 -> GlDraw.begins `points
		| 2 -> GlDraw.begins `lines
		|	_ -> GlDraw.begins `triangles
	end;
	d_rec 
	(if !revert then 
		List.rev l
	else
		l);
	GlDraw.ends ();
	Glut.swapBuffers ();
	Gl.flush ()

(* Generate and resize the view and the window *)
let reshape ~w ~h =
	GlDraw.viewport ~x:0 ~y:0 ~w ~h;
	GlMat.mode `projection;
	GlMat.load_identity ();
	GlMat.mode `modelview;
	GlMat.load_identity ()

(* Detect special keys *)
let special ~key ~x ~y = 
	begin
	match key with
  | Glut.KEY_LEFT  -> rotz := !rotz +. 0.05
	| Glut.KEY_RIGHT -> rotz := !rotz -. 0.05
  | Glut.KEY_UP    -> rotx := !rotx +. 0.05
	| Glut.KEY_DOWN  -> rotx := !rotx -. 0.05
  | _ -> ()
	end

(* Detect usual keys *)
let keyboard ~key ~x ~y =
	begin
	match char_of_int key with
	| '1' -> mode := 0
	| '2' -> mode := 1
	| '3' -> mode := 2
	| 'a' -> h := !h +. 0.01
	| 'q' -> h := !h -. 0.01
	| 'z' -> zoom := !zoom +. 0.01
	| 's' -> zoom := !zoom -. 0.01
	| 'e' -> col_r := !col_r +. 0.1
	| 'd' -> col_r := !col_r -. 0.1
	| 'r' -> col_g := !col_g +. 0.1
	| 'f' -> col_g := !col_g -. 0.1
	| 't' -> col_b := !col_b +. 0.1
	| 'g' -> col_b := !col_b -. 0.1
	| k -> ()
	end

let mouse ~button ~state ~x ~y =
	if button = Glut.LEFT_BUTTON then
		motion := 1
	else if button = Glut.RIGHT_BUTTON then
		motion := 2
	else
		motion := 0;
	x_motion := itf x;
	y_motion := itf y

let motion ~x ~y =
	if !motion = 1 then
	(
		rotz := !rotz +. ((!x_motion -. (itf x))/. 200.);
		rotx := !rotx -. ((!y_motion -. (itf y))/. 200.);
		x_motion := itf x;
		y_motion := itf y
	)
	else if !motion = 2 then
	(
		zoom := !zoom -. ((!y_motion -. (itf y))/. 200.);
		y_motion := itf y
	)

(* Called when nothing to do to refresh the model *)
let idle () =
	if (!rotx >= -0.5)
		then rotx := -0.5;
	if !rotx <= (-1. *. pi /. 2.) then 
		rotx := (-1. *. pi /. 2.);
	if not !is_init then
		if !h <= 0.5 then
		(
			h := !h +. 0.002;
			rotx := !rotx +. 0.002
		)
		else
			is_init := true;
	revert := sin !rotz < 0.;
	GlMat.load_identity ();
	GlMat.ortho ~x:(!zoom *. -0.7, !zoom *. 0.7) ~y:(!zoom *. -0.7, !zoom *. 0.7) ~z:(-10., 10.);
	GluMat.look_at
		~eye:(0., 0., 0.)
		~center:(cos !rotz, sin !rotz *. sin !rotx, cos !rotx)
		~up:(0., 0., 1.);
	Glut.postRedisplay ()

(* Main loop *)
let main () =
	ignore (Glut.init Sys.argv);
	Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
	Glut.initWindowSize ~w:768 ~h:768;
	Glut.initWindowPosition ~x:0 ~y:0;
	ignore (Glut.createWindow ~title:"Okaramel!");
	
	Glut.reshapeFunc ~cb:reshape;
	let ch = open_in "map.obj" in
	Glut.displayFunc ~cb:(display (read ch));
	close_in ch;
	Glut.idleFunc ~cb:(Some idle);
	Glut.specialFunc ~cb:special;
	Glut.keyboardFunc ~cb:keyboard;
	Glut.mouseFunc ~cb:mouse;
	Glut.motionFunc ~cb:motion;
	Glut.mainLoop ()

(* Entry point *)
let _ = main ()
