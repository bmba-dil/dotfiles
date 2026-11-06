" Vim syntax file
" Language: nand2tetris HDL
" Note: nvim's builtin filetype.lua maps *.hdl to vhdl -- overridden in
"   lua/config/options.lua via vim.filetype.add
"
" Pin colors: every standard pin name gets its own hue so a signal can be
" picked out of a wall of near-identical parts. Colors live in
" lua/config/highlights.lua (section "nand2tetris HDL") so they track the
" palette; the hi def link lines here are only fallbacks.

if exists("b:current_syntax")
    finish
endif

syn case match

"---------------------------- comments
syn keyword hdlTodo contained TODO FIXME XXX NOTE
syn match hdlComment "//.*$" contains=hdlTodo
syn region hdlComment start="/\*" end="\*/" contains=hdlTodo

"---------------------------- structure
syn keyword hdlStatement CHIP
syn keyword hdlSection   IN OUT PARTS BUILTIN CLOCKED

" chip name in header: CHIP Mux16 {
" lookbehind, not \zs -- the CHIP keyword would otherwise win the match
syn match hdlChipName "\(\<CHIP\>\s\+\)\@<=\w\+"

" fallback for any pin name the buckets below don't know. Defined FIRST so
" the named rules, which come later, win the tie.
syn match hdlPin "\<\w\+\ze\s*=" contained

"---------------------------- pin names, one bucket per hue
" Exact names are keywords: a keyword always beats a match, and only ever
" matches a whole word, so plain `a` can't steal `aAndNsel`.
syn keyword hdlPinA    a
syn keyword hdlPinB    b
syn keyword hdlPinC    c
syn keyword hdlPinD    d
syn keyword hdlPinSel  sel
syn keyword hdlPinIn   in
syn keyword hdlPinOut  out
syn keyword hdlPinCtrl load reset inc address
syn keyword hdlPinAlu  x y zx nx zy ny f no zr ng carry sum
syn keyword hdlPinCpu  instruction inM outM writeM addressM pc

" Derived wires inherit the hue of the pin they start from.
"   <base>\u\w*   camelCase hump: aAndNsel, selOut, loadBit
"   n/not + base  negations:      nsel, nSel, notsel, notSel
" Single letters get no n-prefix rule -- \<na\w*\> would swallow `name`.
syn match hdlPinA    "\<a\u\w*\>"
syn match hdlPinA    "\<not[aA]\w*\>"
syn match hdlPinB    "\<b\u\w*\>"
syn match hdlPinB    "\<not[bB]\w*\>"
syn match hdlPinC    "\<c\u\w*\>"
syn match hdlPinC    "\<not[cC]\w*\>"
syn match hdlPinD    "\<d\u\w*\>"
syn match hdlPinD    "\<not[dD]\w*\>"
syn match hdlPinSel  "\<sel\u\w*\>"
syn match hdlPinSel  "\<n\%(ot\)\?[sS]el\w*\>"
syn match hdlPinIn   "\<in\u\w*\>"
syn match hdlPinIn   "\<n\%(ot\)\?[iI]n\w*\>"
syn match hdlPinOut  "\<out\u\w*\>"
syn match hdlPinOut  "\<n\%(ot\)\?[oO]ut\w*\>"
syn match hdlPinCtrl "\<\%(load\|reset\|inc\|address\)\u\w*\>"
syn match hdlPinCtrl "\<n\%(ot\)\?\%([lL]oad\|[rR]eset\|[iI]nc\|[aA]ddress\)\w*\>"
syn match hdlPinAlu  "\<\%(zx\|nx\|zy\|ny\|zr\|ng\|carry\|sum\)\u\w*\>"
syn match hdlPinCpu  "\<\%(instruction\|inM\|outM\|writeM\|addressM\|pc\)\u\w*\>"

syn cluster hdlPins contains=hdlPinA,hdlPinB,hdlPinC,hdlPinD,hdlPinSel,hdlPinIn,hdlPinOut,hdlPinCtrl,hdlPinAlu,hdlPinCpu,hdlPin

"---------------------------- pins/buses
syn match hdlEquals "="
syn match hdlBus "\[\d\+\(\.\.\d\+\)\?\]" contains=hdlNumber,hdlRange
syn match hdlRange "\.\." contained
syn match hdlNumber "\<\d\+\>"
syn keyword hdlBoolean true false

syn match hdlDelimiter "[;,]"

" part instantiation: Nand(a=..., b=..., out=...)
" LAST on purpose -- ties go to the item defined last, so a part name always
" beats any pin rule that could reach the same position.
syn match hdlPart "\<\w\+\ze\s*("

syn region hdlArgs matchgroup=hdlDelimiter start="(" end=")"
      \ contains=@hdlPins,hdlEquals,hdlBus,hdlNumber,hdlBoolean,hdlComment

"------------------------------ links
hi def link hdlComment      Comment
hi def link hdlTodo         Todo
hi def link hdlStatement    Statement
hi def link hdlSection      Keyword
hi def link hdlChipName     Type
hi def link hdlPart         Function
hi def link hdlPin          Identifier
hi def link hdlBus          Special
hi def link hdlRange        Operator
hi def link hdlNumber       Number
hi def link hdlBoolean      Boolean
hi def link hdlDelimiter    Delimiter

" fallbacks only -- highlights.lua defines these at startup, and hi def link
" is a no-op for a group that already exists.
hi def link hdlEquals       Delimiter
hi def link hdlPinA         Identifier
hi def link hdlPinB         Identifier
hi def link hdlPinC         Identifier
hi def link hdlPinD         Identifier
hi def link hdlPinSel       Identifier
hi def link hdlPinIn        Identifier
hi def link hdlPinOut       Identifier
hi def link hdlPinCtrl      Identifier
hi def link hdlPinAlu       Identifier
hi def link hdlPinCpu       Identifier

let b:current_syntax = "hdl"
