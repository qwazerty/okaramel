(* FUUUUUU *)

let get_dims img =
	((Sdlvideo.surface_info img).Sdlvideo.w,
		(Sdlvideo.surface_info img).Sdlvideo.h)

let sdl_init () =
	begin
		Sdl.init [`EVERYTHING];
		Sdlevent.enable_events Sdlevent.all_events_mask;
	end

(* Fun *)
let gpc = Sdlvideo.get_pixel_color
let ppc = Sdlvideo.put_pixel_color
let its = string_of_int
let fti = int_of_float
let itf = float_of_int
let sti = int_of_string
let stf = float_of_string
let fts = string_of_float
let min2 a b = if a < b then a else b
let min a b c = min2 (min2 a b) c
let max2 a b = if a > b then a else	b
let max a b c = max2 (max2 a b) c
let al i = " "^(its i)
let alf i = " "^(fts(((itf i) /. 512. )-. 0.5))
let alh i = " "^(fts((itf i) /. 300.))
let nl = "\n"

(* ================================================================== @)
(@ ================= Get height with color fun ====================== @)
(@ ================================================================== *)

(* Test if the color is in the color list *)
let rec is_inlist (r,g,b) l = match l with
	| [] -> false
	| (x,y,z)::l when r=x && g=y && b=z -> true
	| _::l -> is_inlist (r,g,b) l

(* Reconnaissance des différentes couleurs *)
let get_color img =
	let (w,h) = get_dims img in
	let rec rec_gc (x,y) l = match (x,y) with
		| (x,y) when y=h -> l
		|	(x,y) when x=w -> rec_gc (0,y+1) l
		| (x,y) ->
			if not (is_inlist (gpc img x y) l) then
				rec_gc (x+1,y) ((gpc img x y)::l)
			else
				rec_gc (x+1,y) l
	in rec_gc (0,0) []

let add_asked_height l =
	let rec aah_rec acc = function
		[] -> []
	| (r,g,b)::l -> (r,g,b,(sti Sys.argv.(acc)))::aah_rec (acc+1) l
	in aah_rec 4 (List.rev l)

(* Ask the fucking user which height match with color *)
let rec ask_height l = match l with
	| [] -> []
	| (r,g,b)::l ->
		begin
			Printf.printf "(%d,%d,%d) : " r g b;
			let str = read_line () in
			(r,g,b,(sti str))::ask_height l
		end

(* Match de coord with the height *)
let rec xytoz (x,y) img l = match l with
	| [] -> failwith "xytoz: No color found"
	| (r,g,b,z)::l when (gpc img x y)=(r,g,b) -> (x,y,z)
	| _::l -> xytoz (x,y) img l

(* Add height to all point in the list *)
let add_height img l =
	let lcolor = add_asked_height (get_color img) in
	let rec rec_ah l = match l with
		| [] -> []
		| ((x1,y1),(x2,y2),(x3,y3))::l ->
			let c (a,b) = xytoz (a,b) img lcolor in
			((c (x1,y1)),(c (x2,y2)),((c (x3,y3))))::(rec_ah l)
	in rec_ah l

(* ================================================================== @)
(@ ========== Draw the lines and get the intersection =============== @)
(@ ================================================================== *)

(* Return only the intersection of the lines drawn *)
let inter img step =
	let (w,h) = get_dims img in
	let rec rec_inter = function
		| (x,y)	when x > w-1 -> rec_inter (0,y+step)
		| (x,y) when y > h-1 -> []
		| (x,y) -> (x,y)::rec_inter (x+step,y)
	in rec_inter (0,0)

(* Draw vertical lines *)
let trace_vertical img step (w,h) l =
	let rec rec_vertical = function
		| (x,y) when y >= h -> rec_vertical (x+step,0)
		| (x,_) when x >= w -> l
		| (x,y) ->
			if gpc img x y = (0,0,0) && x mod step <> 0 then
				(x,y)::rec_vertical (x,y+1)
			else
				(ppc img x y (0,0,0);
				rec_vertical (x,y+1))
	in rec_vertical (0,0)

(* Draw horizontal lines *)
let trace_horizontal img step (w,h) l =
	let rec rec_horizontal = function
		| (x,y) when x >= w -> rec_horizontal (0,y+step)
		| (_,y) when y >= h -> l
		| (x,y) ->
			if gpc img x y = (0,0,0) && y mod step <> 0 then
				(x,y)::rec_horizontal (x+1,y)
			else
				(ppc img x y (0,0,0);
				rec_horizontal (x+1,y))
	in rec_horizontal (0,0)

(* Draw diagonal lines
	//xx : the global x coord *)
let trace_diagonal1 img step (w,h) l =
	let rec rec_diago1 = function
		| (_,xx) when xx >= w -> l
		| (x,xx) when x < 0 -> rec_diago1 (xx+step,xx+step)
		| (x,xx) ->
			if (gpc img x (xx-x) = (0,0,0) &&
				x mod step <> 0 && xx-x mod step <> 0) then
				(x,xx-x)::rec_diago1 (x-1,xx)
			else
				(ppc img x (xx-x) (0,0,0);
				rec_diago1 (x-1,xx))
	in rec_diago1 (0,0)

(* Draw second part diagonal lines
	//yy : the global y coord *)
let trace_diagonal2 img step (w,h) l =
	let rec rec_diago2 = function
		| (_,yy) when yy >= h -> l
		| (y,yy) when y >= h -> rec_diago2 (yy+step,yy+step)
		| (y,yy) ->
			if gpc img (w-(y-yy)) y = (0,0,0) &&
				(w-(y-yy)) mod step <> 0 && y mod step <> 0 then
				(w-(y-yy),y)::rec_diago2 (y+1,yy)
			else
				(ppc img (w-(y-yy)) y (0,0,0);
				rec_diago2 (y+1,yy))
	in rec_diago2 ((step)-(w mod step),(step-(w mod step)))

(* Draw all lines *)
let trace_lines img step l =
	begin
		let (w,h) = get_dims img in
			trace_vertical img step (w,h)
			(trace_horizontal img step (w,h)
			(trace_diagonal1 img step (w,h)
			(trace_diagonal2 img step (w,h) l)))
	end

(* ================================================================== @)
(@ ================= Points triangulation fun ======================= @)
(@ ================================================================== *)

(* Point in the center of a triangle *)
let center ((a,b),(c,d),(e,f)) = ((a+c+e)/3,(b+c+e)/3)

(* Point the more close of a other point in the list of point *)
let close (x,y) l = match l with
		[] -> failwith "close: list cannot be empty"
	| e::l -> 
	let rec inclose (x,y) (c,d) l = match l with
			[] -> (c,d)
		| (a,b)::l ->
		if (sqrt(itf((a-x)*(a-x)+(b-y)*(b-y))) <
			sqrt (itf((x-c)*(x-c)+(y-d)*(y-d)))) then
			inclose (x,y) (a,b) l
		else
			inclose (x,y) (c,d) l
	in inclose (x,y) e l

(* Test the position of a point depend on the line *)
let is_left (a1,a2) (b1,b2) (x,y) =
	((b1-a1)*(y-a2))-((x-a1)*(b2-a2))

(* Test if a point p is in a triangle *)
let in_triangle (a,b,c) p =
	(is_left a b p >= 0) && (is_left b c p >= 0) && (is_left c a p >= 0)

(* Check if a triangle is plat *)
let triangle_plat ((x1,y1),(x2,y2),(x3,y3)) =
	if not (x1 =x2 && x1=x3 && y1=y2 && y1=y3) then
		if not(x1 = x2) then
			((y2-y1)/(x2-x1)) * x3 + (y1-((y2-y1)/(x2-x1))* x1) = y3
		else if not (x3 = x2) then
			((y2-y3)/(x2-x3))* x1 + (y3-((y2-y3)/(x2-x3))* x3) = y1
		else if (not(x3 = x1)) then
			((y1-y3)/(x1-x3))* x2 + (y3-((y1-y3)/(x1-x3))* x3) = y2
		else
			false
	else
		false

let check (x1,y1) (x2,y2) (x3,y3) =
	not (x1=x2 && y1=y2) && not (x2=x3 && y2=y3) && not (x1=x3 && y1=y3)

(* Delete the element in the list *)
let rec supr p l = match l with
	[] -> []
	| e::l -> 
		if (e = p)then
			supr p l
		else
			e::(supr p l)

let triangulation_ftw step (w,h) =
	let rec t_rec = function
		|	(x,y) when x>w-step-1 -> t_rec (0,y+step)
		| (x,y) when y>h-step-1 -> []
		| (x,y) ->
			((x,y),(x+step,y),(x,y+step))::
			((x+step,y),(x+step,y+step),(x,y+step))::
			t_rec (x+step,y)
	in t_rec (0,0)

(* Function to make the triangle *)
let rec triangle_depane l lf = match l with
	| [] | _::[] | _::_::[] -> lf
	| e::l when
		(*(not(triangle_plat((e),(close e l),(close e (supr (close e l) l))))) &&*)
		(check e (close e l) (close e (supr (close e l) l))) &&
		(not(e=(0,0)) && not((close e l)=(0,0)) &&
		not((close e (supr (close e l) l)) = (0,0)))
		-> ((e),(close e l),(close e (supr (close e l) l)))::(triangle_depane l lf)
	|e::l -> triangle_depane l lf

(* ================================================================== @)
(@ =================== Obj file generation == ======================= @)
(@ ================================================================== *)

(* Keep only point in the square *)
let reduce_list l (x,y) step =
	let rec inreduce_list  l (x,y) lf= match l with
		[] -> lf
		| (x1,y1)::l when x1>= x && x1<=x+step && y1>=y && y1<=y+step
			-> (x1,y1)::(inreduce_list l (x,y) lf)
		| _::l -> inreduce_list l (x,y) lf
	in inreduce_list l (x,y) []

(* Write the string to the filename *)
let write_obj l filename =
	let file = open_out_gen [Open_append;Open_creat] 0o644 filename in
	let rec w_rec acc = function
			[] -> ()
		| ((x1,y1,z1),(x2,y2,z2),(x3,y3,z3))::l ->	
			output_string file 
				("v"^(alf x1)^(alf y1)^(alh z1)^nl
				^"v"^(alf x2)^(alf y2)^(alh z2)^nl
				^"v"^(alf x3)^(alf y3)^(alh z3)^nl);
			w_rec (acc+3) l;
			output_string file
				("f"^(al acc)^(al (acc+1))^(al (acc+2))^nl)
	in output_string file "g map\n\n";
	w_rec 1 l;
	close_out file

(* Call the triangle generation fun and write the result *)
let run l step (w,h) img firstimg =
	let lf = triangulation_ftw step (w,h) in
	(* Appel de triangle_depane *)
	(*for x=0 to w-1 do
		for y=0 to h-1 do
			if (x+(step*2) <= w-1) && (y+(step*2) <= h-1) &&
				(x mod step*2) = 0 && (y mod step*2) = 0 then
			(
				if (not (reduce_list (l) (x,y) (step*2) = [])) then
					lf := (triangle_depane (reduce_list l (x,y) (step*2)) (!lf))
			)
		done
	done;
	*)
	write_obj (add_height firstimg (lf)) "map.obj"
	
(* Main method *)
let main () =
  begin
    if Array.length (Sys.argv) < 4 then
      failwith "Il manque le nom du fichier!";
    sdl_init ();
    let img = Sdlloader.load_image Sys.argv.(1) in
		let firstimg = Sdlloader.load_image Sys.argv.(2) in
    let (w,h) = get_dims img in
		let step = sti Sys.argv.(3) in
		run	(trace_lines img step (inter img step)) step (w,h) img firstimg;
		exit 0
  end

let _ = main ()
(* FIN *)
