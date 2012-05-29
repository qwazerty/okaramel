(* Dimensions d'une image *)
let get_dims img =
  ((Sdlvideo.surface_info img).Sdlvideo.w,
		(Sdlvideo.surface_info img).Sdlvideo.h)
 
(* init de SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end
 
(* Fun *)
let ppc = Sdlvideo.put_pixel_color
let gpc = Sdlvideo.get_pixel_color
let sti = int_of_string
let its = string_of_int

(* Compare 2 pixel, si de meme couleur vrai, si un pixel est noir alors vrai*)
let compare_pixel (r1,g1,b1) (r2,g2,b2) = match (r1,g1,b1) with
	|(r1,g1,b1) when r1=r2 && g1=g2 && b1=b2 -> true
	|(r1,g1,b1) -> false

(*calcul de l'occurence*)
let rec coloroccur (r,g,b) l = match l with
	| [] -> (r,g,b,1)::[]
	| (r1,g1,b1,x)::l when (r=r1 && g=g1 && b=b1)-> (r1,g1,b1,x+1)::l
	| (r1,g1,b1,x)::l when ((not(r=0 && g=0 && b=0)) &&
		(not (r=r1 && g=g1 && b=b1))) ->(r1,g1,b1,x+1)::(coloroccur (r,g,b) (l))
	| e::l -> e::(coloroccur (r,g,b) l)

(*pixel de base*)	
let rec pixellist (r,g,b) l = match l with
	| [] when ((r=0 && g=0 && b=0)) -> []
	| [] -> (r,g,b)::[]
	| (r1,g1,b1)::l when (r=r1 && g=g1 && b=b1)-> (r1,g1,b1)::l
	| (r1,g1,b1)::l when ((not(r=0 && g=0 && b=0)) &&
		(not (r=r1 && g=g1 && b=b1))) ->(r1,g1,b1)::(pixellist (r,g,b) (l))
	| e::l -> e::(pixellist (r,g,b) l)

(*boucle pour reccurence*)
let occur src dst l2 =
	let (w,h) = get_dims src in
	for x=0 to w-1 do
		for y=0 to h-1 do
(*appel de reconnaissance avec a chaque tour on enregistre la nouvelle liste*)
			l2 := (coloroccur (gpc src x y) !l2);
	done
done

(*Renvoi la nouvelle liste avec les couleurs inférieur a n , soit les couleurs qu'il faut supprimer/remplacer*)
(*let rec colormustchange l n = 
	let rec incolormustchange l l2 n = match l with
		[] -> l2
	|(r,g,b,x)::l when x<n -> (r,g,b,x)::(incolormustchange l l2 n)
	|(r,g,b,x)::l -> incolormustchange l l2 n
in incolormustchange l [] n

	
let itg (r,g,b) = (0.3*.(foi r) , 0.59 *. (foi g) , 0.11 *. (foi b))
	
let abs = Pervasives.abs 
*)
let foi = float_of_int 
let compare (r1,g1,b1) (r2,g2,b2) = (abs(r1-r2))+(abs(g1-g2))+(abs(b1-b2))

let rec check (r,g,b,x) l2 = 
	let rec incheck (r,g,b,x) l2 (r3,g3,b3,x3) = match l2 with
	| [] -> ((r,g,b,x),(r3,g3,b3,x3))
	| (r2,g2,b2,x2)::l when (r3,g3,b3,x3)= (0,0,0,0) && not(r2=0 && g2=0 && b2=0)-> incheck (r,g,b,x) l (r2,g2,b2,x2)
	| (r2,g2,b2,x2)::l when compare (r2,g2,b2) (r,g,b) < compare (r3,g3,b3) (r,g,b)  && not(r2=0 && g2=0 && b2=0)-> incheck (r,g,b,x) l (r2,g2,b2,x2)
	| (r2,g2,b2,x2)::l  -> incheck (r,g,b,x) l (r3,g3,b3,x3)
in incheck (r,g,b,x) l2 (0,0,0,0)

(*
(* prend la liste l avec les couleur qu'il faut changer, la liste l2 des couleurs*)
let pourcentagecolor l l2 =
	let rec inpourcentagecolor l l2 l3 = match l with
		[] -> l3
	|e::l -> (check e l2)::(inpourcentagecolor l l2 l3)
in inpourcentagecolor l l2 []
*)
let rec replace (r,g,b) l3 = match l3 with
	| [] -> (r,g,b)
	| ((r1,g1,b1,x1),(r2,g2,b2,x2))::l when (r=r1 && g=g1 && b=b1) -> (r2,g2,b2)
	| _::l -> replace (r,g,b) l

let deletepixel src dst l3 =
	let (w,h) = get_dims src in
	for x=0 to w-2 do
		for y=0 to h-1 do
(*appel de reconnaissance avec a chaque tour on enregistre la nouvelle liste*)
	(*		let color = replace (gpc x y) l3 in*)
			if not((replace (gpc src x y) l3) = (gpc src x y)) then
			(
				ppc dst x y (gpc src (x+1) y);
			)
		done
	done;
	for y=0 to h-1 do
		if not((replace (gpc src (w-1) y) l3) = (gpc src (w-1) y)) then
			ppc dst (w-1) y (gpc src (w-2) y);
	done

(*
(*suppression des couleurs inferieur au nombre minimum*)
let checklist l n = 
	let rec inchecklist l l2 n = match l with
		[] ->  l2
	|(r,g,b,x)::l when x<n -> (inchecklist l l2 n)
	|(r,g,b,x)::l -> (r,g,b,x)::(inchecklist l (l2) n)
in inchecklist l [] n

let occur22 src dst l2 =
	let (w,h) = get_dims src in
	for x=0 to w-1 do
		for y=0 to h-1 do
(*appel de reconnaissance avec a chaque tour on enregistre la nouvelle liste*)
			l2 := (coloroccur (gpc src x y) !l2);
	done	
done
*)
						 
(* Fonction trace un pixel sur 2 noir si different seulement celui de droite*)
let trace_contour src dst l =
	let (w,h) = get_dims src in
	let n = (0,0,0) in
	for x=0 to w-1 do
		for y=0 to h-1 do
(*appel de reconnaissance avec a chaque tour on enregistre la nouvelle liste*)
			l := (pixellist (gpc src x y) !l);
			if(x<=w-2 && y<=h-2)then
			(	
				if not (compare_pixel (gpc src x y) (gpc src x (y+1))) then
					ppc dst x y n;
				if not (compare_pixel (gpc src x y) (gpc src (x+1) (y))) then
					ppc dst x y n;
			)
			else
			(
				if (x= w-2 && y <= h-2)	then
				(
					if not (compare_pixel (gpc src x (y-1)) (gpc src x (y))) then
						ppc dst x y n;
					if not (compare_pixel (gpc src (x) y) (gpc src (x+1) (y))) then
						ppc dst x y n;
				)
				else
				(
					if (y = h-2 && x<= w-2) then
					(
						if not (compare_pixel (gpc src x (y)) (gpc src x (y+1))) then
							ppc dst x y n;
						if not (compare_pixel (gpc src (x-1) y) (gpc src (x) (y))) then
							ppc dst x y n;
					)
					else
					(
						if (x = w-2 && y = h-2) then
						(
							if not (compare_pixel (gpc src x (y-1)) (gpc src x (y))) then
									ppc dst x y n;
							if not (compare_pixel (gpc src (x-1) y) (gpc src (x) (y))) then
									ppc dst x y n;
						)
					)
				)
			)
		done
	done

(*lance tout le pretraitement plus la reduction du bruit*)

(*
let lts l =
	let rec rec_lts l str = match l with
		[] -> str
		| (r,g,b,z)::l -> rec_lts l 
			(str^its(r)^","^its(g)^","^ its(b)^":"^its(z)^"\n") 
	in rec_lts l ""
*)

let write texte fichier =
	let file = open_out_gen [Open_creat;Open_append] 0o644 fichier in
	output_string file texte;
	close_out file

let rec ask_height l = match l with
	| [] -> []
	| (r,g,b)::l ->
		begin
			Printf.printf "(%d,%d,%d) : " r g b;
			let str = read_line () in
			(r,g,b,(sti (str)))::ask_height l
		end

let main () =
	begin
		if Array.length (Sys.argv) < 2 then
			failwith "Il manque le nom du fichier!";
		sdl_init ();
		let src = Sdlloader.load_image Sys.argv.(1) in
		let dst = Sdlloader.load_image Sys.argv.(1) in
		(*let (w,h) = get_dims img in*)
		(*let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in*)
		let l = ref [] in
		trace_contour src dst l;
		Sdlvideo.save_BMP dst "carte2.bmp"; 
		exit 0 
  end

let _ = main ()
(* FIN*)
