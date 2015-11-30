# Gosrc plugin for Vim

`:Gosrc` command open a golang source file with completion which is at
`$GOROOT` or `$GOPATH`.

## Install

Copy `plugin/go/gosrc.vim` into your `~.vim/plugin` or so.

## How to use

When you type like this

    :Github gi<tab>

You'll get like this

    :Github github.com/

It was completed from `$GOROOT` or `$GOPATH`.

Then complete path for depth...

    :Github github.com/koron/upgorade/upgorade-vim.go<ENTER>

It opens (with `:split`) a source file from `$GOPATH` (or `$GOROOT`).
