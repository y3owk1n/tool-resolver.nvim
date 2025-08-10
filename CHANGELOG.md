# Changelog

## [1.3.3](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.3.2...v1.3.3) (2025-08-10)


### Bug Fixes

* **ci:** move docs to its own workflow ([#33](https://github.com/y3owk1n/tool-resolver.nvim/issues/33)) ([38af0fb](https://github.com/y3owk1n/tool-resolver.nvim/commit/38af0fb121ffc8812052210c13d995bafc168401))

## [1.3.2](https://github.com/y3owk1n/tool-resolver.nvim/compare/v1.3.1...v1.3.2) (2025-07-20)


### Bug Fixes

* **docs:** ensure naming consistency ([#30](https://github.com/y3owk1n/tool-resolver.nvim/issues/30)) ([1c21101](https://github.com/y3owk1n/tool-resolver.nvim/commit/1c2110147dd01fa6ae67a32c8a12eefc4633c689))
* **docs:** remove helptags ([#29](https://github.com/y3owk1n/tool-resolver.nvim/issues/29)) ([569d5cd](https://github.com/y3owk1n/tool-resolver.nvim/commit/569d5cdb1c534bfd99ba32739c08ee4a5b47a86d))
* **docs:** switch from `pandocvim` to `vimcats` for docs generation ([#28](https://github.com/y3owk1n/tool-resolver.nvim/issues/28)) ([24a8806](https://github.com/y3owk1n/tool-resolver.nvim/commit/24a88060b34eeae69ee5223df9b6ebb448cd5c27))
* remove whitespace ([#31](https://github.com/y3owk1n/tool-resolver.nvim/issues/31)) ([0f55cbf](https://github.com/y3owk1n/tool-resolver.nvim/commit/0f55cbfa7329c4bfd3e4457f61fc54aed28b1c79))
* **resolver:** move generic function out from language specific resolver ([#25](https://github.com/y3owk1n/tool-resolver.nvim/issues/25)) ([7cb47c0](https://github.com/y3owk1n/tool-resolver.nvim/commit/7cb47c06fafa0eedf2ad1595f1074d9c9b6c1a3c))
* **resolver:** remove usage of `unpack` and use custom join method ([#27](https://github.com/y3owk1n/tool-resolver.nvim/issues/27)) ([24783e0](https://github.com/y3owk1n/tool-resolver.nvim/commit/24783e05faaa759c5cfad141688ce0ad8b0e7343))

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
