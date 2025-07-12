---@class ToolResolver.Config
---@field tools table<string, ToolResolver.Config.Tools> tools with type and fallback

---@class ToolResolver.Config.Tools
---@field type ToolResolver.ResolverType
---@field fallback? string fallback binary name, if not specified then use the key.

---@class ToolResolver.GetBinOpts
---@field path? string start search path (default: current buffer)

---@alias ToolResolver.ResolverType "node" -- add more in future
