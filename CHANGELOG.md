# Changelog

## [4.2.0](https://github.com/snelling-a/nvim/compare/v4.1.0...v4.2.0) (2023-05-24)


### Features

* **keys:** make hard mode conditional ([e73f6fb](https://github.com/snelling-a/nvim/commit/e73f6fbe193b6b3bd66d8760ebfa226f799c36d2))
* **ui:** guicursor ([a9fb4c8](https://github.com/snelling-a/nvim/commit/a9fb4c83b9c6a60306b401aa491525609b321770))


### Miscellaneous

* update plugins ([ba7486a](https://github.com/snelling-a/nvim/commit/ba7486a2b1e8aa3c021fcbd77ed7cf9a525bdbcc))

## [4.1.0](https://github.com/snelling-a/nvim/compare/v4.0.0...v4.1.0) (2023-05-24)


### Features

* **lsp:** use TSComment highlight for signature hint ([d82fb0b](https://github.com/snelling-a/nvim/commit/d82fb0be1e2b226c05370ca784cab7cf110f4590))
* **session:** add user command to load session ([45a1855](https://github.com/snelling-a/nvim/commit/45a1855f4f11cf5481c8f5945003d71b329bb654))
* **ui:** override nvim-web-devicons for UNLICENSE ([5e52f92](https://github.com/snelling-a/nvim/commit/5e52f921a0214eca57eeed9102ec0e23e7108e86))


### Bug Fixes

* filetype property should be ft ([89b4247](https://github.com/snelling-a/nvim/commit/89b42473554a12c466c24a44c592bf589a18e5b4))
* **ui:** adjust dressing/nui settings ([b88460f](https://github.com/snelling-a/nvim/commit/b88460fdb5996d044a094e5d285ce1addca6ac3b))
* **ui:** fix toggle ui opts ([39ff537](https://github.com/snelling-a/nvim/commit/39ff537d62f52efc1069d07299da53d8018e38a5))


### Miscellaneous

* license ([0cd6312](https://github.com/snelling-a/nvim/commit/0cd6312a2aaeae9493124e953b9bd4b35ea20872))
* **spell:** update cspell.json ([2044aeb](https://github.com/snelling-a/nvim/commit/2044aeb61dc34cca23bef9083cff200bf73b14b5))

## [4.0.0](https://github.com/snelling-a/nvim/compare/v3.11.0...v4.0.0) (2023-05-24)


### ⚠ BREAKING CHANGES

* **ui:** ui options are off by default

### Features

* **ui:** statusbar ([d60e321](https://github.com/snelling-a/nvim/commit/d60e321eae3ed5dbe6c72c95a084dbeb4fa8990f))


### Bug Fixes

* **fzf:** fix typo ([9b97b95](https://github.com/snelling-a/nvim/commit/9b97b950b0cdcf6a4a1995a74e915b1545dfbd96))

## [3.11.0](https://github.com/snelling-a/nvim/compare/v3.10.0...v3.11.0) (2023-05-23)


### Features

* import cost ([0fa7ce9](https://github.com/snelling-a/nvim/commit/0fa7ce9b75334ca334c5b1e7ba5e1950d6a77846))


### Miscellaneous

* **spell:** update cspell.json ([dc2bb3d](https://github.com/snelling-a/nvim/commit/dc2bb3d777fcb7a6fd911ca9581ab8d5bc5d375b))

## [3.10.0](https://github.com/snelling-a/nvim/compare/v3.9.0...v3.10.0) (2023-05-22)


### Features

* **keys:** add missing descriptions ([580bfb7](https://github.com/snelling-a/nvim/commit/580bfb78586668592a625cae81731f7e7c156c83))
* **ui:** inline inlay hints ([76bec3b](https://github.com/snelling-a/nvim/commit/76bec3bb9159ef79ea733bec0a472bc3e162c864))


### Bug Fixes

* **flit:** unmap commonly used keymaps ([08390c9](https://github.com/snelling-a/nvim/commit/08390c94a4ca39d325b98a02007af67209b8eaf8))
* **indentscope:** consistency ([3b3bda7](https://github.com/snelling-a/nvim/commit/3b3bda7e7e6e0388ef4fddc599d0b4c5eee554fd))
* **ui:** indent blankline ([215e842](https://github.com/snelling-a/nvim/commit/215e8426e5851f712eb8db8a45f76cc2006520d9))


### Miscellaneous

* **plugin:** update plugins ([d8e57b6](https://github.com/snelling-a/nvim/commit/d8e57b6ec4610dbd2bb9053814366b0f518f0ca3))

## [3.9.0](https://github.com/snelling-a/nvim/compare/v3.8.0...v3.9.0) (2023-05-21)


### Features

* copy path options from neo-tree ([d6147dc](https://github.com/snelling-a/nvim/commit/d6147dc2a207e6fca817bee9b7ab0f043740df44))
* has ([49eb628](https://github.com/snelling-a/nvim/commit/49eb6283a07091a396801cfee9feef722db4f3ac))
* **keys:** easy indent ([6b077a2](https://github.com/snelling-a/nvim/commit/6b077a27e8bdf388cc368973be296ec9a9ac5b0f))
* **lsp:** codeLens ([690652c](https://github.com/snelling-a/nvim/commit/690652c917d53f642f50ed5379989c4bdabe9ab9))
* **lsp:** inlay hints ([8025026](https://github.com/snelling-a/nvim/commit/8025026fbb8d806102d2dca5d0178fadb47042a6))
* neo-tree nesting rules ([a4cd2c9](https://github.com/snelling-a/nvim/commit/a4cd2c99111b2affbebd2d58ff461a708a173ba6))
* **ui:** icons ([7c37f3a](https://github.com/snelling-a/nvim/commit/7c37f3acd0447c1f68c569139064dbafbd01abbd))


### Bug Fixes

* add pr to list of no_format filetypes ([7a012cc](https://github.com/snelling-a/nvim/commit/7a012cc9095832b6657869fdcddf2ae403b8f3ec))
* delete repeated keybinding ([c26aca5](https://github.com/snelling-a/nvim/commit/c26aca597adefbc96abea802187636ca2f592aae))
* don't use treesitter for indent-blankline ([2881f5d](https://github.com/snelling-a/nvim/commit/2881f5d447a0da2ba769621a298f6044e7c8c6e6))
* **fzf:** delete use of custom git log ([d7a09c9](https://github.com/snelling-a/nvim/commit/d7a09c94c927babc04e94013a90baf1d40b17673))
* **lsp:** remove runtime from lua_ls ([43be29c](https://github.com/snelling-a/nvim/commit/43be29c8daad33059a41ceffdfd06da790857d37))
* remove executable mode ([fb55d5f](https://github.com/snelling-a/nvim/commit/fb55d5f0ac58a611f9527ebebf11ead6b54f35bc))
* remove no filetype from no_format ([47a61c1](https://github.com/snelling-a/nvim/commit/47a61c1a4d7ff33b16dc906f614c47e84795373e))


### Miscellaneous

* **plugin:** update packages ([e72225a](https://github.com/snelling-a/nvim/commit/e72225ab01de1f2ecb9f3cf56c6e98befdb901a2))
* **spell:** update cspell.json ([840b46f](https://github.com/snelling-a/nvim/commit/840b46f1f01421e6acafc6fb4f15a5d44a8742bc))

## [3.8.0](https://github.com/snelling-a/nvim/compare/v3.7.0...v3.8.0) (2023-05-18)


### Features

* **alpha:** add help option ([75c52fc](https://github.com/snelling-a/nvim/commit/75c52fca3767f497d78538787bd6d2085c917bdf))
* **fzf:** use last used commands ([4ec709a](https://github.com/snelling-a/nvim/commit/4ec709a305b9b9c5f9bcc13cc43d6d09da4745f0))
* **git:** gh.nvim ([029b15e](https://github.com/snelling-a/nvim/commit/029b15e7533a166c28120ce4d5265df80b288bea))
* **git:** gh.nvim ([2839640](https://github.com/snelling-a/nvim/commit/283964029196ec4caaa5127e06dbf5d962ce31f8))
* **plugin:** vim-unimpaired ([a4d13ae](https://github.com/snelling-a/nvim/commit/a4d13aee6e7d7558662d76b305f940645ae51ea6))
* **plugin:** vim-unimpaired ([2f118aa](https://github.com/snelling-a/nvim/commit/2f118aac00b6c7854fccabae7f508ec92d62c8c5))
* **ui:** indentscope ([b52c868](https://github.com/snelling-a/nvim/commit/b52c86841a44e4164432462e07ce5d2eea6427b7))
* use notify as backup if noice doesn't load ([5fdb5cd](https://github.com/snelling-a/nvim/commit/5fdb5cde91432caeb8f2aa60891c1246ee22312a))
* vale diagnostics ([bc3cde3](https://github.com/snelling-a/nvim/commit/bc3cde38bac6ed3b9b5510b3d1ec6c087d247675))


### Bug Fixes

* **alpha:** don't show dashboard in browser ([d9c96d7](https://github.com/snelling-a/nvim/commit/d9c96d76e053a6a8f2477304a0963bb1484a4476))
* **fzf:** move diagnostics to root of opts ([757a456](https://github.com/snelling-a/nvim/commit/757a456ff13645176b1dcd38f558c4ae9073ccf8))
* **keymap:** delete unnecessary keymaps ([42de4b8](https://github.com/snelling-a/nvim/commit/42de4b816245960776852c33ffb08d80a3748ac2))
* **lsp:** disable noice hadling lsp signature ([9f4cf5b](https://github.com/snelling-a/nvim/commit/9f4cf5b02bf00139f7ad2db251f7af68723f8a53))
* **lsp:** use fzf-lua code_action ([1bab365](https://github.com/snelling-a/nvim/commit/1bab3655ca32538662d2154c0157e7a64cc5ef04))


### Miscellaneous

* **docs:** update README.md ([e52bcdf](https://github.com/snelling-a/nvim/commit/e52bcdf51243238de5f084f9c79b57550cb5aef2))
* **plugins:** update packages ([815df14](https://github.com/snelling-a/nvim/commit/815df145c1e6e8f53bf46fb37a6a57b5cd2ccd20))
* **spell:** update cspell.json ([116a7b8](https://github.com/snelling-a/nvim/commit/116a7b88c2f4d32ee60f4a985d0f3d1dc34bdfa4))

## [3.7.0](https://github.com/snelling-a/nvim/compare/v3.6.0...v3.7.0) (2023-05-17)


### Features

* improve autocmds ([3413151](https://github.com/snelling-a/nvim/commit/34131519d1f8644c0e9fc5f911bdab4fe3001452))
* **lsp:** improved capabilities ([de86b41](https://github.com/snelling-a/nvim/commit/de86b41f418970d0ed909346aae921666ccc7d08))
* **plugin:** spectre ([3ba3ee9](https://github.com/snelling-a/nvim/commit/3ba3ee930c3a9b818be57a2aae68025cdc7d97a2))
* use dressing for imput/ui select ([3adbd43](https://github.com/snelling-a/nvim/commit/3adbd4302d8f20fcf54771dac65e3ff4f5397268))


### Bug Fixes

* **cmp:** git completions ([8238fb9](https://github.com/snelling-a/nvim/commit/8238fb9f48251b1e47e65d3f5f7e6cc895e6a65c))
* turn off indent-blankline in browser ([3416b0b](https://github.com/snelling-a/nvim/commit/3416b0bf4419f65445d4a6a296babcf164c5bfa3))


### Miscellaneous

* **plugins:** update plugins ([79309a1](https://github.com/snelling-a/nvim/commit/79309a1f26e9876d384c06e76e16f77847222170))
* **spell:** update cspell.json ([afa5a2e](https://github.com/snelling-a/nvim/commit/afa5a2e9d88c612691ca7a78d1ff288a6ffe170a))

## [3.6.0](https://github.com/snelling-a/nvim/compare/v3.5.2...v3.6.0) (2023-05-17)


### Features

* **lsp:** add yaml features ([02487ad](https://github.com/snelling-a/nvim/commit/02487ada9e41c849bbc05d459a4c84f9c2b0631c))
* **lsp:** improve handlers ([eea1d3e](https://github.com/snelling-a/nvim/commit/eea1d3ee16c9d41d4febc9ffa2756630d7b2de9b))
* **lsp:** improve server capabilities ([fb86306](https://github.com/snelling-a/nvim/commit/fb86306f1ae79929105f8d39ac78712ddb5a1d4b))
* **ui:** fix copilot icon on stausline ([cbce1b2](https://github.com/snelling-a/nvim/commit/cbce1b285f6ad76a9af45f9ab08c9e9c1b57f2e8))


### Bug Fixes

* remove commented code ([f4184ef](https://github.com/snelling-a/nvim/commit/f4184ef889f1ce08fded5ce6ace22be593e297b4))


### Miscellaneous

* **spell:** update cspell.json ([8d48863](https://github.com/snelling-a/nvim/commit/8d48863ba4b10cf6abe219a350a21380051535e1))

## [3.5.2](https://github.com/snelling-a/nvim/compare/v3.5.1...v3.5.2) (2023-05-15)


### Bug Fixes

* **ci:** bot user email ([5527365](https://github.com/snelling-a/nvim/commit/5527365d8f256c7a5567a5a98619e456ec3dca28))

## [3.5.1](https://github.com/snelling-a/nvim/compare/v3.5.0...v3.5.1) (2023-05-15)


### Miscellaneous

* **spell:** update cspell.json ([518e28a](https://github.com/snelling-a/nvim/commit/518e28ad05fc3a7df18d1bde4e2fe2b7aeffc321))

## [3.5.0](https://github.com/snelling-a/nvim/compare/v3.4.0...v3.5.0) (2023-05-15)


### Features

* **plugin:** lightbulb ([5e610bd](https://github.com/snelling-a/nvim/commit/5e610bd09e081a692e5538c54b9402bf3f92428f))

## [3.4.0](https://github.com/snelling-a/nvim/compare/v3.3.0...v3.4.0) (2023-05-15)


### Features

* **docs:** star plugins used when updating readme ([a6702e9](https://github.com/snelling-a/nvim/commit/a6702e98c7010d34eafc6f0c32b70404c6aabfff))
* **plugin:** smart-splits ([915ea27](https://github.com/snelling-a/nvim/commit/915ea27fef5890c127e53903d1d1489daf1c4685))


### Miscellaneous

* **spell:** update cspell.json ([1aaa3da](https://github.com/snelling-a/nvim/commit/1aaa3da07270a7d2e1630d801a6b929baf89b7e1))

## [3.3.0](https://github.com/snelling-a/nvim/compare/v3.2.0...v3.3.0) (2023-05-15)


### Features

* **ci:** tag major/minor releases ([3b3164c](https://github.com/snelling-a/nvim/commit/3b3164cfcb3fde3a38f9bd787f8d1b6ab4bb7ba9))


### Bug Fixes

* **ci:** token ([7e797ea](https://github.com/snelling-a/nvim/commit/7e797ea786351770cfcf71cb3e9dd192960d898c))

## [3.2.0](https://github.com/snelling-a/nvim/compare/v3.1.2...v3.2.0) (2023-05-15)


### Features

* **plugin:** lsp_signature ([ca11c59](https://github.com/snelling-a/nvim/commit/ca11c59bdbc3a24260d1ecd45485f9af0fae3941))

## [3.1.2](https://github.com/snelling-a/nvim/compare/v3.1.1...v3.1.2) (2023-05-15)


### Bug Fixes

* **ci:** secrets ([3f87a59](https://github.com/snelling-a/nvim/commit/3f87a594b0b2c521dbc433cc48e29b0584c9f6fe))

## [3.1.1](https://github.com/snelling-a/nvim/compare/v3.1.0...v3.1.1) (2023-05-15)


### Bug Fixes

* **ci:** project name ([0678974](https://github.com/snelling-a/nvim/commit/0678974f41d05dde342292fe258bbf139c0c0b78))

## [3.1.0](https://github.com/snelling-a/nvim/compare/v3.0.0...v3.1.0) (2023-05-14)


### Features

* cellular-automation ([#51](https://github.com/snelling-a/nvim/issues/51)) ([d1e6b3b](https://github.com/snelling-a/nvim/commit/d1e6b3bb3fb97ce0cf367abec306975bb263b093))


### Bug Fixes

* **ci:** add permissions to workflow ([51016fe](https://github.com/snelling-a/nvim/commit/51016fe626c862140b2d52e911f7555be44715ea))

## [3.0.0](https://github.com/snelling-a/nvim/compare/v2.13.0...v3.0.0) (2023-05-14)


### ⚠ BREAKING CHANGES

* use release-please-action workflow ([#53](https://github.com/snelling-a/nvim/issues/53))
* use release-please-action workflow

### ci

* use release-please-action workflow ([b69d78a](https://github.com/snelling-a/nvim/commit/b69d78a043fcaa5d9a0af967844a298d144a3b5b))
* use release-please-action workflow ([#53](https://github.com/snelling-a/nvim/issues/53)) ([399dbf3](https://github.com/snelling-a/nvim/commit/399dbf3069a775cd21673a076d992521336ee92e))
