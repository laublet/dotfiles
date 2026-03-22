return {
  "ibhagwan/fzf-lua",
  cond = not vim.g.vscode,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  keys = {
    { "<leader>f", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>g", function() require("fzf-lua").live_grep_native() end, desc = "Live grep" },
    { "<leader>b", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "<leader>r", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
    { "<leader>/", function() require("fzf-lua").grep_curbuf() end, desc = "Search in buffer" },
    { "<leader>s", function() require("fzf-lua").lsp_document_symbols() end, desc = "Document symbols" },
    { "<leader>S", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>:", function() require("fzf-lua").command_history() end, desc = "Command history" },
    { "<leader>?", function() require("fzf-lua").keymaps() end, desc = "Keymaps" },
    {
      "<leader>H",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.expand("~/dev/perso/dotfiles/cheatsheets"),
          prompt = "Cheatsheets❯ ",
          actions = {
            ["default"] = function(selected)
              local file = selected[1]:match("[^%s]+$") or selected[1]
              local path = vim.fn.expand("~/dev/perso/dotfiles/cheatsheets/") .. file
              vim.cmd("edit " .. vim.fn.fnameescape(path))
            end,
          },
        })
      end,
      desc = "Cheatsheets",
    },
  },
  config = function()
    -- Workaround: Neovim 0.11 has a bug with require() in -l (script) mode
    -- that breaks fzf-lua's headless child process (spawn.lua:37 deserialize).
    -- Any option that triggers fn_transform (file_icons, git_icons, rg_glob,
    -- strip_cwd_prefix, etc.) forces the headless wrapper.
    -- Solution: disable all such options so fd/rg pipe raw to fzf.
    -- Grep uses live_grep_native() which explicitly disables all processing.
    require("fzf-lua").setup({
      defaults = {
        file_icons = false,
        git_icons = false,
      },
      winopts = {
        height = 0.85,
        width = 0.85,
        preview = { layout = "horizontal", horizontal = "right:55%" },
      },
      fzf_opts = { ["--layout"] = "reverse" },
      files = {
        file_icons = false,
        git_icons = false,
      },
    })
  end,
}
