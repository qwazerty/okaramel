# Okaramel
 
OCAML=ocamlc
OCAMLOPT=ocamlopt
SDL= -I +sdl
LABLGTK= -I +lablGL -I +lablgtk2 -I +labltk
LABLGL= -I +lablGL

SDL_LIB= bigarray.cmxa sdl.cmxa sdlloader.cmxa
LABLGTK_LIB= lablgl.cmxa labltk.cmxa lablgtk.cmxa gtkInit.cmx togl.cmxa
LABLGL_LIB= lablgl.cmxa lablglut.cmxa str.cmxa

SDL_MLI= bigarray.cma sdl.cma sdlloader.cma
LABLGTK_MLI= lablgl.cma labltk.cma lablgtk.cma gtkInit.cma togl.cma
LABLGL_MLI= lablgl.cma lablglut.cma str.cma

all:
	make nutello_pre
	make nutello_mkobj
	make nutello_3d
	make nutello_gui

nutello_pre: nutello_pre.ml
	${OCAML} ${SDL} ${SDL_MLI} -c nutello_pre.mli
	${OCAMLOPT} ${SDL} ${SDL_LIB} -o nutello_pre nutello_pre.ml
 
nutello_mkobj: nutello_mkobj.ml
	${OCAML} ${SDL} ${SDL_MLI} -c nutello_mkobj.mli
	${OCAMLOPT} ${SDL} ${SDL_LIB} -o nutello_mkobj nutello_mkobj.ml

nutello_3d: nutello_3d.ml
	${OCAML} ${LABLGL} ${LABLGL_MLI} -c nutello_3d.mli
	${OCAMLOPT} ${LABLGL} ${LABLGL_LIB} -o nutello_3d nutello_3d.ml

del: nutello_del.ml
	${OCAML} ${SDL} ${SDL_MLI} -c nutello_del.mli
	${OCAMLOPT} ${SDL} ${SDL_LIB} -o nutello_del nutello_del.ml

nutello_gui: nutello_gui.ml
	${OCAML} ${SDL} ${LABLGTK} ${SDL_MLI} ${LABLGTK_MLI} -c nutello_gui.mli
	${OCAMLOPT} ${SDL} ${LABLGTK} ${SDL_LIB} ${LABLGTK_LIB} -w -26 -w s -o nutello_gui nutello_gui.ml

clean:
	rm -f *~ *.o *.cm? *.obj nutello_3d nutello_mkobj nutello_pre nutello_gui nutello_del carte2.bmp

# FIN
