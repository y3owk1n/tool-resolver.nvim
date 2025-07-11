local M = {}

M.config = {}

---@type ToolResolver.Config
local defaults = {
	fallbacks = {},
}

--- Setup autocommands
---@return nil
function M.setup_autocmds()
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

--- Setup user commands
---@return nil
function M.setup_usercmds()
	-- Command: :ToolResolverGet biome
	vim.api.nvim_create_user_command("ToolResolverGet", function(opts)
		local tool = opts.args
		local path = vim.api.nvim_buf_get_name(0)
		local resolved =
			require("tool-resolver.tools").get_bin(tool, { path = path })
		vim.notify(("Resolved tool '%s': %s"):format(tool, resolved))
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

	-- Command: :ToolResolverClearCache
	vim.api.nvim_create_user_command("ToolResolverClearCache", function()
		require("tool-resolver.cache").clear()
		vim.notify("Cache cleared")
	end, {})

	-- Command: :ToolResolverGetCache
	vim.api.nvim_create_user_command("ToolResolverGetCache", function()
		local cache = require("tool-resolver.cache").get()
		vim.notify(vim.inspect(cache))
	end, {})
end

--- Setup Time Machine
---@param user_config ToolResolver.Config
---@return nil
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", defaults, user_config or {})

	M.setup_autocmds()
	M.setup_usercmds()
end

return M
