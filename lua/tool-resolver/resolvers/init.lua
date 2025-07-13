local M = {}

local resolvers = {
	node = require("tool-resolver.resolvers.node"),
}

local tools = require("tool-resolver.tools")
local cache = require("tool-resolver.cache")
local notify = require("tool-resolver.notify")

---Resolving tools for specified types. The tool will try to resolve the binary from the current buffer path,
---then from cwd if not found, and finally fallback to the configured fallback or tool name.
---@param tool string Tool name
---@param opts? ToolResolver.GetBinOpts Options (e.g., buffer path)
---@return string Resolved binary path or fallback name
function M.get_bin(tool, opts)
	local tools_table = tools.get()

	local registered = tools_table[tool]

	if not registered then
		notify.warn(
			("Tool not registered '%s', resolving to the same name"):format(
				tool
			)
		)
		return tool
	end

	if not registered.type then
		notify.warn(("Tool '%s' is missing required 'type' field"):format(tool))
		return tool
	end

	local resolver = resolvers[registered.type]

	if not resolver then
		notify.warn(("No resolver for type '%s'"):format(registered.type))
		return tool
	end

	opts = opts or {}

	-- Determine buffer path (fallback to cwd)
	local buf_path = opts.path or vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		buf_path = vim.fn.getcwd()
	end

	local fallback = registered.fallback or tool

	local key = cache.get_key(nil, tool)
	local cachedTool = cache.get_by_key(key)

	if cachedTool then
		return cachedTool
	end

	-- Try resolving from buffer path
	local bin, root = resolver.resolve(tool, buf_path)

	-- Fallback to cwd resolution if not found
	if not bin then
		bin, root = resolver.resolve(tool, vim.fn.getcwd())
	end

	if root then
		key = cache.get_key(root, tool)
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
