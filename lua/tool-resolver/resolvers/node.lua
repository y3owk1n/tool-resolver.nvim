local M = {}

---@type ToolResolver.ResolverMeta
M.meta = {
	root_markers = { "package.json" },
	bin_subpath = { "node_modules", ".bin" },
}

return M
