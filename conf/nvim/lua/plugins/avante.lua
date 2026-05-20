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
  config = function(_, opts)
    require("avante").setup(opts)

    -- Avante sidebar sets cursorline=false and winhighlight CursorLine:Normal (hides crosshair).
    vim.api.nvim_create_augroup("dotfiles_avante_crosshair", { clear = true })
    local fixing_crosshair = false
    local function restore_crosshair()
      if fixing_crosshair then
        return
      end
      local ft = vim.bo.filetype
      if not ft:match("^Avante") then
        return
      end

      local wh = vim.wo.winhighlight
      local needs_wh = wh:find("CursorLine:Normal", 1, true) or wh:find("CursorColumn:Normal", 1, true)
      local needs_cursor = not vim.wo.cursorline or not vim.wo.cursorcolumn
      if not needs_wh and not needs_cursor then
        return
      end

      fixing_crosshair = true
      if needs_cursor then
        vim.wo.cursorline = true
        vim.wo.cursorcolumn = true
      end
      if needs_wh then
        vim.wo.winhighlight = wh
          :gsub("CursorLine:Normal,", "CursorLine:CursorLine,")
          :gsub("CursorColumn:Normal,", "CursorColumn:CursorColumn,")
          :gsub("CursorLine:Normal", "CursorLine:CursorLine")
          :gsub("CursorColumn:Normal", "CursorColumn:CursorColumn")
      end
      fixing_crosshair = false
    end
    vim.api.nvim_create_autocmd({ "WinEnter", "FileType", "OptionSet" }, {
      group = "dotfiles_avante_crosshair",
      callback = function(ev)
        if ev.event == "OptionSet" and ev.match ~= "winhighlight" and ev.match ~= "cursorline" and ev.match ~= "cursorcolumn" then
          return
        end
        restore_crosshair()
      end,
    })
  end,
}
