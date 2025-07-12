local M = {}

---User-provided config, merged with defaults
---@type ToolResolver.Config
M.config = {}

---@type ToolResolver.Config
local defaults = {
	fallbacks = {},
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

			local tools = require("tool-resolver.tools").get()

			for _, tool in ipairs(tools) do
				require("tool-resolver.tools").get_bin(tool, { path = path })
			end
		end,
	})
end

--- Setup user commands for manual control
---@private
local function setup_usercmds()
	vim.api.nvim_create_user_command("ToolResolverGet", function(opts)
		local tool = opts.args
		local path = vim.api.nvim_buf_get_name(0)

		local ok, resolved =
			pcall(require("tool-resolver.tools").get_bin, tool, { path = path })
		if ok and resolved then
			vim.notify(
				("[ToolResolver]: Resolved tool '%s': %s"):format(
					tool,
					resolved
				),
				vim.log.levels.INFO
			)
		else
			vim.notify(
				("[ToolResolver]: Failed to resolve tool '%s'"):format(tool),
				vim.log.levels.WARN
			)
		end
	end, {
		nargs = 1,
		complete = function(arg)
			return vim.iter(require("tool-resolver.tools").get())
				:map(function(tool)
					return tool
				end)
				:filter(function(tool)
					return tool:sub(1, #arg) == arg
				end)
				:totable()
		end,
	})

	vim.api.nvim_create_user_command("ToolResolverClearCache", function()
		require("tool-resolver.cache").clear()
		vim.notify(
			"[ToolResolver]: Tool resolver cache cleared",
			vim.log.levels.INFO
		)
	end, {})

	vim.api.nvim_create_user_command("ToolResolverGetCache", function()
		local cache = require("tool-resolver.cache").get()
		vim.notify(
			"[ToolResolver]: Cached data:\n" .. vim.inspect(cache),
			vim.log.levels.INFO
		)
	end, {})
end

--- Plugin setup entry point
---@param user_config? ToolResolver.Config
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", defaults, user_config or {})

	setup_autocmds()
	setup_usercmds()

	require("tool-resolver.tools").setup(M.config.fallbacks)
end

return M
