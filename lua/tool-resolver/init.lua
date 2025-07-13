---@module "tool-resolver"

local config = require("tool-resolver.config")
local resolvers = require("tool-resolver.resolvers")

local M = {}

M.setup = config.setup

M.get_bin = resolvers.get_bin

return M
