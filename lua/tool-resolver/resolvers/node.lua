local M = {}

local utils = require("tool-resolver.utils")

---@type ToolResolver.ResolverMeta
M.meta = {
	root_markers = { "package.json" },
	bin_subpath = { "node_modules", ".bin" },
}

---Find an individual binary *given the exact root*
---@param tool string
---@param root string  -- already known project root
---@return string? bin_path
function M.resolve(tool, root)
	local path = utils.join(root, unpack(M.meta.bin_subpath), tool)
	return utils.is_executable(path) and path or nil
end

---Scan the node_modules/.bin directory for binaries
---@param root string Root directory
---@param meta ToolResolver.ResolverMeta
---@return table<string, string> Binary map
function M.scan(root, meta)
	local uv = vim.uv or vim.loop
	local parts = meta.bin_subpath
	local bin_dir = root .. "/" .. table.concat(parts, "/")

	local fs = uv.fs_scandir(bin_dir)
	local map = {}
	if fs then
		while true do
			local name, t = uv.fs_scandir_next(fs)
			if not name then
				break
			end
			if t == "file" or t == "link" then
				map[name] = bin_dir .. "/" .. name
			end
		end
	end
	return map
end

return M
