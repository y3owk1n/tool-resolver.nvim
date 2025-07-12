local M = {}

local utils = require("tool-resolver.utils")

---Find the nearest executable binary in node_modules/.bin
---Searches upward from a starting path
---@param tool string Tool name (e.g., "biome")
---@param start_path string Starting path for upward search
---@return string? bin_path The resolved binary path if found
---@return string? root_path The project root where the binary was found
function M.resolve(tool, start_path)
	local dir = vim.fn.fnamemodify(start_path, ":p"):gsub("/+$", "")

	while dir and dir ~= "/" do
		local candidate = utils.join(dir, "node_modules", ".bin", tool)
		if utils.is_executable(candidate) then
			return candidate, dir
		end

		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break -- prevent infinite loop
		end
		dir = parent:gsub("/+$", "")
	end

	return nil, nil
end

return M
