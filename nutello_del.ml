(* FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU *)

let get_dims img =
	((Sdlvideo.surface_info img).Sdlvideo.w,
		(Sdlvideo.surface_info img).Sdlvideo.h)

let sdl_init () =
	begin
		Sdl.init [`EVERYTHING];
		Sdlevent.enable_events Sdlevent.all_events_mask;
	end

let rec wait_key () =
	let e = Sdlevent.wait_event () in
		match e with
			| Sdlevent.KEYDOWN _ -> ()
			| _ -> wait_key ()

(* Show the img in a window *)
let show img dst =
	let d = Sdlvideo.display_format img in
		Sdlvideo.blit_surface d dst ();
		Sdlvideo.flip dst

(* Fun *)
let load_img = Sdlloader.load_image
let gpc = Sdlvideo.get_pixel_color
let ppc = Sdlvideo.put_pixel_color
let sqrt = Pervasives.sqrt
let its = string_of_int
let fti = int_of_float
let itf = float_of_int
let sti = int_of_string
let fts = string_of_float
let min2 a b = if a < b then a else b
let min a b c = min2 (min2 a b) c
let max2 a b = if a > b then a else	b
let max a b c = max2 (max2 a b) c
let al i = " "^(its i)
let alf i = " "^(fts(((itf i) /. 512. )-. 0.5))
let alh i = " "^(fts((itf i) /. 300.))
let nl = "\n"

(* List to string *)
let lts l =
	let rec rec_li l str = match l with
		[] -> str^nl
	| (x,y)::l -> rec_li l (str^"("^(its x)^","^(its y)^")\n")
	in rec_li l ""

(* List of triangle to string *)
let lts_tri l =
	let rec rec_li l str = match !l with
		[] -> str^nl
	| ((x1,y1),(x2,y2),(x3,y3))::l ->
		rec_li (ref l) (str^"(("^(its x1)^","^(its y1)^"),("^
			(its x2)^","^(its y2)^"),("^(its x3)^","^(its y3)^"))\n")
	in rec_li (ref l) ""

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

let rec ask_height l = match l with
	| [] -> []
	| (r,g,b)::l ->
		begin
			Printf.printf "(%d,%d,%d) : " r g b;
			let str = read_line () in
			(r,g,b,(-1*sti str))::ask_height l
		end

(* Match de coord with the height *)
let rec xytoz (x,y) img l = match l with
	| [] -> failwith ("xytoz: no color found on ("^its x^","^its y^")")
	| (r,g,b,z)::l when (gpc img x y)=(r,g,b) -> (x,y,-1 * z)
	| _::l -> xytoz (x,y) img l

(* Add height to all point in the list *)
let add_height img l =
	let lcolor = ask_height (get_color img) in
	let rec rec_ah l = match l with
		| [] -> []
		| ((x1,y1),(x2,y2),(x3,y3))::l ->
			let c (a,b) = xytoz (a,b) img lcolor in
			((c (x1,y1)),(c (x2,y2)),((c (x3,y3))))::(rec_ah l)
	in rec_ah l

(* Return only the intersection of the lines drawn *)
let inter img step =
	let (w,h) = get_dims img in
	let rec rec_inter = function
		| (x,y)	when x > w-1 -> rec_inter (0,y+step)
		| (x,y) when y > h-1 -> []
		| (x,y) -> (x,y)::rec_inter (x+step,y)
	in rec_inter (0,0)

(* Draw vertical lines *)
let trace_vertical img fimg step (w,h) l =
	let rec rec_vertical = function
		| (x,y) when y >= h -> rec_vertical (x+step,0)
		| (x,_) when x >= w -> l
		| (x,y) ->
			if gpc fimg x y = (0,0,0) && x mod step <> 0 then
				(x,y)::rec_vertical (x,y+1)
			else
				(ppc img x y (0,0,0);
				rec_vertical (x,y+1))
	in rec_vertical (0,0)

(* Draw horizontal lines *)
let trace_horizontal img fimg step (w,h) l =
	let rec rec_horizontal = function
		| (x,y) when x >= w -> rec_horizontal (0,y+step)
		| (_,y) when y >= h -> l
		| (x,y) ->
			if gpc fimg x y = (0,0,0) && y mod step <> 0 then
				(x,y)::rec_horizontal (x+1,y)
			else
				(ppc img x y (0,0,0);
				rec_horizontal (x+1,y))
	in rec_horizontal (0,0)

(* Draw diagonal lines
	//xx : the global x coord *)
let trace_diagonal1 img fimg step (w,h) l =
	let rec rec_diago1 = function
		| (_,xx) when xx >= w -> l
		| (x,xx) when x < 0 -> rec_diago1 (xx+step,xx+step)
		| (x,xx) ->
			if gpc fimg x (xx-x) = (0,0,0) || x mod step = 0 then
				(x,xx-x)::rec_diago1 (x-1,xx)
			else
				(ppc img x (xx-x) (0,0,0);
				rec_diago1 (x-1,xx))
	in rec_diago1 (0,0)

(* Draw second part diagonal lines
	//yy : the global y coord *)
let trace_diagonal2 img fimg step (w,h) l =
	let rec rec_diago2 = function
		| (_,yy) when yy >= h -> l
		| (y,yy) when y >= h -> rec_diago2 (yy+step,yy+step)
		| (y,yy) ->
			if gpc fimg (w-(y-yy)) y = (0,0,0) || y mod step = 0 then
				(w-(y-yy),y)::rec_diago2 (y+1,yy)
			else
				(ppc img (w-(y-yy)) y (0,0,0);
				rec_diago2 (y+1,yy))
	in rec_diago2 ((step)-(w mod step),(step-(w mod step)))

(* Draw all lines *)
let trace_lines img fimg step (w,h) =
	begin
		trace_diagonal1 img fimg step (w,h)
		(trace_diagonal2 img fimg step (w,h)
		(trace_horizontal img fimg step (w,h)
		(trace_vertical img fimg step (w,h) [])))
	end

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

(* Make a clean white image *)
let pt_cloud del =
	let (w,h) = get_dims del in
		for x=0 to w-1 do
			for y=0 to h-1 do
				ppc del x y (255,255,255);
			done
		done

(* Draw the point in the list on the image *)
let rec show_cloud del l =
	match l with
		| [] -> ()
		| (x,y)::l ->
			ppc del x y (0,0,0);
			show_cloud del l

let draw_cloud del x y c =
	for i=0 to 511 do
		ppc del i y c;
	done;
	for j=0 to 511 do
		ppc del x j c;
	done;
	ppc del (x-1) (y-1) c;
	ppc del (x+1) (y-1) c;
	ppc del (x-1) (y+1) c;
	ppc del (x+1) (y+1) c

let show_cloud_tri del display l =
	Random.self_init ();
	let rec sct_rec l =
	match l with
		| [] -> ()
		| ((x1,y1),(x2,y2),(x3,y3))::l ->
			pt_cloud del;
			draw_cloud del x1 y1 (255,0,0);
			draw_cloud del x2 y2 (0,255,0);
			draw_cloud del x3 y3 (0,0,255);
			show del display;
			(*wait_key ();*)
			sct_rec l
	in sct_rec l

(* Point in the center of a triangle *)
let center ((a,b),(c,d),(e,f)) = ((a+c+e)/3),((b+d+f)/3)
(*
	let x = (a+c)/2 in
	let y = (b+d)/2 in
	(x+((e-x)/3)),(y+((f-y)/3))
*)

(* Test the position of a point depend on the line *)
let is_left (x1,y1) (x2,y2) (x,y) =
	((x2-x1)*(y-y1))-((x-x1)*(y2-y1))

(* Test if a point p is in a triangle *)
let in_triangle (a,b,c) p =
	(is_left a b p > 0) && (is_left b c p > 0) && (is_left c a p > 0)

(* Check if a triangle is plat *)
let tri_plat ((x1,y1),(x2,y2),(x3,y3)) =
	if not (x1=x2 && x1=x3 && y1=y2 && y1=y3) then
		if (not(x1 = x2)) then
			if (((y2-y1)/(x2-x1))* x3 + (y1-((y2-y1)/(x2-x1))* x1) = y3)then
				true
			else
				false
		else if (not(x3 = x2)) then
			if (((y2-y3)/(x2-x3))* x1 + (y3-((y2-y3)/(x2-x3))* x3) = y1)then
				true
			else
				false
		else if (not(x3 = x1)) then
			if (((y1-y3)/(x1-x3))* x2 + (y3-((y1-y3)/(x1-x3))* x3) = y2)then
				true
			else
				false
		else
			false
	else
		false

(* Delete the occurence of the sommet of the triangle in the list *)
let rec delete_pts (a,b,c) l acc = match l with
		[] -> []
	| x::l when a=x || b=x || c=x -> delete_pts (a,b,c) l (acc)
	| x::l -> x::(delete_pts (a,b,c) l (acc+1))

(* Reduce the list of only point in the triangle*)
let square_career	((x1,y1),(x2,y2),(x3,y3)) l =
	let ((a1,b1),(a2,b2)) =
		(min x1 x2 x3,min y1 y2 y3),(max x1 x2 x3,max y1 y2 y3)
	in
	let in_tri = in_triangle ((x1,y1),(x2,y2),(x3,y3)) in
	let rec sc_rec l =
		match l with
			[] -> []
		|(g1,h1)::l when g1>=a1 && g1<=a2 && h1>=b1 && h1<=b2 && in_tri (g1,h1) ->
				(g1,h1)::sc_rec l
		|_::l -> sc_rec l
	in sc_rec (delete_pts ((x1,y1),(x2,y2),(x3,y3)) l 0) 

(* Call the lists to obj method *)
let list_to_obj_str l =
	let rec rec_lto sv sf l acc = match l with
		| [] -> sv^sf
		| ((x1,y1,z1),(x2,y2,z2),(x3,y3,z3))::l
			-> rec_lto (sv^"v"^(al x1)^(al y1)^(al z1)^nl
					^"v"^(al x2)^(al y2)^(al z2)^nl
					^"v"^(al x3)^(al y3)^(al z3)^nl)
					(sf^"f"^(al acc)^(al (acc+1))^(al (acc+2))^nl)
					l (acc+3)
	in rec_lto "g map\n\n" "\n" l 1


(* Return the closer point of an other point in the list *)
let close (x,y) lf = match lf with
		| [] -> failwith "close: lf must not be empty"
		| e::l ->
	let rec inclose (x,y) (c,d) l = match l with
			[] -> (c,d)
		| (a,b)::l ->
		if (sqrt (itf((a-x)*(a-x)+(b-y)*(b-y))) <
			sqrt (itf((x-c)*(x-c)+(y-d)*(y-d)))) then
			inclose (x,y) (a,b) l
		else
			inclose (x,y) (c,d) l
	in inclose (x,y) e l

(* Main function of delaunay algorithme
	l : All the points in the map
	() : the 3 point of the triangle
	lf : final list of the smaller triangles *)
let rec del	l ((x1,y1),(x2,y2),(x3,y3)) lf = 
	match square_career ((x1,y1),(x2,y2),(x3,y3)) l with
		[] ->	((x1,y1),(x2,y2),(x3,y3))::lf
	| l ->
		begin
			let ctr = close (center((x1,y1),(x2,y2),(x3,y3))) l in
			if tri_plat (ctr,(x1,y1),(x2,y2)) then
				del l (ctr,(x2,y2),(x3,y3))
				(del l (ctr,(x3,y3),(x1,y1)) lf)
			else if tri_plat (ctr,(x2,y2),(x3,y3)) then
				del l (ctr,(x1,y1),(x2,y2))
				(del l (ctr,(x3,y3),(x1,y1)) lf)
			else if tri_plat (ctr,(x3,y3),(x1,y1)) then
				del l (ctr,(x1,y1),(x2,y2))
				(del l (ctr,(x2,y2),(x3,y3)) lf)
			else
				del l (ctr,(x1,y1),(x2,y2))
				(del l (ctr,(x2,y2),(x3,y3))
				(del l (ctr,(x3,y3),(x1,y1)) lf))
		end

(* Call the triangle generation fun and write the result *)
let run step (w,h) img fimg img_ display =
	let l = trace_lines img img_ step (w,h) in
	let tri1 = ((0,0),(w-1,0),(0,h-1)) in
	let tri2 = ((w-1,0),(w-1,h-1),(0,h-1)) in
	let ldel = del l tri1 (del l tri2 []) in
	(*show_cloud_tri img display ldel;*)
	show img display;
	write_obj (add_height fimg ldel) "map.obj"
	
(* Main method *)
let main () =
  begin
		sdl_init ();
    if Array.length (Sys.argv) < 4 then
			failwith "3 arguments needed";
		(* map to modify *)
		let img = load_img Sys.argv.(1) in	
		(* read only arg : original map *)
		let fimg = load_img Sys.argv.(2) in
		(* read only arg : map modified by nutello_pre *)
		let img_ = load_img Sys.argv.(1) in
		let (w,h) = get_dims img in
    let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in
		let step = sti Sys.argv.(3) in
		run step (w,h) img fimg img_ display;
		exit 0
  end

let _ = main ()
(* FIN *)
