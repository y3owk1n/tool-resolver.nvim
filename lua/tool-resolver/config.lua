local M = {}

local notify = require("tool-resolver.notify")

---User-provided config, merged with defaults
---@type ToolResolver.Config
M.config = {}

---@type ToolResolver.Config
local defaults = {
	tools = {},
}

--- Setup autocmds to automatically resolve tools
---@private
local function setup_autocmds()
	vim.api.nvim_create_autocmd("DirChanged", {
		callback = function()
			require("tool-resolver.cache").clear()
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(args)
			local path = vim.api.nvim_buf_get_name(args.buf)

			local tools_table = require("tool-resolver.tools").get()

			for _, tool in ipairs(tools_table) do
				require("tool-resolver").get_bin(tool, { path = path })
			end
		end,
	})
end

--- Setup user commands for manual control
---@private
local function setup_usercmds()
	vim.api.nvim_create_user_command("ToolResolverGetTools", function()
		local path = vim.api.nvim_buf_get_name(0)

		local tools_table = require("tool-resolver.tools").get()

		local resolved = {}

		for tool, _ in pairs(tools_table) do
			local ok, resolved_tool =
				pcall(require("tool-resolver").get_bin, tool, { path = path })
			if ok and resolved_tool then
				resolved[tool] = resolved_tool
			else
				resolved[tool] = tool
			end
		end

		notify.info(("Resolved tools:\n%s"):format(vim.inspect(resolved)))
	end, {})

	vim.api.nvim_create_user_command("ToolResolverGetTool", function(opts)
		local tool = opts.args
		local path = vim.api.nvim_buf_get_name(0)

		local tools_table = require("tool-resolver.tools").get()
		local registered = tools_table[tool]

		if not registered then
			notify.warn(
				("Tool not registered: %s, resolving to the same name"):format(
					tool
				)
			)
			return
		end

		local ok, resolved =
			pcall(require("tool-resolver").get_bin, tool, { path = path })
		if ok and resolved then
			notify.info(("Resolved tool '%s': %s"):format(tool, resolved))
		else
			notify.warn(("Failed to resolve tool '%s'"):format(tool))
		end
	end, {
		nargs = 1,
		complete = function(arg)
			local tools = require("tool-resolver.tools").get()
			return vim.iter(vim.tbl_keys(tools))
				:filter(function(name)
					return name:sub(1, #arg) == arg
				end)
				:totable()
		end,
	})

	vim.api.nvim_create_user_command("ToolResolverClearCache", function()
		require("tool-resolver.cache").clear()
		notify.info("Tool resolver cache cleared")
	end, {})

	vim.api.nvim_create_user_command("ToolResolverGetCache", function()
		local cache = require("tool-resolver.cache").get()
		notify.info(("Cached data:\n%s"):format(vim.inspect(cache)))
	end, {})
end

--- Plugin setup entry point
---@param user_config? ToolResolver.Config
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", defaults, user_config or {})

	setup_autocmds()
	setup_usercmds()
end

return M
