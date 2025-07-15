local M = {}

local fn = vim.fn

---Join multiple path segments safely and normalize the result
---@param parts string[] Path segments
---@return string Normalized absolute path
function M.join(parts)
	local result = parts[1]:gsub("/+$", "")

	for i = 2, #parts do
		local part = parts[i]:gsub("^/+", ""):gsub("/+$", "")
		result = result .. "/" .. part
	end

	return vim.fs.normalize(result)
end

---Check if the given path is both readable and executable
---@param path string path to check
---@return boolean
function M.is_executable(path)
	return fn.filereadable(path) == 1 and fn.executable(path) == 1
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

---Check if a value is in a list-like table
---@param list table<string, string> List to check
---@param value string Value to check
function M.contains(list, value)
	for _, v in ipairs(list) do
		if v == value then
			return true
		end
	end
	return false
end

---Check whether the given tool exists *inside the supplied root*
---@param tool string
---@param root string already determined project root
---@param bin_subpath string[] bin sub-path to check
---@return string|nil is_executable absolute path if executable, nil otherwise
function M.exists_in_root(tool, root, bin_subpath)
	local path_parts = M.create_path_parts(tool, root, bin_subpath)

	local path = M.join(path_parts)

	return M.is_executable(path) and path or nil
end

---Create a path from a tool name, root, and bin_subpath
---@param tool string
---@param root string
---@param bin_subpath string[]
---@return string[] path_parts
function M.create_path_parts(tool, root, bin_subpath)
	local path_parts = { root }

	for _, segment in ipairs(bin_subpath) do
		table.insert(path_parts, segment)
	end

	table.insert(path_parts, tool)

	return path_parts
end

return M
