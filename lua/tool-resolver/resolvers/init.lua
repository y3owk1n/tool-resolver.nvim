local M = {}

M.resolvers = {
	node = require("tool-resolver.resolvers.node"),
}

local tools = require("tool-resolver.tools")
local cache = require("tool-resolver.cache")
local notify = require("tool-resolver.notify")

local dummy_tool_key = "____ANY_TOOL"

---Pre-warm the cache for a root directory
---@param root string Root directory
---@param resolver_type ToolResolver.ResolverType Resolver type
function M.prewarm_root(root, resolver_type)
	local resolver = M.resolvers[resolver_type]
	local meta = resolver.meta
	if not meta then
		return
	end

	if cache.get_bin(root, dummy_tool_key) ~= nil then
		return
	end

	vim.defer_fn(function()
		local tool_map = resolver.scan(root, meta)
		cache.set_root(root, tool_map)
	end, 0)
end

---Resolving tools for specified types. The tool will try to resolve the binary from the current buffer path,
---then from cwd if not found, and finally fallback to the configured fallback or tool name.
---@param tool string Tool name
---@param opts? ToolResolver.GetBinOpts Options (e.g., buffer path)
---@return string Resolved binary path or fallback name
function M.get_bin(tool, opts)
	opts = opts or {}

	local buf_path = opts.path or vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		buf_path = vim.fn.getcwd()
	end

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

	local resolver = M.resolvers[registered.type]
	if not resolver then
		notify.warn(("No resolver for type '%s'"):format(registered.type))
		return tool
	end

	local root_markers = resolver.meta.root_markers

	-- If in monorepo, try to get the packages root first
	local root = vim.fs.root(buf_path, root_markers)

	local bin = cache.get_bin(root, tool)

	if not bin then
		-- Try `.git` as project root or resolve to cwd
		root = vim.fs.root(buf_path, ".git") or vim.fn.getcwd()
		bin = cache.get_bin(root, tool)

		if bin then
			return bin == false and nil or bin
		end
	else
		return bin == false and nil or bin
	end

	bin = resolver.resolve(tool, root)

	local result = bin or (registered.fallback or tool)

	local meta = resolver.meta
	local tool_map = cache.get_root_table(root) or {}

	tool_map[tool] = result -- only store actual paths

	cache.set_root(root, tool_map)
	cache.watch_root(root, meta.bin_subpath)

	return result
end

return M
