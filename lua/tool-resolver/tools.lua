local M = {}

---Tracked list of tools
---@type table<string, string>
local tools = {}

local utils = require("tool-resolver.utils")
local cache = require("tool-resolver.cache")
local config = require("tool-resolver.config")

---Add a tool to the tracked list
---@param tool string Tool name to track (e.g. "biome", "eslint")
function M.add(tool)
	utils.add_unique_items(tools, { tool })
end

---Get the list of tracked tools
---@return table<string, string>
function M.get()
	return tools
end

-- Resolving tools for `node_modules`. Mainly used for tools like `biome` that will break when the lsp version is different
-- than the project installed version in `node_modules`. The tool will try to resolve the binary from the current buffer to
-- the node modules available binary, and only fallback to the globally installed version.
---@param tool string Tool name
---@param opts? ToolResolver.GetBinOpts Options (e.g., buffer path)
---@return string Resolved binary path or fallback name
function M.get_bin(tool, opts)
	opts = opts or {}

	-- Determine buffer path (fallback to cwd)
	local buf_path = opts.path or vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		buf_path = vim.fn.getcwd()
	end

	local fallback = (config.config.fallbacks or {})[tool] or tool
	local find_nearest = utils.find_nearest_executable

	-- Try resolving from buffer path
	local bin, root = find_nearest(tool, buf_path)

	-- Fallback to cwd resolution if not found
	if not bin then
		bin, root = find_nearest(tool, vim.fn.getcwd())
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
