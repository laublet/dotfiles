-- https://github.com/yetone/avante.nvim
-- Provider = "cursor" via ACP (Agent Client Protocol) — connects to the
-- locally installed cursor-agent CLI for agentic edits, codebase indexing,
-- and Cursor's composer models. Run `cursor-agent login` once in a shell to
-- authenticate before first use. Switch provider live with <leader>am.
-- Claude is kept configured as a fallback (select via <leader>a?).
-- Doc: https://cursor.com/docs/cli/acp#neovim-avantenvim
-- Default prefix is <leader>a (e.g. <leader>at toggle). LSP code actions use <leader>la instead.

return {
  "yetone/avante.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    provider = "cursor",
    mode = "agentic",
    acp_providers = {
      cursor = {
        command = os.getenv("HOME") .. "/.local/bin/cursor-agent",
        args = { "acp" },
        auth_method = "cursor_login",
        env = {
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
        },
      },
    },
    -- Claude kept as a fallback: switch with <leader>a? (select model) or via
    -- :AvanteSwitchProvider claude. Useful when you want pure Q&A without
    -- tool calls, or if the Cursor account hits a rate limit.
    providers = {
      claude = {
        model = "claude-sonnet-4-20250514",
        extra_request_body = {
          max_tokens = 8192,
        },
      },
    },
  },
}
