-- Emit dropdown JSON for Raycast script (run via gen-raycast-sg-pattern.sh)

local root = assert(os.getenv("ROOT"), "ROOT env required")
package.path = root .. "/conf/nvim/lua/?.lua;" .. root .. "/conf/nvim/lua/?/init.lua;;"

local patterns = require("ast-grep-patterns").patterns
local items = {}

for i, x in ipairs(patterns) do
  local title = string.format("%s (%s)", x.name, x.lang or "?")
  title = title:gsub("\\", "\\\\"):gsub('"', '\\"')
  items[#items + 1] = string.format('{"title": "%s", "value": "%d"}', title, i)
end

io.write(table.concat(items, ", "))
