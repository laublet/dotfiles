--- Markdown preview via glow in a floating terminal (true TTY → ANSI colors).
--- Replaces ellisonleao/glow.nvim (archived): that plugin piped stdout into a term
--- buffer, so glow often rendered without color even with `-s dark`.
local M = {}

---@class GlowPreviewConfig
---@field glow_path string
---@field style "dark"|"light"
---@field border string
---@field width_ratio number
---@field height_ratio number
---@field width number|nil
---@field height number|nil

local config = {
  glow_path = vim.fn.exepath("glow") or "glow",
  style = "dark",
  border = "rounded",
  width_ratio = 0.85,
  height_ratio = 0.85,
}

local state = {
  win = nil,
  buf = nil,
  job_id = nil,
  tmpfile = nil,
}

local function notify_err(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "glow" })
end

local function cleanup()
  if state.tmpfile then
    pcall(vim.fn.delete, state.tmpfile)
    state.tmpfile = nil
  end
end

local function stop_job()
  if state.job_id and state.job_id > 0 then
    pcall(vim.fn.jobstop, state.job_id)
  end
  state.job_id = nil
end

local function close()
  stop_job()
  cleanup()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  state.win = nil
  state.buf = nil
end

local function is_md_ft(ft)
  return vim.tbl_contains({
    "markdown",
    "markdown.pandoc",
    "markdown.gfm",
    "wiki",
    "vimwiki",
    "telekasten",
  }, ft)
end

local function is_md_ext(ext)
  return vim.tbl_contains({
    "md",
    "markdown",
    "mkd",
    "mkdn",
    "mdwn",
    "mdown",
    "mdtxt",
    "mdtext",
    "rmd",
    "wiki",
  }, string.lower(ext or ""))
end

local function tmp_file()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if vim.tbl_isempty(lines) then
    notify_err("buffer is empty")
    return nil
  end
  local tmp = vim.fn.tempname() .. ".md"
  vim.fn.writefile(lines, tmp)
  return tmp
end

---@return table<string,string>
local function term_env()
  local env = vim.fn.environ()
  if not env.TERM or env.TERM == "" or env.TERM == "dumb" then
    env.TERM = "xterm-256color"
  end
  if not env.COLORTERM or env.COLORTERM == "" then
    env.COLORTERM = "truecolor"
  end
  env.NO_COLOR = nil
  return env
end

local function resolve_style()
  if config.style == "light" or config.style == "dark" then
    return config.style
  end
  return vim.o.background == "light" and "light" or "dark"
end

local function open_window(file)
  if vim.fn.executable(config.glow_path) == 0 then
    notify_err("glow not found in PATH")
    return
  end

  local width = vim.o.columns
  local height = vim.o.lines
  local win_height = math.ceil(height * (config.height_ratio or 0.85))
  local win_width = math.ceil(width * (config.width_ratio or 0.85))
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  if config.width and config.width < win_width then
    win_width = config.width
  end
  if config.height and config.height < win_height then
    win_height = config.height
  end

  state.buf = vim.api.nvim_create_buf(false, true)
  state.win = vim.api.nvim_open_win(state.buf, true, {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = config.border,
  })

  vim.api.nvim_win_set_option(state.win, "winblend", 0)
  vim.api.nvim_buf_set_option(state.buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(state.buf, "filetype", "glowpreview")

  local map_opts = { silent = true, buffer = state.buf }
  vim.keymap.set("n", "q", close, map_opts)
  vim.keymap.set("n", "<Esc>", close, map_opts)

  local style = resolve_style()
  local cmd = {
    config.glow_path,
    "-s",
    style,
    "-w",
    tostring(win_width),
    file,
  }

  state.job_id = vim.fn.termopen(cmd, {
    env = term_env(),
    on_exit = function()
      vim.schedule(function()
        state.job_id = nil
        cleanup()
      end)
    end,
  })

  if state.job_id <= 0 then
    notify_err("failed to start glow in terminal")
    close()
    return
  end

  vim.cmd.startinsert()
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  config.style = config.style == "light" and "light" or "dark"
end

---@param opts table? { fargs: string[], bang: boolean }
function M.execute(opts)
  opts = opts or { fargs = {} }

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    if opts.bang then
      close()
    end
    return
  end

  local file = opts.fargs[1]
  if file and file ~= "" then
    if vim.fn.filereadable(file) == 0 then
      notify_err("cannot read file: " .. file)
      return
    end
    if not is_md_ext(vim.fn.fnamemodify(file, ":e")) then
      notify_err("preview only works on markdown files")
      return
    end
  else
    if not is_md_ft(vim.bo.filetype) then
      notify_err("preview only works on markdown files")
      return
    end
    file = tmp_file()
    if not file then
      return
    end
    state.tmpfile = file
  end

  open_window(file)
end

function M.setup_commands()
  vim.api.nvim_create_user_command("Glow", function(o)
    M.execute({ fargs = o.fargs, bang = o.bang })
  end, { nargs = "?", bang = true, complete = "file" })
end

return M
