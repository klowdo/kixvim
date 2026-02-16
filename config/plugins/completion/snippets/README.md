# LuaSnip Snippets for Kixvim

This directory contains custom LuaSnip snippets for various languages.

## Current Snippets

### Go Snippets (`go.lua`)

50+ comprehensive Go snippets including:

- **Common Patterns**: `main`, `fn`, `meth`, `st`, `int`
- **Error Handling**: `iferr`, `errn`, `errw`, `errf`, `errt`
- **Loops**: `for`, `forr`, `fori`, `forv`
- **Concurrency**: `go`, `goch`, `wg`, `mu`, `rmu`, `ctx`, `ctxt`, `ctxd`
- **Testing**: `test`, `tdt`, `bench`
- **HTTP**: `handler`, `hm`, `mid`
- **Database**: `dbq`, `dbqr`, `dbex`
- **And many more...**

## Usage

### Triggering Snippets

1. Type the snippet keyword (e.g., `iferr`)
2. The snippet should appear in your completion menu
3. Select it with `Ctrl-y` or `Ctrl-n/Ctrl-p` and `Ctrl-y`
4. The snippet will expand automatically

### Navigation

- `Ctrl-k` - Expand snippet or jump to next placeholder
- `Ctrl-j` - Jump to previous placeholder
- `Ctrl-e` - Cycle through choice options (when multiple options available)
- `Ctrl-l`/`Ctrl-h` - Alternative jump keys (from nvim-cmp)

### Debug Commands

- `:SnippetsList` or `<leader>sl` - List all available snippets for current filetype
- Check startup messages for "Loaded X Go snippets" notification

## Troubleshooting

### Snippets not showing in completion?

1. **Verify filetype**: `:set filetype?` should show `go` for Go files
2. **Check loaded snippets**: Run `:SnippetsList` to see available snippets
3. **Verify LuaSnip is loaded**: `:lua print(require('luasnip'))` should not error
4. **Check completion sources**: `:lua print(vim.inspect(require('cmp').get_config().sources))`
5. **Rebuild**: Run `nix run .` to rebuild with latest changes

### Snippets not expanding?

1. Make sure you're typing at least 2 characters (keyword_length = 2)
2. Check that the snippet trigger matches exactly
3. Try manual completion with `Ctrl-Space`

## Adding New Snippets

### For Go

Edit `go.lua` and add new snippet definitions:

```lua
s("trigger", fmt([[
  code here with {}
]], {
  i(1, "placeholder")
})),
```

### For Other Languages

Create a new file (e.g., `python.lua`, `rust.lua`) following this structure:

```lua
-- Language snippets for LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

language_snippets = {
  s("trigger", fmt([[
    code
  ]], {})),
}
```

Then add it to `config/plugins/snippets.nix`:

```nix
extraConfigLuaPre = ''
  ${builtins.readFile ./snippets/go.lua}
  ${builtins.readFile ./snippets/python.lua}
'';

extraConfigLua = ''
  -- ...
  if python_snippets then
    ls.add_snippets("python", python_snippets)
  end
  -- ...
'';
```

## Resources

- [LuaSnip Documentation](https://github.com/L3MON4D3/LuaSnip)
- [LuaSnip Snippet Format](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md)
- [Friendly Snippets](https://github.com/rafamadriz/friendly-snippets) - Additional VSCode-style snippets included
