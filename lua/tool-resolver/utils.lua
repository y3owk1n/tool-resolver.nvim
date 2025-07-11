local M = {}

local function join(...)
	local args = { ... }
	local result = args[1]:gsub("/+$", "")
	for i = 2, #args do
		local part = args[i]:gsub("^/+", ""):gsub("/+$", "")
		result = result .. "/" .. part
	end
	return vim.fs.normalize(result)
end

---@param path string path to check
---@return boolean
local function is_executable(path)
	return vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1
end

---@param tool string tool name to resolve, e.g. `biome`
---@param start_path string start path to search from
---@return string? path to the tool, or nil if not found
---@return string? root path of the tool, or nil if not found
function M.find_nearest_executable(tool, start_path)
	local dir = vim.fn.fnamemodify(start_path, ":p"):gsub("/+$", "")

	while dir and dir ~= "/" do
		local candidate = join(dir, "node_modules", ".bin", tool)
		if is_executable(candidate) then
			return candidate, dir
		end
		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break
		end -- safety: don't loop forever
		dir = parent:gsub("/+$", "") -- normalize again
	end

	return nil, nil
end

function M.add_unique_items(target_table, items)
	-- Helper function to check if a value exists in the table
	local function contains(table, value)
		for _, v in ipairs(table) do
			if v == value then
				return true
			end
		end
		return false
	end

	-- Add items to the target_table only if they aren't already present
	for _, item in ipairs(items) do
		if not contains(target_table, item) then
			table.insert(target_table, item)
		end
	end
end

return M
