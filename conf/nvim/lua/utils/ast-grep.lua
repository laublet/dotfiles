-- ast-grep (sg) structural search via fzf-lua

local M = {}

local ft_lang = {
  typescript = "ts",
  typescriptreact = "tsx",
  javascript = "js",
  javascriptreact = "jsx",
  lua = "lua",
  rust = "rust",
  go = "go",
  python = "python",
  html = "html",
  css = "css",
  json = "json",
  markdown = "markdown",
  bash = "bash",
  sh = "bash",
  zsh = "bash",
}

local function default_lang()
  return ft_lang[vim.bo.filetype] or "ts"
end

local function resolve_lang(lang)
  if lang and lang ~= "" then
    return lang
  end
  return default_lang()
end

-- sg prints "path:line:line_text" (no column). fzf-lua expects path:line:col:text.
local function sg_line_to_entry(line)
  local path, lnum, text = line:match("^([^:]+):(%d+):(.*)$")
  if not path then
    return nil
  end
  return string.format("%s:%s:1:%s", path, lnum, text)
end

function M.search_with_pattern(paths, prompt_label, pattern, lang)
  if vim.fn.executable("sg") ~= 1 then
    vim.notify("sg (ast-grep) not in PATH — brew install ast-grep", vim.log.levels.ERROR)
    return
  end

  if not pattern or pattern == "" then
    return
  end

  lang = resolve_lang(lang)

  local path_arg = type(paths) == "table"
      and table.concat(vim.tbl_map(vim.fn.shellescape, paths), " ")
    or vim.fn.shellescape(paths)

  local cmd = string.format(
    "sg run --color=never -p %s -l %s %s",
    vim.fn.shellescape(pattern),
    vim.fn.shellescape(lang),
    path_arg
  )

  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 and #lines == 0 then
    vim.notify("ast-grep: no matches (or pattern error)", vim.log.levels.INFO)
    return
  end

  local entries = {}
  for _, line in ipairs(lines) do
    local entry = sg_line_to_entry(line)
    if entry then
      entries[#entries + 1] = entry
    end
  end

  if #entries == 0 then
    vim.notify("ast-grep: no matches", vim.log.levels.INFO)
    return
  end

  local core = require("fzf-lua.core")
  local actions = require("fzf-lua.actions")
  local opts = core.set_fzf_field_index({
    prompt = prompt_label,
    cwd = vim.fn.getcwd(),
    previewer = "builtin",
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
    },
  })

  core.fzf_exec(entries, opts)
end

function M.search(paths, prompt_label)
  local pattern = vim.fn.input("ast-grep pattern: ")
  if pattern == "" then
    return
  end
  local lang_hint = default_lang()
  local lang = vim.fn.input("Language [" .. lang_hint .. "]: ", lang_hint)
  M.search_with_pattern(paths, prompt_label, pattern, lang)
end

function M.pick_pattern(paths, scope_label)
  local patterns = require("ast-grep-patterns").patterns
  local lines = {}
  for i, p in ipairs(patterns) do
    lines[#lines + 1] = string.format(
      "%02d  %-18s  %-4s  %s",
      i,
      p.name,
      p.lang or "",
      p.desc or p.pattern
    )
  end

  local prompt_label = string.format("ast-grep (%s)❯ ", scope_label)
  local core = require("fzf-lua.core")

  core.fzf_exec(lines, {
    prompt = "ast-grep pattern❯ ",
    fzf_opts = {
      ["--header"] = "Enter=search · Esc=cancel",
      ["--preview"] = "echo {+2} · lang {3} · pattern from library",
    },
    actions = {
      ["default"] = function(selected)
        local idx = tonumber(selected[1]:match("^(%d+)"))
        if not idx then
          return
        end
        local p = patterns[idx]
        if not p then
          return
        end
        M.search_with_pattern(paths, prompt_label, p.pattern, p.lang)
      end,
    },
  })
end

function M.search_cwd()
  M.pick_pattern(vim.fn.getcwd(), "cwd")
end

function M.search_file_dir()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or dir == "." then
    vim.notify("No file buffer — open a file first", vim.log.levels.WARN)
    return
  end
  M.pick_pattern(dir, "file dir")
end

function M.search_cwd_custom()
  M.search(vim.fn.getcwd(), "ast-grep (cwd)❯ ")
end

function M.search_file_dir_custom()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or dir == "." then
    vim.notify("No file buffer — open a file first", vim.log.levels.WARN)
    return
  end
  M.search(dir, "ast-grep (file dir)❯ ")
end

return M
