-- https://github.com/yetone/avante.nvim
-- Primary: provider = "opencode" via ACP → `opencode acp` (OpenCode Go).
-- Backup: acp_providers.cursor → cursor-agent if Cursor is available again.
--   Switch live: :AvanteSwitchProvider cursor — runbook: vault Wiki/OpenCode — plan secours agent.md
-- Claude: direct API fallback (select via <leader>a?).
-- Default prefix <leader>a (e.g. <leader>at toggle). LSP code actions: <leader>la.

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
    provider = "opencode",
    -- Cursor Tab (multi-location ghost): uses Llm.stream + providers.*, not ACP.
    -- Agent/chat stays on cursor ACP; inline Tab needs a classic provider (claude here).
    -- Requires AVANTE_ANTHROPIC_API_KEY or ANTHROPIC_API_KEY — else :AvanteToggleSuggestion / Supermaven.
    auto_suggestions_provider = "claude",
    mode = "agentic",
    behaviour = {
      auto_suggestions = true,
    },
    suggestion = {
      debounce = 600,
      throttle = 800,
    },
    mappings = {
      suggestion = {
        -- Tab is wired in cmp.lua (Avante > Supermaven > cmp); keep Alt+l as fallback.
        accept = "<M-l>",
        dismiss = "<C-]>",
      },
    },
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
      opencode = {
        command = "opencode",
        args = { "acp" },
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
          max_tokens = 4096,
          temperature = 0.2,
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
