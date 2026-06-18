-- https://github.com/sindrets/diffview.nvim
-- Repo-wide and per-file diffs (paired with Neogit). Edit the working-tree
-- pane (B / right in horizontal layout); the other side is read-only git state.

local api = vim.api

local diffview_winhl =
  "DiffAdd:DiffviewDiffAdd,DiffDelete:DiffviewDiffDelete,DiffChange:DiffviewDiffChange,DiffText:DiffviewDiffText"

local NEW_FILE_STATUS = { A = true, ["?"] = true }

---@param bufnr integer
---@param ctx? table
---@return { entry: table, file: table, symbol: string, status: string }?
local function get_diffview_file(bufnr, ctx)
  local ok, lib = pcall(require, "diffview.lib")
  if not ok then
    return nil
  end

  local view = lib.get_current_view()
  if not view or not view.cur_entry then
    return nil
  end

  local entry = view.cur_entry
  for _, file in ipairs(entry.layout:files()) do
    if file.bufnr == bufnr then
      return {
        entry = entry,
        file = file,
        symbol = (ctx and ctx.symbol) or file.symbol or "",
        status = entry.status,
      }
    end
  end

  return nil
end

--- Fallback when git status is unavailable (e.g. race on first paint).
local function is_all_diff_add(bufnr)
  local n = api.nvim_buf_line_count(bufnr)
  if n == 0 then
    return false
  end
  for lnum = 1, n do
    local hlid = vim.fn.diff_hlID(bufnr, lnum)
    if hlid == 0 then
      return false
    end
    local name = vim.fn.synIDattr(hlid, "name")
    if name ~= "DiffAdd" and name ~= "DiffviewDiffAdd" then
      return false
    end
  end
  return true
end

--- Brand-new / untracked file on the editable side: plain buffer + treesitter.
local function is_plain_new_file(bufnr, ctx)
  local info = get_diffview_file(bufnr, ctx)
  if info then
    if info.file.nulled or not NEW_FILE_STATUS[info.status] then
      return false
    end
    -- diff2: side "b" holds working-tree content; side "a" is nulled for adds.
    if info.symbol == "b" then
      return true
    end
    local ok, RevType = pcall(function()
      return require("diffview.vcs.rev").RevType
    end)
    if ok and info.file.rev and info.file.rev.type == RevType.LOCAL then
      return true
    end
    return false
  end

  return is_all_diff_add(bufnr)
end

local function enable_treesitter(bufnr)
  if not vim.treesitter then
    return
  end

  local ft = vim.bo[bufnr].filetype
  if ft == "" or ft == "diff" then
    local name = api.nvim_buf_get_name(bufnr)
    if name ~= "" then
      local detected = vim.filetype.match({ filename = name, buf = bufnr })
      if detected and detected ~= "diff" then
        vim.bo[bufnr].filetype = detected
        ft = detected
      end
    end
  end

  if ft == "" or ft == "diff" then
    return
  end

  pcall(vim.treesitter.start, bufnr, ft)
end

local function apply_diffview_window(bufnr, ctx)
  vim.opt_local.wrap = false
  vim.opt_local.list = false

  local plain = is_plain_new_file(bufnr, ctx)
  if plain then
    vim.wo.diff = false
    vim.wo.foldmethod = "manual"
    vim.wo.foldenable = false
    vim.wo.foldcolumn = "0"
    vim.opt_local.winhighlight = ""
  else
    vim.wo.diff = true
    vim.wo.foldmethod = "diff"
    vim.wo.foldenable = true
    vim.wo.foldcolumn = "1"
    vim.opt_local.winhighlight = diffview_winhl
  end

  enable_treesitter(bufnr)
end

--- Run in the diff window; re-check once after diff highlighting is computed.
local function configure_diff_buffer(bufnr, ctx, winid)
  local run = function()
    if not api.nvim_buf_is_valid(bufnr) then
      return
    end
    apply_diffview_window(bufnr, ctx)
  end

  run()

  vim.defer_fn(function()
    if not api.nvim_buf_is_valid(bufnr) then
      return
    end
    if winid and api.nvim_win_is_valid(winid) and api.nvim_win_get_buf(winid) == bufnr then
      api.nvim_win_call(winid, run)
    else
      run()
    end
  end, 50)
end

local function open_repo()
  local git = require("utils.git")
  local root = git.root()
  if not root then
    vim.notify("Diffview: not in a git repository", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewOpen " .. git.diffview_c_flag(root))
end

local function open_file_history()
  local git = require("utils.git")
  local root = git.root()
  if not root then
    vim.notify("Diffview: not in a git repository", vim.log.levels.WARN)
    return
  end
  local file = api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Diffview: buffer has no file path", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewFileHistory " .. git.diffview_c_flag(root) .. " " .. vim.fn.fnameescape(file))
end

return {
  "sindrets/diffview.nvim",
  cond = not vim.g.vscode,
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
  },
  keys = {
    { "<leader>gd", open_repo,          desc = "Git: Diffview open (HEAD vs working)" },
    { "<leader>gD", open_file_history,  desc = "Git: Diffview file history (current)" },
    { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Git: Diffview close" },
  },
  config = function()
    require("diffview").setup({
      -- Softer delete fill-chars in 2-way layouts (see :help diffview-config-enhanced_diff_hl).
      enhanced_diff_hl = true,
      default_args = {
        -- Local file on the "new" side when comparing revs (LSP + editable buffer).
        DiffviewOpen = { "--imply-local" },
        -- File history: right side = on-disk file so you can edit the current version.
        DiffviewFileHistory = { "--base=LOCAL" },
      },
      hooks = {
        diff_buf_read = function(bufnr, ctx)
          configure_diff_buffer(bufnr, ctx)
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          configure_diff_buffer(bufnr, ctx, winid)
        end,
      },
    })
  end,
}
