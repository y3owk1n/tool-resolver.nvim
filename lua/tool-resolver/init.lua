---@module "tool-resolver"

---@brief [[
---*tool-resolver.nvim.txt*
---
---Resolve project-local CLI tools in Neovim with monorepo-aware logic.
---@brief ]]

---@toc tool-resolver.nvim.toc

---@mod tool-resolver.nvim.api API

local config = require("tool-resolver.config")
local resolvers = require("tool-resolver.resolvers")

local M = {}

---Entry point to setup the plugin
---@type fun(user_config?: ToolResolver.Config)
M.setup = config.setup

---Resolving tools for specified types. The tool will try to resolve the binary from the current buffer path,
---then from cwd if not found, and finally fallback to the configured fallback or tool name.
---@type fun(tool: string, opts?: ToolResolver.GetBinOpts): string  -- references the signature from resolvers.get_bin
M.get_bin = resolvers.get_bin

return M
