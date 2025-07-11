local M = {}

---Join multiple path segments safely and normalize the result
---@param ... string Path parts to join
---@return string Normalized absolute path
local function join(...)
	local args = { ... }
	local result = args[1]:gsub("/+$", "")

	for i = 2, #args do
		local part = args[i]:gsub("^/+", ""):gsub("/+$", "")
		result = result .. "/" .. part
	end

	return vim.fs.normalize(result)
end

---Check if the given path is both readable and executable
---@param path string path to check
---@return boolean
local function is_executable(path)
	return vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1
end

---Find the nearest executable binary in node_modules/.bin
---Searches upward from a starting path
---@param tool string Tool name (e.g., "biome")
---@param start_path string Starting path for upward search
---@return string? bin_path The resolved binary path if found
---@return string? root_path The project root where the binary was found
function M.find_nearest_executable(tool, start_path)
	local dir = vim.fn.fnamemodify(start_path, ":p"):gsub("/+$", "")

	while dir and dir ~= "/" do
		local candidate = join(dir, "node_modules", ".bin", tool)
		if is_executable(candidate) then
			return candidate, dir
		end

		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break -- prevent infinite loop
		end
		dir = parent:gsub("/+$", "")
	end

	return nil, nil
end

---Add unique items to a list-like table
---@param target_table string[] Table to append to
---@param items string[] Items to add uniquely
function M.add_unique_items(target_table, items)
	local function contains(table, value)
		for _, v in ipairs(table) do
			if v == value then
				return true
			end
		end
		return false
	end

	for _, item in ipairs(items) do
		if not contains(target_table, item) then
			table.insert(target_table, item)
		end
	end
end

return M
