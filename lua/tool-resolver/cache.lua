local M = {}

-- Internal binary cache table, do not modify directly
local _cache = {}

---Generate a normalized cache key for a tool with optional root
---@param root? string # Optional project root (or nil for global)
---@param tool string # Tool name (e.g., "eslint", "prettier")
---@return string # Normalized cache key
function M.get_key(root, tool)
	return (root or "__NO_ROOT__") .. ":" .. tool
end

---Get a shallow copy of the entire cache (read-only)
---@return table<string, string> # Copy of internal cache table
function M.get()
	local copy = {}
	for k, v in pairs(_cache) do
		copy[k] = v
	end
	return copy
end

---Get a cached binary path by key
---@param key string # Cache key
---@return string|nil # Cached binary path, or nil if not found
function M.get_by_key(key)
	return _cache[key]
end

---Set a binary path for the given key
---@param key string # Cache key
---@param bin string # Resolved binary path
function M.set(key, bin)
	_cache[key] = bin
end

---Clear the entire binary cache
function M.clear()
	_cache = {}
end

return M
