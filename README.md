# 🧰 tool-resolver.nvim

Resolve project-local CLI tools in Neovim with monorepo-aware logic. Say bye to version mismatches!

<!-- panvimdoc-ignore-start -->

## 💡 Motivation

I ran into constant version mismatch issues when using tools like biome globally — especially in monorepos or older projects that don’t use the latest version. This often resulted in frustrating errors, even when everything seemed properly set up.

At that point, I had two choices:

- 🚧 Upgrade every project to use the latest tool versions (not always ideal or even possible)
- ✅ Resolve the tool binary per project, based on its local installation

So, I built this plugin to make the second option easy and seamless.

While tools like mason.nvim are great, they typically install the latest versions globally — which doesn’t help when you need project-specific versions. **tool-resolver.nvim** fills that gap with fast, reliable, and monorepo-aware resolution of `node_modules/.bin/<tool>` for each buffer.

<!-- panvimdoc-ignore-end -->

## 🚀 Features

- Monorepo-friendly: climbs up directory tree to find local binaries
- Falls back to monorepo root if needed
- Global fallback to system binary if no local match
- Smart per-buffer resolution (works as you switch files)
- Lightweight, dependency-free

> [!NOTE]
> This plugin currently only supports node projects, feel free to contribute for more language resolvers if this plugin interests you.

## 🧠 How It Works

When resolving a tool (e.g. `biome`), this plugin:

1. Starts at the file's directory
2. Traverses upward to find the nearest executable based on configured type, for `node` it will be at `node_modules/.bin/biome`
3. If none is found, tries the same logic from `vim.fn.getcwd()` (monorepo root fallback)
4. If still not found, falls back to the fallbacks tool name specified in configuration or the global tool name (e.g. "biome")

<!-- panvimdoc-ignore-start -->

## 📕 Contents

- [Installation](#-installation)
- [Configuration](#%EF%B8%8F-configuration)
- [API](#-api)
- [Quick Start](#-quick-start)
- [Contributing](#-contributing)

<!-- panvimdoc-ignore-end -->

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
-- tool-resolver.lua
return {
 "y3owk1n/tool-resolver.nvim",
 version = "*", -- remove this if you want to use the `main` branch
 opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 }
}
```

If you are using other package managers you need to call `setup`:

```lua
require("tool-resolver").setup({
  -- your configuration
})
```

### Requirements

- Neovim 0.11+ with Lua support

## ⚙️ Configuration

The default configurations are as below.

### Default Options

```lua
---@type ToolResolver.Config
{
 tools = {},
}
```

### Type Definitions

```lua
---@class ToolResolver.Config
---@field tools table<string, ToolResolver.Config.Tools> tools with type and fallback

---@class ToolResolver.Config.Tools
---@field type ToolResolver.ResolverType
---@field fallback? string fallback binary name, if not specified then use the key.
```

## 🚀 Quick Start

See the example below for how to configure **tool-resolver.nvim**.

```lua
{
 "y3owk1n/tool-resolver.nvim",
 cmd = {
  "ToolResolverGetTool",
  "ToolResolverGetTools",
 },
 ---@type ToolResolver.Config
 opts = {
   -- register the tools that you want to use here
   tools = {
    biome = {
     type = "node", -- type is required, and only "node" is supported for now
    },
    prettier = {
     type = "node", -- type is required, and only "node" is supported for now
     fallback = "prettierd", -- specify a fallback binary name will resolve to this, else will fallback to the key `prettier`
    },
   },
 },
},
```

You can then use the following to resolve a tool anywhere. For example in my biome LSP config:

```lua
local tr = require("tool-resolver")

---@type vim.lsp.Config
return {
 cmd = { tr.get_bin("biome"), "lsp-proxy" }, -- instead of just getting it from the global bin, use tool-resolver for it.
 -- the rest of your lsp configurations
}
```

## 🌎 API

**tool-resolver.nvim** provides the following api functions that you can use for different things:

### Get the local or global tool bin

This is the most important function in **tool-resolver.nvim**. It will try to resolve the tool bin from the current buffer to the node modules available binary, and only fallback to the globally installed version.

```lua
---@class ToolResolver.GetBinOpts
---@field path? string start search path (default: current buffer)

---@param tool string
---@param opts? ToolResolver.GetBinOpts
---@return string
require("tool-resolver").get_bin(tool, opts)
```

<!-- panvimdoc-ignore-start -->

## 🤝 Contributing

Read the documentation carefully before submitting any issue.

Feature and pull requests are welcome.

<!-- panvimdoc-ignore-end -->
