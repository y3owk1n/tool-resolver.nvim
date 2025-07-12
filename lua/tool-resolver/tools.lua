local M = {}

local config = require("tool-resolver.config")

---Get the list of tracked tools
---@return table<string, ToolResolver.Config.Tools>
function M.get()
	return config.config.tools
end

return M
