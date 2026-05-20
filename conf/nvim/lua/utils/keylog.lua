-- Buffered keystroke log for habit analysis (off by default; vim.on_key).
-- Log: ~/.local/state/nvim-keylog.jsonl

local M = {}

M.log_path = vim.fn.stdpath("state") .. "/nvim-keylog.jsonl"
M.enabled = false

local buffer = {}
local handler_id = nil
local flush_timer = nil

local FLUSH_EVERY_KEYS = 64
local FLUSH_INTERVAL_MS = 3000

local function now_iso()
  return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

local function flush()
  if #buffer == 0 then
    return
  end
  local lines = table.concat(buffer, "\n") .. "\n"
  buffer = {}
  local f = io.open(M.log_path, "a")
  if f then
    f:write(lines)
    f:close()
  end
end

local function schedule_flush()
  if flush_timer then
    return
  end
  flush_timer = vim.defer_fn(function()
    flush_timer = nil
    flush()
  end, FLUSH_INTERVAL_MS)
end

local function record(key)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "c" or mode == "t" then
    return
  end

  local keytrans = vim.fn.keytrans(key)
  if keytrans == "" or keytrans:match("^%d+$") then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  local entry = vim.json.encode({
    ts = now_iso(),
    mode = mode,
    key = keytrans,
    ft = vim.bo[bufnr].filetype,
    buf = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]",
  })
  buffer[#buffer + 1] = entry
  if #buffer >= FLUSH_EVERY_KEYS then
    flush()
  else
    schedule_flush()
  end
end

---@param silent? boolean Skip notify (used for auto-start on launch).
function M.enable(silent)
  if M.enabled then
    return
  end
  M.enabled = true
  handler_id = vim.on_key(function(_, key)
    record(key)
  end, handler_id)
  if not silent then
    vim.notify("Keylog ON → " .. M.log_path, vim.log.levels.INFO)
  end
end

function M.disable()
  if not M.enabled then
    return
  end
  vim.on_key(nil, handler_id)
  handler_id = nil
  M.enabled = false
  if flush_timer then
    flush_timer = nil
  end
  flush()
  vim.notify("Keylog OFF", vim.log.levels.INFO)
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

function M.setup()
  vim.api.nvim_create_user_command("NvimKeylogToggle", M.toggle, { desc = "Toggle keystroke log" })
  vim.api.nvim_create_user_command("NvimKeylogEnable", M.enable, { desc = "Start keystroke log" })
  vim.api.nvim_create_user_command("NvimKeylogDisable", M.disable, { desc = "Stop keystroke log and flush" })
  vim.api.nvim_create_user_command("NvimKeylogAnalyze", function()
    vim.system({ "nvim-keylog-analyze" }, { text = true }, function(res)
      if res.code ~= 0 then
        vim.notify("nvim-keylog-analyze failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      vim.notify(res.stdout or "", vim.log.levels.INFO, { title = "Keylog analysis" })
    end)
  end, { desc = "Run nvim-keylog-analyze on log file" })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if M.enabled then
        vim.on_key(nil, handler_id)
        handler_id = nil
        M.enabled = false
        flush()
      end
    end,
  })

  M.enable(true)
end

return M
