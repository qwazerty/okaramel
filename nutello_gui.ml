let _ = GMain.init ()

let img_adress = ref ""
let file = ref false
let map_pretreat = ref false
let displayed = ref false
let state = ref 0
let step = ref 1
let colors = ref []
let height = ref []

(*******************************************************************)
(*******************************************************************)
(*****		         LES FENETRES       		       *****)
(*******************************************************************)
(*******************************************************************)

	(*Notre fenetre principale*)
let window =
	let wind = GWindow.window
		~position:`CENTER
		~resizable:false
		~height:720
		~width:1100
		~title:"Okaramel" () in
		wind#connect#destroy GMain.quit;
		wind

	(*Popup pour la precision*)
let popup_precision =
	let window = GWindow.window
		~width:300
		~height:150
    		~resizable:false
    		~position:`CENTER
    		~title:"Precision" () in
    		window#connect#destroy GMain.quit;
    		window

(*
let popup_precision =
        let window = GWindow.window
		~width: 250
		~height: 100
    		~resizable:false
    		~position:`CENTER
    		~title:"Precision" () in
    		window#connect#destroy GMain.quit;
    		window
*)

(*
let popup_value = 
        

let window = GWindow.window
	        ~width:700
                ~height:600
		~resizable:false
		~position:`CENTER
		~title:"Value" () in
	window#connect#destroy;
	window

	*)

let quit () =
  GMain.quit ();
  exit 0

let uprint msg () =
  print_endline msg;
  flush stdout


type struct_tbx = {
  spin : GEdit.spin_button;
  btn : GButton.color_button;
}

let changed_color = Stack.create ()

