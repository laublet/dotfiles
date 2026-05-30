-- ast-grep pattern library — single source for nvim picker, sg-pick, cheatsheet
-- Edit here; see cheatsheets/ast-grep.md

return {
  patterns = {
    -- TypeScript / tooling
    {
      name = "console.log",
      pattern = "console.log($$$)",
      lang = "ts",
      desc = "console.log with any arguments",
    },
    {
      name = "import",
      pattern = "import $$$ from $SRC",
      lang = "ts",
      desc = "import … from '…'",
    },
    {
      name = "fetch",
      pattern = "fetch($URL)",
      lang = "ts",
      desc = "fetch(something)",
    },
    {
      name = "async fn",
      pattern = "async function $NAME($$$) { $$$ }",
      lang = "ts",
      desc = "async function declarations",
    },

    -- Go
    {
      name = "fmt.Println",
      pattern = "fmt.Println($$$)",
      lang = "go",
      desc = "fmt.Println(...)",
    },
    {
      name = "errors.New",
      pattern = "errors.New($MSG)",
      lang = "go",
      desc = "errors.New(\"…\")",
    },
    {
      name = "context.With",
      pattern = "context.With$METHOD($$$)",
      lang = "go",
      desc = "context.WithTimeout / WithCancel / …",
    },
    {
      name = "defer",
      pattern = "defer $EXPR",
      lang = "go",
      desc = "defer statements",
    },
    {
      name = "go func",
      pattern = "go func($$$) { $$$ }($$$)",
      lang = "go",
      desc = "go func() { … }()",
    },

    -- Lua (Neovim / dotfiles)
    {
      name = "require",
      pattern = 'require($MOD)',
      lang = "lua",
      desc = 'require("module")',
    },
    {
      name = "vim.keymap",
      pattern = "vim.keymap.set($$$)",
      lang = "lua",
      desc = "vim.keymap.set(...)",
    },
    {
      name = "lazy plugin",
      pattern = '{ "$PLUGIN", $$$ }',
      lang = "lua",
      desc = "lazy.nvim plugin entry",
    },

    -- Rust
    {
      name = "unwrap",
      pattern = "$EXPR.unwrap()",
      lang = "rust",
      desc = ".unwrap() calls",
    },
    {
      name = "println!",
      pattern = "println!($$$)",
      lang = "rust",
      desc = "println!(...)",
    },

    -- Python
    {
      name = "print",
      pattern = "print($$$)",
      lang = "python",
      desc = "print(...)",
    },
    {
      name = "def",
      pattern = "def $NAME($$$):",
      lang = "python",
      desc = "function definitions",
    },

    -- Shell
    {
      name = "export",
      pattern = "export $VAR=$VAL",
      lang = "bash",
      desc = "export VAR=value",
    },
  },
}
