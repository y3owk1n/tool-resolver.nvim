local M = {}

local cache = {}

---@param root? string
---@param tool string
---@return string
function M.get_key(root, tool)
	return (root or "__NO_ROOT__") .. ":" .. tool
end

function M.get()
	return cache
end

---@param key string
---@return string?
function M.get_by_key(key)
	return cache[key]
end

---@param key string
---@param bin string
function M.set(key, bin)
	cache[key] = bin
end

function M.clear()
	cache = {}
end

return M
