---@mod tool-resolver.types Types
---

local M = {}

---Config
---@class ToolResolver.Config
---@field tools table<string, ToolResolver.Config.Tools> tools with type and fallback

---Config Tools
---@class ToolResolver.Config.Tools
---@field type ToolResolver.ResolverType
---@field fallback? string fallback binary name, if not specified then use the key.

---`get_bin` options
---@class ToolResolver.GetBinOpts
---@field path? string start search path (default: current buffer)

---Resolver types
---@alias ToolResolver.ResolverType
---| '"node"' # node-based resolver (e.g. using node_modules)

---Resolver metadata
---@class ToolResolver.ResolverMeta
---@field root_markers string[] root_markers
---@field bin_subpath string[] bin_subpath

return M
