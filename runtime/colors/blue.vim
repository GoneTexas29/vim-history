" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Steven Vertigan <steven@vertigan.wattle.id.au>
" Last Change:	2001 Sep 10
" Revision #3: Improved formatting, fixed html formatting

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "blue"
hi Normal		guifg=white		guibg=darkBlue	
hi Normal		ctermfg=white	ctermbg=darkBlue
hi NonText		guifg=magenta	ctermfg=lightMagenta
hi comment		guifg=gray		gui=bold	
hi comment		ctermfg=gray
hi constant		guifg=cyan		ctermfg=cyan
hi identifier	guifg=gray		ctermfg=gray
hi statement	guifg=yellow	gui=none	ctermfg=yellow
hi preproc		guifg=green		ctermfg=green
hi type			guifg=orange	ctermfg=darkYellow
hi special		guifg=magenta	ctermfg=lightMagenta

hi ErrorMsg		guifg=orange	guibg=darkBlue	
hi ErrorMsg		ctermfg=lightRed
hi WarningMsg	guifg=cyan		guibg=darkBlue	gui=bold	
hi WarningMsg	ctermfg=cyan
hi ModeMsg		guifg=yellow	gui=NONE
hi ModeMsg		ctermfg=yellow
hi MoreMsg		guifg=yellow	gui=NONE
hi MoreMsg		ctermfg=yellow
hi Error		guifg=red		guibg=darkBlue	gui=underline
hi Error		ctermfg=red

hi Todo			guifg=black		guibg=orange
hi Todo			ctermfg=black	ctermbg=darkYellow
hi Cursor		guifg=black		guibg=white
hi Cursor		ctermfg=black	ctermbg=white
hi Search		guifg=black		guibg=orange
hi Search		ctermfg=black	ctermbg=darkYellow
hi IncSearch	guifg=black		guibg=yellow
hi IncSearch	ctermfg=black	ctermbg=darkYellow
hi LineNr		guifg=pink		ctermfg=lightMagenta
hi title		guifg=white	gui=bold	cterm=bold

hi StatusLineNC	gui=NONE	guifg=black guibg=blue
hi StatusLineNC	ctermfg=black  ctermbg=blue
hi StatusLine	gui=bold	guifg=cyan	guibg=blue
hi StatusLine	ctermfg=cyan   ctermbg=blue

hi label		guifg=yellow	ctermfg=yellow
hi operator		guifg=orange	gui=bold	ctermfg=darkYellow
hi clear Visual
hi Visual		term=reverse 
hi Visual 		ctermfg=black	ctermbg=darkCyan
hi Visual		guifg=black		guibg=darkCyan

hi DiffChange	guibg=darkGreen		guifg=black
hi DiffChange	ctermbg=darkGreen	ctermfg=black
hi DiffText		guibg=olivedrab		guifg=black
hi DiffText		ctermbg=lightGreen	ctermfg=black
hi DiffAdd		guibg=slateblue		guifg=black
hi DiffAdd		ctermbg=blue		ctermfg=black
hi DiffDelete   guibg=coral			guifg=black	
hi DiffDelete	ctermbg=cyan		ctermfg=black

hi Folded		guibg=orange		guifg=black	
hi Folded		ctermbg=yellow		ctermfg=black
hi FoldColumn	guibg=gray30		guifg=black
hi FoldColumn	ctermbg=gray		ctermfg=black
hi cIf0			guifg=gray			ctermfg=gray

" HTML Specific stuff
hi htmlLink					guifg=cyan	gui=underline	guibg=darkBlue
hi htmlLink					ctermfg=cyan		cterm=underline
hi htmlBold					term=bold 			cterm=bold				gui=bold
hi htmlBoldUnderline		term=bold,underline cterm=bold,underline	gui=bold
hi htmlBoldItalic          	term=bold,italic 	cterm=bold,italic	
hi htmlBoldItalic			gui=bold,italic
hi htmlBoldUnderlineItalic	gui=bold,italic,underline
hi htmlBoldUnderlineItalic	term=bold,italic,underline
hi htmlBoldUnderlineItalic	cterm=bold,italic,underline
hi htmlUnderline           	term=underline	cterm=underline		gui=underline
hi htmlUnderlineItalic     	term=italic,underline	cterm=italic,underline
hi htmlUnderlineItalic		gui=italic,underline 
hi htmlItalic              	term=italic		cterm=italic		gui=italic
