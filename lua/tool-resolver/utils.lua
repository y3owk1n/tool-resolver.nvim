local M = {}

---Join multiple path segments safely and normalize the result
---@param ... string Path parts to join
---@return string Normalized absolute path
function M.join(...)
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
function M.is_executable(path)
	return vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1
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

return M
