local M = {}

local PREFIX = "[ToolResolver]: "

---@param msg string
---@param level number
local function notify(msg, level)
	vim.notify(PREFIX .. msg, level)
end

---@param msg string
function M.warn(msg)
	notify(msg, vim.log.levels.WARN)
end

---@param msg string
function M.info(msg)
	notify(msg, vim.log.levels.INFO)
end

---@param msg string
function M.error(msg)
	notify(msg, vim.log.levels.ERROR)
end

---@param msg string
function M.debug(msg)
	notify(msg, vim.log.levels.DEBUG)
end

return M
