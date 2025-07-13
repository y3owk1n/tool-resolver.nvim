local M = {}

local uv = vim.uv or vim.loop

---@type table<string, table<string, string|false>>
local root_cache = {}

---@type table<string, uv.uv_fs_poll_t>
local watchers = {}

local global_cache_key = "__GLOBAL__"

---Return the entire tool→binary map for a given project root.
---@param root? string Absolute project root; `nil` means global scope
---@return table<string, string|false> root_table Map of tool names → absolute executable paths (empty table if never cached)
function M.get_root_table(root)
	return root_cache[root or global_cache_key] or {}
end

---Retrieve the cached absolute path of a tool inside a given project root.
---@param root? string Absolute project root (or nil for global scope)
---@param tool string Tool name (e.g. `"biome"`)
---@return string|nil bin Absolute path if found, `false` if explicitly not found, `nil` if never cached
function M.get_bin(root, tool)
	local t = root_cache[root or global_cache_key]
	return t and t[tool] or nil
end

---Store an entire tool→binary map for a project root.
---@param root? string Absolute project root (or nil for global scope)
---@param tool_map table<string, string|false> Map of tool names → absolute binary paths
function M.set_root(root, tool_map)
	root_cache[root or global_cache_key] = tool_map
end

---Drop the cache for one project root (and stop its watcher).
---@param root? string Absolute project root (or nil for global scope)
function M.clear_root(root)
	root = root or "__GLOBAL__"
	root_cache[root] = nil
	if watchers[root] then
		watchers[root]:stop()
		watchers[root]:close()
		watchers[root] = nil
	end
end

---Start a file-system watcher on `<root>/<subpath…>` so that any
---create/delete inside that directory triggers `clear_root(root)`.
---@param root string Absolute project root
---@param subpath string[] Path segments *relative* to `root` (e.g. `{ "node_modules", ".bin" }`)
function M.watch_root(root, subpath)
	if watchers[root] then
		return
	end
	local bin_dir = root .. "/" .. table.concat(subpath, "/")

	local h = uv.new_fs_poll()
	if not h then
		return
	end

	h:start(bin_dir, 2000, function()
		M.clear_root(root)
	end)
	watchers[root] = h
end

return M
