# This Makefile has two purposes:
# 1. Starting the compilation of Vim for Unix.
# 2. Creating the various distribution files.


# 1. Using this Makefile without an argument will compile Vim for Unix.
#
# "make install" is also possible.
#
# NOTE: If this doesn't work properly, first change directory to "src" and use
# the Makefile there:
#	cd src
#	make [arguments]
# Noticed on AIX systems when using this Makefile: Trying to run "cproto" or
# something else after Vim has been compiled.  Don't know why...
# Noticed on OS/390 Unix: Restarts configure.
#
# The first (default) target is "first".  This will result in running
# "make first", so that the target from "src/auto/config.mk" is picked
# up properly when config didn't run yet.  Doing "make all" before configure
# has run can result in compiling with $(CC) empty.

first:
	@echo "Starting make in the src directory."
	@echo "If there are problems, cd to the src directory and run make there"
	cd src && $(MAKE) $@

# Some make programs use the last target for the $@ default; put the other
# targets separately to always let $@ expand to "first" by default.
all install uninstall tools config configure proto depend lint tags types test testclean clean distclean:
	@echo "Starting make in the src directory."
	@echo "If there are problems, cd to the src directory and run make there"
	cd src && $(MAKE) $@


# 2. Create the various distributions:
#
# TARGET	PRODUCES		CONTAINS
# unixrt	vim-#.#-rt.tar.gz	Runtime files for Unix
# unixsrc	vim-#.#-src.tar.gz	Sources for Unix
#
# extra		vim-#.#-extra.tar.gz	Extra source and runtime files
# lang		vim-#.#-lang.tar.gz	multi-language files
#
# html		vim##html.zip		HTML docs
#
# amisrc	vim##src.tgz		sources for Amiga
# amirt		vim##rt.tgz		runtime for Amiga
# amibin	vim##bin.tgz		binary for Amiga
#
# dossrc	vim##src.zip		sources for MS-DOS
# dosrt		vim##rt.zip		runtime for MS-DOS
# dosbin	vim##d16.zip		binary for MS-DOS 16 bits
#		vim##d32.zip		binary for MS-DOS 32 bits
#		vim##w32.zip		binary for Win32
#		gvim##.zip		binary for GUI Win32
#		gvim##ole.zip		OLE exe for Win32 GUI
#		gvim##_s.zip		exe for Win32s GUI
# doslang	vim##lang.zip		language files for Win32
#
# os2bin	vim##os2.zip		binary for OS/2
#					(use RT from dosrt)
#
# farsi		farsi##.zip		Farsi fonts
#
#    All output files are created in the "dist" directory.  Existing files are
#    overwritten!
#    To do all this you need the unixrt, unixsrc, extra and lang archives, and
#    compiled binaries.
#    Before creating an archive first delete all backup files, *.orig, etc.

MAJOR = 6
MINOR = 0ai

# CHECKLIST for creating a new version:
#
# - Update Vim version number.  For a test version in: src/version.h, Contents,
#   MAJOR/MINOR above, VIMRTDIR in src/Makefile, README*.txt,
#   runtime/doc/*.txt.  For a minor/major version: GvimExt/GvimExt.reg,
#   src/vim16.def.
# - Correct included_patches[] in src/version.c.
# - Compile Vim with GTK, Perl, Python, TCL, Ruby, Cscope and "huge" features.
# - With these features: "make proto" (requires cproto; ignore warnings for
#   missing include files, fix problems for syntax errors).
# - With these features: "make depend" (works best with gcc).
# - "make lint" and check the output (ignore GTK warnings).
# - Enable the efence library in "src/Makefile" and run "make test".
# - Do "make menu" to update the runtime/menu.vim file.
# - Add remarks for changes to runtime/doc/version6.txt.
# - In runtime/doc run "make" and "make html" to check for errors.
# - Check if src/Makefile and src/feature.h don't contain any personal
#   preferences or the GTK, Perl, etc. mentioned above.
# - Check that runtime/doc/help.txt doesn't contain entries in "LOCAL
#   ADDITIONS".
# - Check file protections to be "644" for text and "755" for executables.
# - Check compiling on Amiga, MS-DOS and MS-Windows.
# - Delete all *~, *.sw?, *.orig, *.rej files
# - "make unixsrc", "make unixrt", "make extra", "make lang", "make html"
#
# Amiga:
# - "make amisrc", move the archive to the Amiga and compile the Amiga version
#   with "big" features.  Place the executables Vim and Xxd in this
#   directory (set the executable flag).
# - "make amirt", "make amibin".
#
# PC:
# - "make dossrc" and "make dosrt".  Unpack the archives on a PC.
# 16 bit DOS version:
# - Set environment for compiling with Borland C++ 3.1.  Adjust the paths in
#   src/Make_bc3.mak.
# - "ren Make_bc3.mak Makefile", "make" (compiling xxd will fail)
# - Set environment for compiling with Borland C++ 4.0 and "make xxd/xxd.exe".
# - "make test" and check the output.
# - Rename the executables to "vimd16.exe", "xxdd16.exe", and "installd16.exe".
# 32 bit DOS version:
# - Set environment for compiling with DJGPP; "make -f makefile.djg".
# - "rm testdir/*.out", "make -f makefile.djg test" and check the output.
# - Rename the executables to "vimd32.exe", "xxdd32.exe", and "installd32.exe".
# Win32 console version:
# - Set environment for Visual C++ 5.0: "vcvars32"
# - "nmake -f makefile.mvc"
# - "rm testdir/*.out", "nmake -f makefile.mvc test" and check the output.
# - Rename the executables to "vimw32.exe", "xxdw32.exe".
# - Delete vimrun.exe, install.exe and uninstall.exe.
# Win32 GUI version:
# - "nmake -f Make_gvc.mak".
# - move "gvim.exe" to here (otherwise the OLE version will overwrite it).
# Win32 GUI with OLE version:
# - "nmake -f Make_ovc.mak"
# - Rename "gvim.exe" to "gvim_ole.exe".
# Produce Gvimext.dll:
# - "cd gvimext", "nmake -f Makefile"
# - Move "gvimext.dll" to here.
# Win32s GUI version:
# - Set environment for Visual C++ 4.1 (requires a new console window)
# - "vcvars32" (use the path for VC 4.1)
# - "nmake -f Make_mvc.mak GUI=yes" (use the path for VC 4.1)
# - Rename "gvim.exe" to "gvim_w32s.exe".
# - Rename "install.exe" to "installw32.exe"
# - The produced uninstall.exe and vimrun.exe are used.
# - Move all the "*.exe" files to here.
# - "make dosbin".
# - "make doslang".
#
# OS/2:
# - Unpack the Unix "src", "extra" and "rt" archives.
# - "make -f makefile.os2".
# - Rename the executables to vimos2.exe, xxdos2.exe and teeos2.exe.
# - "make os2bin".

