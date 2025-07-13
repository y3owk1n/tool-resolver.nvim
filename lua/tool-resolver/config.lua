local M = {}

local notify = require("tool-resolver.notify")
local tools = require("tool-resolver.tools")
local resolvers = require("tool-resolver.resolvers")

local api = vim.api
local inspect = vim.inspect

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
	api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
		callback = function(args)
			local tools_table = tools.get()
			for tool, registered in pairs(tools_table) do
				if not registered.type then
					notify.warn(
						("Tool '%s' is missing required 'type' field"):format(
							tool
						)
					)
					return
				end

				local meta = resolvers.resolvers[registered.type].meta
				if meta then
					local root = vim.fs.root(args.buf or 0, meta.root_markers)
					if root then
						resolvers.prewarm_root(root, registered.type)
					end
				end
			end
		end,
	})
end

--- Setup user commands for manual control
---@private
local function setup_usercmds()
	api.nvim_create_user_command("ToolResolverGetTools", function()
		local path = api.nvim_buf_get_name(0)

		local tools_table = tools.get()

		local resolved = {}

		for tool, _ in pairs(tools_table) do
			local ok, resolved_tool =
				pcall(resolvers.get_bin, tool, { path = path })
			if ok and resolved_tool then
				resolved[tool] = resolved_tool
			else
				resolved[tool] = tool
			end
		end

		notify.info(("Resolved tools:\n%s"):format(inspect(resolved)))
	end, {})

	api.nvim_create_user_command("ToolResolverGetTool", function(opts)
		local tool = opts.args
		local path = api.nvim_buf_get_name(0)

		local tools_table = tools.get()
		local registered = tools_table[tool]

		if not registered then
			notify.warn(
				("Tool not registered: %s, resolving to the same name"):format(
					tool
				)
			)
			return
		end

		local ok, resolved = pcall(resolvers.get_bin, tool, { path = path })
		if ok and resolved then
			notify.info(("Resolved tool '%s': %s"):format(tool, resolved))
		else
			notify.warn(("Failed to resolve tool '%s'"):format(tool))
		end
	end, {
		nargs = 1,
		complete = function(arg)
			local tools_table = tools.get()
			return vim.iter(vim.tbl_keys(tools_table))
				:filter(function(name)
					return name:sub(1, #arg) == arg
				end)
				:totable()
		end,
	})
end

--- Plugin setup entry point
---@param user_config? ToolResolver.Config
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", defaults, user_config or {})

	setup_autocmds()
	setup_usercmds()
end

return M
