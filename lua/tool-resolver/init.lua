---@module "tool-resolver"

local M = {}

M.setup = require("tool-resolver.config").setup

M.get_bin = require("tool-resolver.resolvers").get_bin

return M