VIMVER	= vim-$(MAJOR).$(MINOR)
VERSION = $(MAJOR)$(MINOR)
VDOT	= $(MAJOR).$(MINOR)
VIMRTDIR = vim$(VERSION)

# Vim used for conversion from "unix" to "dos"
VIM	= vim

# source files for all source archives
SRC_ALL =	\
		src/README.txt \
		src/ascii.h \
		src/buffer.c \
		src/charset.c \
		src/diff.c \
		src/digraph.c \
		src/edit.c \
		src/eval.c \
		src/ex_cmds.c \
		src/ex_cmds.h \
		src/ex_cmds2.c \
		src/ex_docmd.c \
		src/ex_getln.c \
		src/farsi.c \
		src/farsi.h \
		src/feature.h \
		src/fileio.c \
		src/fold.c \
		src/getchar.c \
		src/globals.h \
		src/gui.c \
		src/gui.h \
		src/keymap.h \
		src/macros.h \
		src/main.c \
		src/mark.c \
		src/memfile.c \
		src/memline.c \
		src/menu.c \
		src/message.c \
		src/misc1.c \
		src/misc2.c \
		src/move.c \
		src/mbyte.c \
		src/normal.c \
		src/ops.c \
		src/option.c \
		src/option.h \
		src/proto.h \
		src/proto/buffer.pro \
		src/proto/charset.pro \
		src/proto/diff.pro \
		src/proto/digraph.pro \
		src/proto/edit.pro \
		src/proto/eval.pro \
		src/proto/ex_cmds.pro \
		src/proto/ex_cmds2.pro \
		src/proto/ex_docmd.pro \
		src/proto/ex_getln.pro \
		src/proto/fileio.pro \
		src/proto/fold.pro \
		src/proto/getchar.pro \
		src/proto/gui.pro \
		src/proto/main.pro \
		src/proto/mark.pro \
		src/proto/memfile.pro \
		src/proto/memline.pro \
		src/proto/menu.pro \
		src/proto/message.pro \
		src/proto/misc1.pro \
		src/proto/misc2.pro \
		src/proto/move.pro \
		src/proto/mbyte.pro \
		src/proto/normal.pro \
		src/proto/ops.pro \
		src/proto/option.pro \
		src/proto/quickfix.pro \
		src/proto/regexp.pro \
		src/proto/screen.pro \
		src/proto/search.pro \
		src/proto/syntax.pro \
		src/proto/tag.pro \
		src/proto/term.pro \
		src/proto/termlib.pro \
		src/proto/ui.pro \
		src/proto/undo.pro \
		src/proto/version.pro \
		src/proto/window.pro \
		src/quickfix.c \
		src/regexp.c \
		src/regexp.h \
		src/screen.c \
		src/search.c \
		src/structs.h \
		src/syntax.c \
		src/tag.c \
		src/term.c \
		src/term.h \
		src/termlib.c \
		src/testdir/*.in \
		src/testdir/*.ok \
		src/ui.c \
		src/undo.c \
		src/version.c \
		src/version.h \
		src/vim.h \
		src/window.c \
		src/xxd/xxd.c \

# source files for Unix
SRC_UNIX =	\
		Makefile \
		README_src.txt \
		configure \
		pixmaps/*.xpm \
		src/INSTALL \
		src/Makefile \
		src/auto/configure \
		src/config.h.in \
		src/config.mk.in \
		src/config.mk.dist \
		src/configure \
		src/configure.in \
		src/gui_at_fs.c \
		src/gui_at_sb.c \
		src/gui_at_sb.h \
		src/gui_athena.c \
		src/gui_beval.c \
		src/gui_beval.h \
		src/gui_gtk.c \
		src/gui_gtk_f.c \
		src/gui_gtk_f.h \
		src/gui_gtk_x11.c \
		src/gui_motif.c \
		src/gui_x11.c \
		src/hangulin.c \
		src/if_cscope.c \
		src/if_cscope.h \
		src/if_ruby.c \
		src/proto/if_ruby.pro \
		src/integration.c \
		src/integration.h \
		src/link.sh \
		src/mkinstalldirs \
		src/os_unix.c \
		src/os_unix.h \
		src/os_unixx.h \
		src/osdef.sh \
		src/osdef1.h.in \
		src/osdef2.h.in \
		src/pathdef.sh \
		src/proto/gui_athena.pro \
		src/proto/gui_beval.pro \
		src/proto/gui_gtk.pro \
		src/proto/gui_gtk_x11.pro \
		src/proto/gui_motif.pro \
		src/proto/gui_x11.pro \
		src/proto/hangulin.pro \
		src/proto/if_cscope.pro \
		src/proto/os_unix.pro \
		src/proto/pty.pro \
		src/proto/workshop.pro \
		src/pty.c \
		src/testdir/Makefile \
		src/testdir/unix.vim \
		src/toolcheck \
		src/vim_icon.xbm \
		src/vim_mask.xbm \
		src/vimtutor \
		src/workshop.c \
		src/workshop.h \
		src/wsdebug.c \
		src/wsdebug.h \
		src/xxd/Makefile \

# source files for both DOS and Unix
SRC_DOS_UNIX =	\
		src/if_perl.xs \
		src/if_perlsfio.c \
		src/if_python.c \
		src/if_tcl.c \
		src/proto/if_perl.pro \
		src/proto/if_perlsfio.pro \
		src/proto/if_python.pro \
		src/proto/if_tcl.pro \
		src/typemap \

# source files for DOS (also in the extra archive)
SRC_DOS =	\
		GvimExt \
		README_srcdos.txt \
		src/Make_gvc.mak \
		src/INSTALLole.txt \
		src/INSTALLpc.txt \
		src/Make_bc3.mak \
		src/Make_bc5.mak \
		src/Make_cyg.mak \
		src/Make_djg.mak \
		src/Make_ming.mak \
		src/Make_mvc.mak \
		src/Make_tcc.mak \
		src/Make_w16.mak \
		src/dimm.idl \
		src/dlldata.c \
		src/dosinst.c \
		src/glbl_ime.cpp \
		src/glbl_ime.h \
		src/gui_w16.c \
		src/gui_w32.c \
		src/gui_w48.c \
		src/guiw16rc.h \
		src/gui_w32_rc.h \
		src/if_ole.cpp \
		src/if_ole.h \
		src/if_ole.idl \
		src/Make_ovc.mak \
		src/iid_ole.c \
		src/os_dos.h \
		src/os_msdos.c \
		src/os_msdos.h \
		src/os_w32dll.c \
		src/os_w32exe.c \
		src/os_win16.c \
		src/os_win32.c \
		src/os_mswin.c \
		src/os_win16.h \
		src/os_win32.h \
		src/proto/gui_w16.pro \
		src/proto/gui_w32.pro \
		src/proto/if_ole.pro \
		src/proto/os_msdos.pro \
		src/proto/os_win16.pro \
		src/proto/os_win32.pro \
		src/proto/os_mswin.pro \
		src/testdir/Make_dos.mak \
		src/testdir/dos.vim \
		src/uninstal.c \
		src/vim.def \
		src/vim.rc \
		src/vim16.def \
		src/vim16.rc \
		src/vimrun.c \
		src/vimtbar.h \
		src/xxd/Make_bc3.mak \
		src/xxd/Make_bc5.mak \
		src/xxd/Make_cyg.mak \
		src/xxd/Make_djg.mak \
		src/xxd/Make_mvc.mak \
		nsis/gvim.nsi \
		nsis/README.txt \
		nsis/icons \


# source files for DOS without CR/LF translation (also in the extra archive)
SRC_DOS_BIN = 	\
		OleVim/OpenWithVim.bas \
		OleVim/OpenWithVim.pyw \
		OleVim/OpenWithVim.vbp \
		OleVim/OpenWithVim.vbw \
		OleVim/README.txt \
		OleVim/SendToVim.bas \
		OleVim/SendToVim.vbp \
		OleVim/SendToVim.vbw \
		VisVim/Commands.cpp \
		VisVim/Commands.h \
		VisVim/DSAddIn.cpp \
		VisVim/DSAddIn.h \
		VisVim/OleAut.cpp \
		VisVim/OleAut.h \
		VisVim/README.txt \
		VisVim/Reg.cpp \
		VisVim/Register.bat \
		VisVim/Res \
		VisVim/Resource.h \
		VisVim/StdAfx.cpp \
		VisVim/StdAfx.h \
		VisVim/UnRegist.bat \
		VisVim/VSVTypes.h \
		VisVim/VisVim.cpp \
		VisVim/VisVim.def \
		VisVim/VisVim.dsp \
		VisVim/VisVim.h \
		VisVim/VisVim.odl \
		VisVim/VisVim.rc \
		VisVim/VisVim_i.c \
		VisVim/VsReadMe.txt \
		src/tearoff.bmp \
		src/tools.bmp \
		src/tools16.bmp \
		src/vim*.ico \
		src/vim.tlb \
		src/vimtbar.lib \
		src/vimtbar.dll \

# source files for Amiga, DOS, etc. (also in the extra archive)
SRC_AMI_DOS =	\

# source files for Amiga (also in the extra archive)
SRC_AMI =	\
		README_amisrc.txt \
		README_amisrc.txt.info \
		src.info \
		src/INSTALLami.txt \
		src/Make_agui.mak \
		src/Make_dice.mak \
		src/Make_manx.mak \
		src/Make_sas.mak \
		src/gui_amiga.c \
		src/gui_amiga.h \
		src/os_amiga.c \
		src/os_amiga.h \
		src/proto/gui_amiga.pro \
		src/proto/os_amiga.pro \
		src/testdir/Make_amiga.mak \
		src/testdir/amiga.vim \
		src/xxd/Make_amiga.mak \

# source files for the Mac (also in the extra archive)
SRC_MAC =	\
		src/INSTALLmac.txt \
		src/Make_mpw.mak \
		src/gui_mac.c \
		src/gui_mac.r \
		src/os_mac* \
		src/proto/gui_mac.pro \
		src/proto/os_mac.pro \

# source files for VMS (also in the extra archive)
SRC_VMS =	\
		src/INSTALLvms.txt \
		src/Make_vms.mms \
		src/os_vms.c \
		src/os_vms.opt \
		src/os_vms_conf.h \
		src/os_vms_mms.c \
		src/os_vms_osdef.h \
		src/proto/os_vms.pro \
		src/testdir/Make_vms.mms \
		src/testdir/vms.vim \
		src/xxd/Make_vms.mms \

# source files for OS/2 (also in the extra archive)
SRC_OS2 =	\
		src/Make_os2.mak \
		src/os_os2_cfg.h \
		src/testdir/Make_os2.mak \
		src/testdir/todos.vim \
		src/testdir/os2.vim \
		src/xxd/Make_os2.mak \

# source files for QNX (also in the extra archive)
SRC_QNX =	\
		src/os_qnx.c \
		src/os_qnx.h \
		src/gui_photon.c \
		src/proto/gui_photon.pro \
		src/proto/os_qnx.pro \


# source files for the extra archive (all sources that are not for Unix)
SRC_EXTRA =	\
		$(SRC_AMI) \
		$(SRC_AMI_DOS) \
		$(SRC_DOS) \
		$(SRC_DOS_BIN) \
		$(SRC_MAC) \
		$(SRC_OS2) \
		$(SRC_QNX) \
		$(SRC_VMS) \
		README_os390.txt \
		src/Make_mint.mak \
		src/Make_ro.mak \
		src/gui_beos.cc \
		src/gui_beos.h \
		src/gui_riscos.c \
		src/gui_riscos.h \
		src/if_sniff.c \
		src/if_sniff.h \
		src/link.390 \
		src/os_beos.c \
		src/os_beos.h \
		src/os_beos.rsrc \
		src/os_mint.h \
		src/os_riscos.c \
		src/os_riscos.h \
		src/proto/gui_beos.pro \
		src/proto/gui_riscos.pro \
		src/proto/os_beos.pro \
		src/proto/os_riscos.pro \
		src/os_vms_fix.com \

# runtime files for all distributions
RT_ALL =	\
		README.txt \
		runtime/bugreport.vim \
		runtime/doc/*.awk \
		runtime/doc/*.pl \
		runtime/doc/*.txt \
		runtime/doc/Makefile \
		runtime/doc/doctags.c \
		runtime/doc/tags \
		runtime/doc/vim.1 \
		runtime/doc/evim.1 \
		runtime/doc/vimdiff.1 \
		runtime/doc/vimtutor.1 \
		runtime/doc/xxd.1 \
		runtime/filetype.vim \
		runtime/ftoff.vim \
		runtime/gvimrc_example.vim \
		runtime/macros/README.txt \
		runtime/macros/diffwin.vim \
		runtime/macros/hdiffwin.vim \
		runtime/macros/dvorak \
		runtime/macros/hanoi/click.me \
		runtime/macros/hanoi/hanoi.vim \
		runtime/macros/hanoi/poster \
		runtime/macros/justify.vim \
		runtime/macros/less.sh \
		runtime/macros/less.vim \
		runtime/macros/life/click.me \
		runtime/macros/life/life.vim \
		runtime/macros/maze/README.txt \
		runtime/macros/maze/[mM]akefile \
		runtime/macros/maze/maze.c \
		runtime/macros/maze/maze_5.78 \
		runtime/macros/maze/maze_mac \
		runtime/macros/maze/mazeansi.c \
		runtime/macros/maze/poster \
		runtime/macros/shellmenu.vim \
		runtime/macros/swapmous.vim \
		runtime/macros/urm/README.txt \
		runtime/macros/urm/examples \
		runtime/macros/urm/urm \
		runtime/macros/urm/urm.vim \
		runtime/menu.vim \
		runtime/delmenu.vim \
		runtime/makemenu.vim \
		runtime/mswin.vim \
		runtime/evim.vim \
		runtime/optwin.vim \
		runtime/plugin/*.vim \
		runtime/plugin/README.txt \
		runtime/scripts.vim \
		runtime/ftplugin.vim \
		runtime/ftplugof.vim \
		runtime/colors/README.txt \
		runtime/colors/*.vim \
		runtime/indent.vim \
		runtime/indoff.vim \
		runtime/indent/*.vim \
		runtime/indent/README.txt \
		runtime/ftplugin/*.vim \
		runtime/ftplugin/README.txt \
		runtime/syntax/*.vim \
		runtime/syntax/README.txt \
		runtime/termcap \
		runtime/tools \
		runtime/tutor/README.txt \
		runtime/tutor/tutor \
		runtime/tutor/tutor.vim \
		runtime/vimrc_example.vim \

# Unix runtime
RT_UNIX =	\
		README_unix.txt \
		runtime/vim16x16.xpm \
		runtime/vim32x32.xpm \
		runtime/vim48x48.xpm \

# Unix and DOS runtime without CR-LF translation
RT_UNIX_DOS_BIN =	\
		runtime/vim16x16.gif \
		runtime/vim32x32.gif \
		runtime/vim48x48.gif \

# runtime not for unix or extra
RT_NO_UNIX =	\

# runtime for Amiga (also in the extra archive)
RT_AMI_DOS =	\
		runtime/doc/vim.man \
		runtime/doc/vimdiff.man \
		runtime/doc/vimtutor.man \
		runtime/doc/xxd.man \

# DOS runtime (also in the extra archive)
RT_DOS =	\
		README_dos.txt \
		runtime/rgb.txt \

# Amiga runtime (also in the extra archive)
RT_AMI =	\
		README.txt.info \
		README_ami.txt \
		README_ami.txt.info \
		libs/arp.library \
		runtime/doc.info \
		runtime/doc/*.info \
		runtime/icons \
		runtime/icons.info \
		runtime/macros.info \
		runtime/macros/*.info \
		runtime/macros/hanoi/*.info \
		runtime/macros/life/*.info \
		runtime/macros/maze/*.info \
		runtime/macros/urm/*.info \
		runtime/tools.info \
		runtime/tutor.info \
		runtime/tutor/*.info \

# runtime files in extra archive
RT_EXTRA =	\
		$(RT_AMI) \
		$(RT_AMI_DOS) \
		$(RT_DOS) \
		README_mac.txt \
		runtime/macros/file_select.vim \

# included in all Amiga archives
ROOT_AMI =	\
		Contents \
		Contents.info \
		runtime.info \
		vimdir.info \

# root files for the extra archive
ROOT_EXTRA =	\
		$(ROOT_AMI) \

# files for Amiga small binary (also in extra archive)
BIN_AMI =	\
		README_amibin.txt \
		README_amibin.txt.info \
		Vim.info \
		Xxd.info \

# files for DOS binary (also in extra archive)
BIN_DOS =	\
		README_bindos.txt \
		uninstal.txt \

# files for Win32 OLE binary (also in extra archive)
BIN_OLE =	\
		README_ole.txt \

# files for Win32s binary (also in extra archive)
BIN_W32S =	\
		README_w32s.txt \

# files for VMS binary (also in extra archive)
BIN_VMS =	\
		README_vms.txt \

# files for OS/2 binary (also in extra archive)
BIN_OS2 =	\
		README_os2.txt \

# binary files for extra archive
BIN_EXTRA =	\
		$(BIN_AMI) \
		$(BIN_DOS) \
		$(BIN_OLE) \
		$(BIN_W32S) \
		$(BIN_VMS) \
		$(BIN_OS2) \

# all files for extra archive
EXTRA =		\
		$(BIN_EXTRA) \
		$(ROOT_EXTRA) \
		$(RT_EXTRA) \
		$(SRC_EXTRA) \
		OleVim/*.exe \
		README_extra.txt \
		VisVim/VisVim.dll \
		farsi \
		runtime/vimlogo.cdr \
		runtime/vimlogo.gif \
		runtime/vimlogo.xpm \
		src/swis.s \
		src/tee/Makefile* \
		src/tee/tee.c \
		csdpmi4b.zip \
		emx.dll \
		emxlibcs.dll \

# generic language files
LANG_GEN = \
		README_lang.txt \
		runtime/lang/README.txt \
		runtime/lang/menu_*.vim \
		runtime/keymap/README.txt \
		runtime/keymap/*.vim \
		runtime/tutor/tutor.?? \

# all files for lang archive
LANG_SRC = \
		src/po/README.txt \
		src/po/README_mingw.txt \
		src/po/cleanup.vim \
		src/po/Makefile \
		src/po/Make_ming.mak \
		src/po/*.po \

# the language files for the Win32 lang archive
LANG_DOS = \
		src/po/*.mo \

# All output is put in the "dist" directory.
dist:
	mkdir dist

# For the zip files we need to create a file with the comment line
dist/comment:
	mkdir dist/comment

COMMENT_RT = comment/$(VERSION)-rt
COMMENT_D16 = comment/$(VERSION)-bin-d16
COMMENT_D32 = comment/$(VERSION)-bin-d32
COMMENT_W32 = comment/$(VERSION)-bin-w32
COMMENT_GVIM = comment/$(VERSION)-bin-gvim
COMMENT_OLE = comment/$(VERSION)-bin-ole
COMMENT_W32S = comment/$(VERSION)-bin-w32s
COMMENT_SRC = comment/$(VERSION)-src
COMMENT_OS2 = comment/$(VERSION)-bin-os2
COMMENT_HTML = comment/$(VERSION)-html
COMMENT_FARSI = comment/$(VERSION)-farsi
COMMENT_LANG = comment/$(VERSION)-lang

dist/$(COMMENT_RT): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) runtime files for MS-DOS and MS-Windows" > dist/$(COMMENT_RT)

dist/$(COMMENT_D16): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) binaries for MS-DOS 16 bit real mode" > dist/$(COMMENT_D16)

dist/$(COMMENT_D32): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) binaries for MS-DOS 32 bit protected mode" > dist/$(COMMENT_D32)

dist/$(COMMENT_W32): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) binaries for MS-Windows NT/95" > dist/$(COMMENT_W32)

dist/$(COMMENT_GVIM): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) GUI binaries for MS-Windows NT/95" > dist/$(COMMENT_GVIM)

dist/$(COMMENT_OLE): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) MS-Windows GUI binaries with OLE support" > dist/$(COMMENT_OLE)

dist/$(COMMENT_W32S): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) GUI binaries for MS-Windows 3.1/3.11" > dist/$(COMMENT_W32S)

dist/$(COMMENT_SRC): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) sources for MS-DOS and MS-Windows" > dist/$(COMMENT_SRC)

dist/$(COMMENT_OS2): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) binaries + runtime files for OS/2" > dist/$(COMMENT_OS2)

dist/$(COMMENT_HTML): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) documentation in HTML" > dist/$(COMMENT_HTML)

dist/$(COMMENT_FARSI): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) Farsi language files" > dist/$(COMMENT_FARSI)

dist/$(COMMENT_LANG): dist/comment
	echo "Vim - Vi IMproved - v$(VDOT) MS-Windows language files" > dist/$(COMMENT_LANG)

unixrt: dist
	rm -f dist/$(VIMVER)-rt.tar.gz
	rm -f dist/$(VIMVER)-rt.tar.bz2
	rm -rf dist/$(VIMRTDIR)
	mkdir dist/$(VIMRTDIR)
	tar cf - \
		$(RT_ALL) \
		$(RT_UNIX) \
		$(RT_UNIX_DOS_BIN) \
		| (cd dist/$(VIMRTDIR); tar xvf -)
	cd dist && tar cvf $(VIMVER)-rt.tar $(VIMRTDIR)
	cp -f dist/$(VIMVER)-rt.tar dist/tt
	gzip -9 dist/$(VIMVER)-rt.tar
	mv -f dist/tt dist/$(VIMVER)-rt.tar
	bzip2 dist/$(VIMVER)-rt.tar

unixsrc: dist
	-rm -f dist/$(VIMVER)-src.tar.gz
	-rm -f dist/$(VIMVER)-src.tar.bz2
	-rm -rf dist/$(VIMRTDIR)
	mkdir dist/$(VIMRTDIR)
	tar cf - \
		$(SRC_ALL) \
		$(SRC_UNIX) \
		$(SRC_DOS_UNIX) \
		| (cd dist/$(VIMRTDIR); tar xvf -)
# Need to use a "distclean" config.mk file
	cp -f src/config.mk.dist dist/$(VIMRTDIR)/src/auto/config.mk
# Create an empty config.h file, make dependencies require it
	touch dist/$(VIMRTDIR)/src/auto/config.h
# Make sure configure is newer than config.mk to force it to be generated
	touch dist/$(VIMRTDIR)/src/configure
	cd dist && tar cvf $(VIMVER)-src.tar $(VIMRTDIR)
	cp -f dist/$(VIMVER)-src.tar dist/tt
	gzip -9 dist/$(VIMVER)-src.tar
	mv -f dist/tt dist/$(VIMVER)-src.tar
	bzip2 dist/$(VIMVER)-src.tar

extra: dist
	-rm -f dist/$(VIMVER)-extra.tar.gz
	-rm -rf dist/$(VIMRTDIR)
	mkdir dist/$(VIMRTDIR)
	tar cf - \
		$(EXTRA) \
		| (cd dist/$(VIMRTDIR); tar xvf -)
	cd dist && tar cvf $(VIMVER)-extra.tar $(VIMRTDIR)
	gzip -9 dist/$(VIMVER)-extra.tar

lang: dist
	-rm -f dist/$(VIMVER)-lang.tar.gz
	-rm -rf dist/$(VIMRTDIR)
	mkdir dist/$(VIMRTDIR)
	tar cf - \
		$(LANG_GEN) \
		$(LANG_SRC) \
		| (cd dist/$(VIMRTDIR); tar xvf -)
	cd dist && tar cvf $(VIMVER)-lang.tar $(VIMRTDIR)
	gzip -9 dist/$(VIMVER)-lang.tar

amirt: dist
	-rm -f dist/vim$(VERSION)rt.tar.gz
	-rm -rf dist/Vim
	mkdir dist/Vim
	mkdir dist/Vim/$(VIMRTDIR)
	tar cf - \
		$(ROOT_AMI) \
		$(RT_ALL) \
		$(RT_AMI) \
		$(RT_NO_UNIX) \
		$(RT_AMI_DOS) \
		| (cd dist/Vim/$(VIMRTDIR); tar xvf -)
	mv dist/Vim/$(VIMRTDIR)/vimdir.info dist/Vim.info
	mv dist/Vim/$(VIMRTDIR)/runtime.info dist/Vim/$(VIMRTDIR).info
	mv dist/Vim/$(VIMRTDIR)/runtime/* dist/Vim/$(VIMRTDIR)
	rmdir dist/Vim/$(VIMRTDIR)/runtime
	cd dist && tar cvf vim$(VERSION)rt.tar Vim Vim.info
	gzip -9 dist/vim$(VERSION)rt.tar
	mv dist/vim$(VERSION)rt.tar.gz dist/vim$(VERSION)rt.tgz

amibin: dist
	-rm -f dist/vim$(VERSION)bin.tar.gz
	-rm -rf dist/Vim
	mkdir dist/Vim
	mkdir dist/Vim/$(VIMRTDIR)
	tar cf - \
		$(ROOT_AMI) \
		$(BIN_AMI) \
		Vim \
		Xxd \
		| (cd dist/Vim/$(VIMRTDIR); tar xvf -)
	mv dist/Vim/$(VIMRTDIR)/vimdir.info dist/Vim.info
	mv dist/Vim/$(VIMRTDIR)/runtime.info dist/Vim/$(VIMRTDIR).info
	cd dist && tar cvf vim$(VERSION)bin.tar Vim Vim.info
	gzip -9 dist/vim$(VERSION)bin.tar
	mv dist/vim$(VERSION)bin.tar.gz dist/vim$(VERSION)bin.tgz

amisrc: dist
	-rm -f dist/vim$(VERSION)src.tar.gz
	-rm -rf dist/Vim
	mkdir dist/Vim
	mkdir dist/Vim/$(VIMRTDIR)
	tar cf - \
		$(ROOT_AMI) \
		$(SRC_ALL) \
		$(SRC_AMI) \
		$(SRC_AMI_DOS) \
		| (cd dist/Vim/$(VIMRTDIR); tar xvf -)
	mv dist/Vim/$(VIMRTDIR)/vimdir.info dist/Vim.info
	mv dist/Vim/$(VIMRTDIR)/runtime.info dist/Vim/$(VIMRTDIR).info
	cd dist && tar cvf vim$(VERSION)src.tar Vim Vim.info
	gzip -9 dist/vim$(VERSION)src.tar
	mv dist/vim$(VERSION)src.tar.gz dist/vim$(VERSION)src.tgz

no_title.vim: Makefile
	echo "set notitle noicon nocp nomodeline" >no_title.vim

dosrt: dist no_title.vim dist/$(COMMENT_RT)
	-rm -rf dist/vim$(VERSION)rt.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(RT_ALL) \
		$(RT_DOS) \
		$(RT_NO_UNIX) \
		$(RT_AMI_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	mv dist/vim/$(VIMRTDIR)/runtime/* dist/vim/$(VIMRTDIR)
	rmdir dist/vim/$(VIMRTDIR)/runtime
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp $(RT_UNIX_DOS_BIN) dist/vim/$(VIMRTDIR)
	cd dist && zip -9 -rD -z vim$(VERSION)rt.zip vim <$(COMMENT_RT)

dosbin: dosbin_gvim dosbin_w32 dosbin_d32 dosbin_d16 dosbin_ole dosbin_s

# make Win32 gvim
dosbin_gvim: dist no_title.vim dist/$(COMMENT_GVIM)
	-rm -rf dist/gvim$(VERSION).zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp gvim.exe dist/vim/$(VIMRTDIR)/gvim.exe
	cp xxdw32.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp vimrun.exe dist/vim/$(VIMRTDIR)/vimrun.exe
	cp installw32.exe dist/vim/$(VIMRTDIR)/install.exe
	cp uninstal.exe dist/vim/$(VIMRTDIR)/uninstal.exe
	cp gvimext.dll dist/vim/$(VIMRTDIR)/gvimext.dll
	cd dist && zip -9 -rD -z gvim$(VERSION).zip vim <$(COMMENT_GVIM)

# make Win32 console
dosbin_w32: dist no_title.vim dist/$(COMMENT_W32)
	-rm -rf dist/vim$(VERSION)w32.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp vimw32.exe dist/vim/$(VIMRTDIR)/vim.exe
	cp xxdw32.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp installw32.exe dist/vim/$(VIMRTDIR)/install.exe
	cp uninstal.exe dist/vim/$(VIMRTDIR)/uninstal.exe
	cd dist && zip -9 -rD -z vim$(VERSION)w32.zip vim <$(COMMENT_W32)

# make 32bit DOS
dosbin_d32: dist no_title.vim dist/$(COMMENT_D32)
	-rm -rf dist/vim$(VERSION)d32.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp vimd32.exe dist/vim/$(VIMRTDIR)/vim.exe
	cp xxdd32.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp installd32.exe dist/vim/$(VIMRTDIR)/install.exe
	cp csdpmi4b.zip dist/vim/$(VIMRTDIR)
	cd dist && zip -9 -rD -z vim$(VERSION)d32.zip vim <$(COMMENT_D32)

# make 16bit DOS
dosbin_d16: dist no_title.vim dist/$(COMMENT_D16)
	-rm -rf dist/vim$(VERSION)d16.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp vimd16.exe dist/vim/$(VIMRTDIR)/vim.exe
	cp xxdd16.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp installd16.exe dist/vim/$(VIMRTDIR)/install.exe
	cd dist && zip -9 -rD -z vim$(VERSION)d16.zip vim <$(COMMENT_D16)

# make Win32 gvim with OLE
dosbin_ole: dist no_title.vim dist/$(COMMENT_OLE)
	-rm -rf dist/gvim$(VERSION)ole.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp gvim_ole.exe dist/vim/$(VIMRTDIR)/gvim.exe
	cp xxdw32.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp vimrun.exe dist/vim/$(VIMRTDIR)/vimrun.exe
	cp installw32.exe dist/vim/$(VIMRTDIR)/install.exe
	cp uninstal.exe dist/vim/$(VIMRTDIR)/uninstal.exe
	cp gvimext.dll dist/vim/$(VIMRTDIR)/gvimext.dll
	cp README_ole.txt dist/vim/$(VIMRTDIR)
	mkdir dist/vim/$(VIMRTDIR)/VisVim
	cp VisVim/README.txt dist/vim/$(VIMRTDIR)/VisVim
	cp VisVim/VisVim.dll dist/vim/$(VIMRTDIR)/VisVim
	mkdir dist/vim/$(VIMRTDIR)/OleVim
	cp OleVim/README.txt dist/vim/$(VIMRTDIR)/OleVim
	cp OleVim/*.exe dist/vim/$(VIMRTDIR)/OleVim
	cd dist && zip -9 -rD -z gvim$(VERSION)ole.zip vim <$(COMMENT_OLE)

# make Win32s gvim
dosbin_s: dist no_title.vim dist/$(COMMENT_W32S)
	-rm -rf dist/gvim$(VERSION)_s.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_DOS) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp gvim_w32s.exe dist/vim/$(VIMRTDIR)/gvim.exe
	cp xxdd32.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp README_w32s.txt dist/vim/$(VIMRTDIR)
	cp installw32.exe dist/vim/$(VIMRTDIR)/install.exe
	cp uninstal.exe dist/vim/$(VIMRTDIR)/uninstal.exe
	cd dist && zip -9 -rD -z gvim$(VERSION)_s.zip vim <$(COMMENT_W32S)

# make Win32 lang archive
doslang: dist no_title.vim dist/$(COMMENT_LANG)
	-rm -rf dist/vim$(VERSION)lang.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	mkdir dist/vim/$(VIMRTDIR)/lang
	tar cf - \
		$(LANG_GEN) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	mv dist/vim/$(VIMRTDIR)/runtime/* dist/vim/$(VIMRTDIR)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	for i in $(LANG_DOS); do\
		n=`echo $$i | sed -e "s+src/po/\([a-zA-Z_]*\).mo+\1+"`; \
		mkdir dist/vim/$(VIMRTDIR)/lang/$$n; \
		mkdir dist/vim/$(VIMRTDIR)/lang/$$n/LC_MESSAGES; \
		cp $$i dist/vim/$(VIMRTDIR)/lang/$$n/LC_MESSAGES/vim.mo; \
	    done
	cd dist && zip -9 -rD -z vim$(VERSION)lang.zip vim <$(COMMENT_LANG)

# MS-DOS sources
dossrc: dist no_title.vim dist/$(COMMENT_SRC)
	-rm -rf dist/vim$(VERSION)src.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(SRC_ALL) \
		$(SRC_DOS) \
		$(SRC_AMI_DOS) \
		$(SRC_DOS_UNIX) \
		| (cd dist/vim/$(VIMRTDIR); tar xf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	tar cf - \
		$(SRC_DOS_BIN) \
		| (cd dist/vim/$(VIMRTDIR); tar xf -)
	cd dist && zip -9 -rD -z vim$(VERSION)src.zip vim <$(COMMENT_SRC)

os2bin: dist no_title.vim dist/$(COMMENT_OS2)
	-rm -rf dist/vim$(VERSION)os2.zip
	-rm -rf dist/vim
	mkdir dist/vim
	mkdir dist/vim/$(VIMRTDIR)
	tar cf - \
		$(BIN_OS2) \
		| (cd dist/vim/$(VIMRTDIR); tar xvf -)
	find dist/vim/$(VIMRTDIR) -type f -exec $(VIM) -u no_title.vim -c ":set tx|wq" {} \;
	cp vimos2.exe dist/vim/$(VIMRTDIR)/vim.exe
	cp xxdos2.exe dist/vim/$(VIMRTDIR)/xxd.exe
	cp teeos2.exe dist/vim/$(VIMRTDIR)/tee.exe
	cp emx.dll emxlibcs.dll dist/vim/$(VIMRTDIR)
	cd dist && zip -9 -rD -z vim$(VERSION)os2.zip vim <$(COMMENT_OS2)

html: dist dist/$(COMMENT_HTML)
	-rm -rf dist/vim$(VERSION)html.zip
	cd runtime/doc && zip -9 -z ../../dist/vim$(VERSION)html.zip *.html <../../dist/$(COMMENT_HTML)

farsi: dist dist/$(COMMENT_FARSI)
	-rm -f dist/farsi$(VERSION).zip
	zip -9 -rD -z dist/farsi$(VERSION).zip farsi < dist/$(COMMENT_FARSI)
