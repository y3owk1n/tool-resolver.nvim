# Changelog

## [1.3.1](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.3.0...v1.3.1) (2025-07-14)


### Bug Fixes

* **resolver:** better support for monorepo bin detection ([#23](https://github.com/y3owk1n/tool-resolver.nvim/issues/23)) ([5c3d517](https://github.com/y3owk1n/tool-resolver.nvim/commit/5c3d517118e4038fcff9c08de486b05f73dac673))

## [1.3.0](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.2.0...v1.3.0) (2025-07-13)


### Features

* **cache:** switch to per-root bulk cache and fs watcher ([#22](https://github.com/y3owk1n/tool-resolver.nvim/issues/22)) ([96ad555](https://github.com/y3owk1n/tool-resolver.nvim/commit/96ad555d05733b3cfff01cb9b41f878e3938975e))


### Performance Improvements

* cache imports whenever possible ([#20](https://github.com/y3owk1n/tool-resolver.nvim/issues/20)) ([c3327c7](https://github.com/y3owk1n/tool-resolver.nvim/commit/c3327c75c1d41bae3dac7cc4aabc0e1734626a3d))

## [1.2.0](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.1.1...v1.2.0) (2025-07-13)


### Features

* add `ToolResolverGetTools` command & rename `ToolResolverGet` -&gt; `ToolResolverGetTool` ([#16](https://github.com/y3owk1n/tool-resolver.nvim/issues/16)) ([170404d](https://github.com/y3owk1n/tool-resolver.nvim/commit/170404de5661dddde69d5275c557dbe21a1fdf6a))

## [1.1.1](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.1.0...v1.1.1) (2025-07-12)


### Bug Fixes

* force release ([#14](https://github.com/y3owk1n/tool-resolver.nvim/issues/14)) ([499c372](https://github.com/y3owk1n/tool-resolver.nvim/commit/499c3729a86bcfab18c4916b19901f82e248fbc0))

## [1.1.0](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.0.1...v1.1.0) (2025-07-12)


### Features

* remove `tools.add` API and setup the tools automatically on setup ([#8](https://github.com/y3owk1n/tool-resolver.nvim/issues/8)) ([a032aa6](https://github.com/y3owk1n/tool-resolver.nvim/commit/a032aa6c39b4c89bbfa1cbe5098ccb9744076b99))


### Bug Fixes

* prefix `vim.notify` with `[ToolResolver]: ` ([#11](https://github.com/y3owk1n/tool-resolver.nvim/issues/11)) ([b02581e](https://github.com/y3owk1n/tool-resolver.nvim/commit/b02581e032114f2e875180677d71185433a5c726))
* **tools:** check if the requested tools is registered, if not just notify and resolve the same name ([#10](https://github.com/y3owk1n/tool-resolver.nvim/issues/10)) ([526f459](https://github.com/y3owk1n/tool-resolver.nvim/commit/526f459b4013a70dc8181f5c4350dc3be1a8ad29))

## [1.0.1](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.0.0...v1.0.1) (2025-07-11)


### Bug Fixes

* add more annotations for maintainability ([#5](https://github.com/y3owk1n/tool-resolver.nvim/issues/5)) ([72ca302](https://github.com/y3owk1n/tool-resolver.nvim/commit/72ca3028c532d1e8cef445baf3c1feebdc5ec9a7))

## 1.0.0 (2025-07-11)


### Features

* try release ([#2](https://github.com/y3owk1n/tool-resolver.nvim/issues/2)) ([484e52a](https://github.com/y3owk1n/tool-resolver.nvim/commit/484e52ad7c76ab9fa5b74d92a04779b82edd3048))


### Bug Fixes

* **release:** add issues write permission ([#4](https://github.com/y3owk1n/tool-resolver.nvim/issues/4)) ([137fd47](https://github.com/y3owk1n/tool-resolver.nvim/commit/137fd4731ef5fe33924bef706e3d0ea04941389d))
