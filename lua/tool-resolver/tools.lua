local M = {}

local tools = {}

-- Add a tool to the list of tools context
---@param tool string tool name to add, e.g. `biome`
function M.add(tool)
	require("tool-resolver.utils").add_unique_items(tools, { tool })
end

-- Get the list of tools
function M.get()
	return tools
end

-- Resolving tools for `node_modules`. Mainly used for tools like `biome` that will break when the lsp version is different
-- than the project installed version in `node_modules`. The tool will try to resolve the binary from the current buffer to
-- the node modules available binary, and only fallback to the globally installed version.
---@param tool string
---@param opts? ToolResolver.GetBinOpts
---@return string
function M.get_bin(tool, opts)
	opts = opts or {}

	-- Get buffer path (default to current buffer)
	local buf_path = opts.path or vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		buf_path = vim.fn.getcwd()
	end

	local fallbacks = require("tool-resolver.config").config.fallbacks or {}

	local fallback = fallbacks[tool]

	if not fallback then
		fallback = tool
	end

	local find_nearest_executable =
		require("tool-resolver.utils").find_nearest_executable

	-- Try from buffer path
	local bin, root = find_nearest_executable(tool, buf_path)

	-- Try from CWD if not found
	if not bin then
		bin, root = find_nearest_executable(tool, vim.fn.getcwd())
	end

	local cache_key = require("tool-resolver.cache").get_key(root, tool)

	local cache = require("tool-resolver.cache").get_by_key(cache_key)

	if cache then
		return cache
	end

	local set_cache = require("tool-resolver.cache").set
	-- Cache result
	if bin then
		set_cache(cache_key, bin)
		return bin
	end

	set_cache(cache_key, fallback)
	return fallback
end

return M
