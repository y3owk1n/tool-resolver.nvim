local M = {}

---Get the list of tracked tools
---@return table<string, ToolResolver.Config.Tools>
function M.get()
	return require("tool-resolver.config").config.tools
end

return M
