local M = {}

local resolvers = {
	node = require("tool-resolver.resolvers.node"),
}

local tools = require("tool-resolver.tools")
local cache = require("tool-resolver.cache")

-- Resolving tools for specified types. The tool will try to resolve the binary from the current buffer to
-- based on the provided type with an available binary, and only fallback to the globally installed version.
---@param tool string Tool name
---@param opts? ToolResolver.GetBinOpts Options (e.g., buffer path)
---@return string Resolved binary path or fallback name
function M.get_bin(tool, opts)
	local tools_list = tools.get()

	local registered = tools_list[tool]

	if not registered then
		vim.notify(
			"[ToolResolver]: Tool not registered: "
				.. tool
				.. ", resolving to the same name",
			vim.log.levels.WARN
		)
		return tool
	end

	if not registered.type then
		vim.notify(
			"[ToolResolver]: Tool not registered: "
				.. tool
				.. ", no type specified",
			vim.log.levels.WARN
		)
		return tool
	end

	local resolver = resolvers[registered.type]

	if not resolver then
		vim.notify(
			"[ToolResolver] No resolver for type: " .. registered.type,
			vim.log.levels.WARN
		)
		return tool
	end

	opts = opts or {}

	-- Determine buffer path (fallback to cwd)
	local buf_path = opts.path or vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		buf_path = vim.fn.getcwd()
	end

	local fallback = registered.fallback or tool

	-- Try resolving from buffer path
	local bin, root = resolver.find_nearest_executable(tool, buf_path)

	-- Fallback to cwd resolution if not found
	if not bin then
		bin, root = resolver.find_nearest_executable(tool, vim.fn.getcwd())
	end

	local key = cache.get_key(root, tool)
	local cachedTool = cache.get_by_key(key)

	if cachedTool then
		return cachedTool
	end

	-- Cache and return resolved path
	if bin then
		cache.set(key, bin)
		return bin
	end

	-- Fallback path (e.g. global `biome`)
	cache.set(key, fallback)
	return fallback
end

return M