let popup_value () =
  let window = GWindow.window
    ~title:"Eidt: Height" ()
    ~width:400
    ~height:300
    ~position:`CENTER in
  let vbox = GPack.vbox
    ~packing:window#add () in
  let _lbl = GMisc.label
    ~text:"Enter the colors for each level"
		~packing:vbox#pack () in
  let _separator = GMisc.separator `HORIZONTAL
    ~packing:vbox#pack () in
  let scrolled_window = GBin.scrolled_window
    ~border_width:10
		~hpolicy:`AUTOMATIC
    ~vpolicy:`AUTOMATIC
    ~packing:vbox#add () in
  let secbox = GPack.hbox
    ~packing:scrolled_window#add_with_viewport () in
  let vbox1 = GPack.vbox
    ~packing:secbox#add () in
  let vbox2 = GPack.vbox
    ~packing:secbox#add () in
  for i=1 to List.length (!colors) do
    match (!colors) with
      | [] -> failwith "Critical error"
      | (r, g, b)::q -> let queue = q and
	  normal_r = r and
	  normal_g = g and
	  normal_b = b in
		colors := queue;
		let color_button = GButton.color_button
			  ~color:(GDraw.color (`RGB ((normal_r*65535/255),
						     (normal_g*65535/255),
						     (normal_b*65535/255))))
			  ~packing:vbox1#add () in
			let adj = GData.adjustment
			  ~lower:0.0 
			  ~upper:500.0
			  ~value:1.
			  ~page_incr:5.0
			  ~step_incr:1.0 
			  ~page_size:0.0 () in
			let spin = GEdit.spin_button
			  ~adjustment:adj
			  ~rate:0.0 ~digits:0 ~wrap:false
			  ~numeric:true
			  ~update_policy:`ALWAYS
			  ~packing:vbox2#add () in
			adj#connect#value_changed ~callback: (fun () -> height := (string_of_int (int_of_float (adj#value)))::(!height); ());
			let str = {
			  spin = spin;
			  btn = color_button;
			} in
			Stack.push str changed_color;
  done;
  
  let finish = GButton.button
    ~label:"Finish"
    ~packing:vbox#pack () in
  ignore (finish#connect#clicked ~callback:(window#destroy));
  window#show ()

let popup_step () =
  let window = GWindow.window	 
    ~title:"Edit: Step" ()
    ~width:300 
    ~height:200
    ~position:`CENTER in
  let v_box = GPack.vbox
    ~packing:window#add () in
  let h_box = GPack.hbox
    ~packing:v_box#add () in
  let h2_box = GPack.hbox
    ~packing: v_box#pack () in
  let _lbl = GMisc.label
    ~text:"Enter the step :"
    ~packing:h_box#add () in
  let adj = GData.adjustment 
    ~lower:1.0 
    ~upper:100.0
    ~value:1.
    ~page_incr:5.0
    ~step_incr:1.0 
    ~page_size:0.0 () in
  let spin = GEdit.spin_button
    ~adjustment:adj
    ~rate:0.0 ~digits:0 ~wrap:false
    ~numeric:true
    ~update_policy:`ALWAYS
    ~packing:h_box#add () in
 let next = GButton.button
  ~label:"Next"
  ~packing:h2_box#add () in
 let close = GButton.button
   ~label:"Close"
   ~packing: h2_box#add () in
 adj#connect#value_changed ~callback: (fun () ->step := int_of_float(adj#value);());
 ignore(next#connect#clicked ~callback: (fun () -> popup_value (); ()));
 close#connect#clicked ~callback:window#destroy;
 window#show ()
  

(*******************************************************************)
(*******************************************************************)
(*****			LES CONTENEURS 	                       *****)
(*******************************************************************)
(*******************************************************************)

	(*Le Père tout puissant*)
let container = GPack.vbox
	~spacing:10
	~border_width:16
	~packing:window#add () 

	(*barre des taches*)


(*
let color_button =
  let button = GButton.color_button
    ~packing:bot_box_e#add () in 
  *)


(*
  button#connect#clicked ~callback:(fun () ->Gwindow.quit ;());
*)
(*
button
  *)


let create_menu () =
  let file_menu = GMenu.menu () in
  let item = GMenu.menu_item 
    ~label:"Restart"
    ~packing:file_menu#append () in
  GMain.init ();
  item#connect#activate ~callback:(fun () -> Sys.command "./nutello_gui"; (quit) ());
  file_menu

let create_edit () =
  let edit_menu = GMenu.menu () in
  let item = GMenu.menu_item 
    ~label:"Value" 
    ~packing:edit_menu#append () in
  GMain.init ();
  item#connect#activate ~callback:(fun () -> popup_step ();());
  (*Donne en parametre mkobj carte2 carte1 lepas +valeurs des hauteurs*)
  edit_menu

let create_quit () =
  let quit_menu = GMenu.menu ()in
  let item = GMenu.menu_item 
    ~label:"Quit" 
    ~packing:quit_menu#append () in
  item#connect#activate 
    ~callback:GMain.Main.quit;
  quit_menu

let menu =
  let file_menu = create_menu () in
  let edit_menu = create_edit () in
  let quit_menu = create_quit () in
  let menu_bar = GMenu.menu_bar 
    ~packing:container#pack () in
  let file_item = GMenu.menu_item 
    ~label:"File" () in
  let edit_item = GMenu.menu_item 
    ~label:"Edit" () in
  let quit_item = GMenu.menu_item 
    ~label:"Quit"() in
file_item#set_submenu file_menu;
edit_item#set_submenu edit_menu;
quit_item#set_submenu quit_menu;
menu_bar#append file_item;
menu_bar#append edit_item;
menu_bar#append quit_item

  (*Conteneur precision*)
let popup = GPack.vbox
	~spacing:10
	~border_width:16
	~packing:popup_precision#add ()

  (*Conteneur pour les boutons*)
let bbox = GPack.button_box `HORIZONTAL
	~layout:`SPREAD
	~packing:(container#pack ~expand:false) ()

	(*Pour l'image*)
let image_box =  GPack.button_box `HORIZONTAL
	~layout:`SPREAD
	~packing:(container#pack ~expand:false) ()

let scroll = GBin.scrolled_window
  ~height:200
  ~hpolicy:`NEVER (* mettre ALWAYS pour afficher les barres de defilement *)
  ~vpolicy:`NEVER
  ~packing:container#add ()

let bot_box = GPack.button_box `HORIZONTAL
	~layout:`SPREAD
	~packing:(container#pack ~expand:false) ()

let msg = GMisc.label 
  ~text:"Choisissez votre précision:"
  ~packing:popup#add ()

let prec_box = GPack.button_box `HORIZONTAL
	~layout:`SPREAD
	~packing:(popup#pack ~expand:false) ()

(*******************************************************************)
(*******************************************************************)
(*****				LES FONCTIONS                  *****)
(*******************************************************************)
(*******************************************************************)

(*let sdl_init () =
	begin
		Sdl.init [`EVERYTHING];
		Sdlevent.enable_events Sdlevent.all_events_mask;
	end
  *)

let check = function
  | Some x -> x
  | _ -> raise Not_found

let show_img_pret name =
	let _ = GMisc.image
		~file:name
		~packing:image_box#pack () in
		begin
			if (!img_adress = "") then
			img_adress := name;
			()
		end

let al x = " "^(string_of_float x)

(* Pour le pre-traitement de l'image on verifie qu'il n'est pas deja fait*)
let pretreament () =
	if (!state = 0) then
	(
	  (* Test if the color is in the color list *)
	  let rec is_inlist (r,g,b) l = match l with
	    | [] -> false
	    | (x,y,z)::l when r=x && g=y && b=z -> true
	    | _::l -> is_inlist (r,g,b) l in
	  let get_dims img =
	    ((Sdlvideo.surface_info img).Sdlvideo.w,
	     (Sdlvideo.surface_info img).Sdlvideo.h) in
	  (* Reconnaissance des différentes couleurs *)
	  let get_color img =
	    let (w,h) = get_dims img in
	    let gpc = Sdlvideo.get_pixel_color in 
	    let rec rec_gc (x,y) l = match (x,y) with
	      | (x,y) when y=h -> l
	      | (x,y) when x=w -> rec_gc (0,y+1) l
	      | (x,y) ->
		if not (is_inlist (gpc img x y) l) then
		  rec_gc (x+1,y) ((gpc img x y)::l)
		else
		  rec_gc (x+1,y) l in
	    rec_gc (0,0) [] in
	  	colors := (get_color (Sdlloader.load_image !img_adress)); 
		Sys.command ("./nutello_pre "^(!img_adress));
		show_img_pret "carte2.bmp";
		state := 1;
		()
	)
	else if (!state = 1) then
	  (
			let str = ref "" in
			while !height <> [] do
				match !height with
					| [] -> ()
					| e::l -> str := (!str)^" "^e;
						height := l;
			done;
	    Sys.command ("./nutello_mkobj carte2.bmp "^(!img_adress)^" "^(string_of_int (!step))^(!str));
			state := 2;
	  ()
	 )
	else
	(
		Sys.command ("./nutello_3d");
		()
	);
  ()
    
(*Bouton pour lancer le pretraitement*)
let button_pretreat () =  
	let button = GButton.button
    ~label:"Lancer le pretraitement"
    ~packing:bbox#pack
    ~show: !displayed () in	
  button#connect#clicked ~callback:(pretreament);
  button#connect#clicked (fun () -> (button#set_label (if (!state = 1) then "Lancer l'echantillonage" else "Lancer la 3d")));
  button
    
let show_image img () =
  if(not(!file)) then
    begin
      let _ = GMisc.image
	~file:(check(img#filename))
	~packing:image_box#pack () in
		begin
		  img_adress := (check(img#filename));   
		  file := true;
		  displayed := true;
		  button_pretreat ();
	 	  ()
		end
    end
      
	  
(*let edit_precision = GEdit.entry
  ~text: "Go"
  ~packing:prec_box#pack () *)

	(*Boutton infos qui donne des informations sur la team Nuttelo *)

let button_infos =
	let msg = GWindow.about_dialog
		~parent:window
		~position:`CENTER_ON_PARENT
		~version:"0.2"
		~name: "Okaramel"
		~authors:[" ***-> Team Nuttelo <-*** ";"Romain Coulon";"Thiebaud Fos";"Kevin Houdebert";"Victor Kaplan"]
		~copyright:"Copyright © 2011 Nuttelo"
		~website:"okaramel.fr"
		~website_label:"Nuttelo website"
		~destroy_with_parent:true () in
	let button = GButton.button 
		~stock:`ABOUT 
		~packing:bot_box#add () in
	GMisc.image 
	~stock:`ABOUT 
	~packing:button#set_image ();
    button#connect#clicked (fun () -> ignore (msg#run ()); msg#misc#hide ());
    button
  

	(*Fenetre de confirmation pour quitter le programme*)
let areusure _ =
	let msg = GWindow.message_dialog
		~parent:window
		~position:`CENTER_ON_PARENT
		~destroy_with_parent:true
		~use_markup:true
		~message_type:`QUESTION
		~message:"\n<b><big>Êtes-vous sur de vouloir quitter ?</big></b>"
		~buttons:GWindow.Buttons.yes_no () in
	let res = msg#run () = `NO in
    msg#destroy ();
    res


(*******************************************************************)
(*******************************************************************)
(*****			LES BOUTONS			       *****)
(*******************************************************************)
(*******************************************************************)

	(*Boutton Parcourir*)
let button_browse =
	let chooser_button = GFile.chooser_button
		~action: `OPEN
		~width: 300
		~height: 90
		~packing:bbox#pack () in
    begin
		chooser_button#connect#selection_changed(show_image chooser_button);
		map_pretreat := false;
    end;
    chooser_button

	(*Bouton pour lancer le pretraitement*)
let button_pretreat () =
	let str =
		if !state = 0 then
			"Lancer le pretraitement"
		else if !state = 1 then
			"Lancer l'echantillonage"
		else
			"Lancer la 3D"
	in
	let button = GButton.button
		~label:str
		~packing:bbox#pack
		~show: !displayed () in
		button#connect#clicked ~callback:pretreament;
	button

	(*Bouton pour lancer la 3D*)
let button_map () =
	let button = GButton.button
		~label: "Carte 3D"
		~packing:bbox#add () in
    (*button#connect#clicked ~callback: fonction qui lance la 3D;*)
	button

	(*Bouton qui fait quitter*)
let quit =
	let button = GButton.button
		~stock:`QUIT
		~packing:bot_box#add () in
	button#connect#clicked ~callback:GMain.quit;
	button


let interface =
  window#event#connect#delete ~callback:areusure;
  window#show ();
  GMain.main ()
(* END *)
