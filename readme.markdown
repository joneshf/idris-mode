# idris-mode for emacs

This is an emacs mode for editing [Idris][] code.

Syntax highlighting functional languages is a little quirky; I've
deferred to haskell-mode for some things
(e.g. `font-lock-variable-name-face` for operators) and done some
other things as appropriate for Idris. `font-lock-type-face` isn't
used at all, for example, and data types declared with `data` use the
same face as functions and values defined with `=`.

I'm going to write keybindings for REPL interaction (a la
haskell-mode) soon; right now it just highlights syntax.

[Idris]: idris-lang.org

## Installation

Drop `idris.el` somewhere in your load path and `(require 'idris)`
somewhere in `~/.emacs` or `~.emacs.d/init.el`.