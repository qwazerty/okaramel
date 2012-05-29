val img_adress : string ref
val file : bool ref
val map_pretreat : bool ref
val displayed : bool ref
val state : int ref
val step : int ref
val colors : Sdlvideo.color list ref
val height : string list ref
val window : GWindow.window
val popup_precision : GWindow.window
val uprint : string -> unit -> unit
type struct_tbx = { spin : GEdit.spin_button; btn : GButton.color_button; }
val changed_color : struct_tbx Stack.t
val popup_value : unit -> unit
val popup_step : unit -> unit
val container : GPack.box
val create_menu : unit -> GMenu.menu
val create_edit : unit -> GMenu.menu
val create_quit : unit -> GMenu.menu
val menu : unit
val popup : GPack.box
val bbox : GPack.button_box
val image_box : GPack.button_box
val scroll : GBin.scrolled_window
val bot_box : GPack.button_box
val msg : GMisc.label
val prec_box : GPack.button_box
val check : 'a option -> 'a
val show_img_pret : string -> unit
val al : float -> string
val pretreament : unit -> unit
val show_image : < filename : string option; .. > -> unit -> unit
val button_infos : GButton.button
val areusure : 'a -> bool
val button_browse : GFile.chooser_button
val button_pretreat : unit -> GButton.button
val button_map : unit -> GButton.button
val quit : GButton.button
val interface : unit
