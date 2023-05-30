# Changelog

## [4.5.0](https://github.com/snelling-a/nvim/compare/v4.4.0...v4.5.0) (2023-05-30)


### ⚠ BREAKING CHANGES

* **ui:** ui options are off by default
* use release-please-action workflow ([#53](https://github.com/snelling-a/nvim/issues/53))
* use release-please-action workflow
* **plugins:** migrate to lazy.nvim ([#30](https://github.com/snelling-a/nvim/issues/30))
* **config:** vim will not run on this commit

### Features

* add descriptions to autocmds ([f19c4ff](https://github.com/snelling-a/nvim/commit/f19c4ff28e585fdb524cd1b6503af622f935906e))
* add fzf to runtimepath ([651c4fd](https://github.com/snelling-a/nvim/commit/651c4fd1a2f711fe39e1fb470bbde90e0034ea1a))
* alpha ([#32](https://github.com/snelling-a/nvim/issues/32)) ([41d5ec6](https://github.com/snelling-a/nvim/commit/41d5ec642df3b4074fd9f8baa4fcf5ca34f45a1f))
* **alpha:** add help option ([75c52fc](https://github.com/snelling-a/nvim/commit/75c52fca3767f497d78538787bd6d2085c917bdf))
* bufignore ([#45](https://github.com/snelling-a/nvim/issues/45)) ([a2a5ea9](https://github.com/snelling-a/nvim/commit/a2a5ea941717798514ab4771059e1be087b103eb))
* **bufignore:** init plugin ([9f6f9bc](https://github.com/snelling-a/nvim/commit/9f6f9bc4c3d72a352c6742e5e79ac475b1aaf1c3))
* **bufignore:** setup plugin ([4587ea3](https://github.com/snelling-a/nvim/commit/4587ea33efb3dc36dbe2369c7b7437b752c7db18))
* cellular-automation ([#51](https://github.com/snelling-a/nvim/issues/51)) ([d1e6b3b](https://github.com/snelling-a/nvim/commit/d1e6b3bb3fb97ce0cf367abec306975bb263b093))
* **ci:** gh action to increment semver and release ([782b61d](https://github.com/snelling-a/nvim/commit/782b61d67f06c873f8eff5a4f713978c305499a0))
* **ci:** tag major/minor releases ([3b3164c](https://github.com/snelling-a/nvim/commit/3b3164cfcb3fde3a38f9bd787f8d1b6ab4bb7ba9))
* colorful-winsep ([#46](https://github.com/snelling-a/nvim/issues/46)) ([25a3f09](https://github.com/snelling-a/nvim/commit/25a3f09adb28d7aa31ed37000f5ce5c3aea5fc87))
* copy path options from neo-tree ([d6147dc](https://github.com/snelling-a/nvim/commit/d6147dc2a207e6fca817bee9b7ab0f043740df44))
* cssls ([0394b31](https://github.com/snelling-a/nvim/commit/0394b31ddfaaa12d15dd60d649f78ab7579cf0fc))
* dap ([#40](https://github.com/snelling-a/nvim/issues/40)) ([f3fe2c2](https://github.com/snelling-a/nvim/commit/f3fe2c20e5bf7e40961bf45b4af19b47a592748f))
* **dap:** dap init ([03601e4](https://github.com/snelling-a/nvim/commit/03601e450b770ad447a13c2fc20fef45f6687ee1))
* **dap:** dap-ui ([b28bb40](https://github.com/snelling-a/nvim/commit/b28bb400969096cd7a316d5a18877bf59deadc99))
* **dap:** go to breakpoints ([c0deedb](https://github.com/snelling-a/nvim/commit/c0deedb51117402ab68029e8a4460e5ba37f0837))
* **dap:** jest plugin ([315c4c6](https://github.com/snelling-a/nvim/commit/315c4c62d352fa88e21048c6a490cc92fb21d052))
* **dap:** keymaps ([d9fad51](https://github.com/snelling-a/nvim/commit/d9fad51df5b75faddeeaf94e1228c2cdfcd0fb91))
* **dap:** lua plugin ([31ae0d3](https://github.com/snelling-a/nvim/commit/31ae0d3f61a46511f149e710f3b07df8caab3eef))
* **dap:** mason ([e7a94aa](https://github.com/snelling-a/nvim/commit/e7a94aa5ad1a3700da6be7b18e95c30eb32a523b))
* **dap:** vscode plugin ([41aa891](https://github.com/snelling-a/nvim/commit/41aa891af80c9a5f9936717a639f9102ce4632d2))
* denols ([7b0b683](https://github.com/snelling-a/nvim/commit/7b0b683d4061b303c67c38cb40e44dbf47e7ba98))
* **docs:** star plugins used when updating readme ([a6702e9](https://github.com/snelling-a/nvim/commit/a6702e98c7010d34eafc6f0c32b70404c6aabfff))
* don't show the statuscolumn on help pages ([504140a](https://github.com/snelling-a/nvim/commit/504140a4acbcdaddeca9727669887a9d9ced44cb))
* dressing ([#36](https://github.com/snelling-a/nvim/issues/36)) ([289443f](https://github.com/snelling-a/nvim/commit/289443fb8a109a41633b814a38f63c97696533ea))
* **explorer:** nvim-tree -&gt; neo-tree ([36c17a5](https://github.com/snelling-a/nvim/commit/36c17a538bdddcfc1e8548af6bc897f5a5e4afcf))
* firenvim ([#52](https://github.com/snelling-a/nvim/issues/52)) ([c3cc9b9](https://github.com/snelling-a/nvim/commit/c3cc9b9de3428ad915a4c10d9ba5d7b6b02775e9))
* **firenvim:** config ([ba50eae](https://github.com/snelling-a/nvim/commit/ba50eae740a29bb3041ae60917a2aef6174f7781))
* **firenvim:** init plugin ([578e0d9](https://github.com/snelling-a/nvim/commit/578e0d91e6bae4e0dce99930d0c43cd3b66adc7d))
* flit ([#48](https://github.com/snelling-a/nvim/issues/48)) ([674d96c](https://github.com/snelling-a/nvim/commit/674d96c47afd3794d0faaf7fad4c496a09047574))
* **flit:** config ([ed37c2b](https://github.com/snelling-a/nvim/commit/ed37c2b392b30537296007bf9912f15808d7973e))
* **flit:** init plugin ([9e5be92](https://github.com/snelling-a/nvim/commit/9e5be920390e9884d41a4c3111460a5d87faa0e2))
* ftplugin for man pages ([7a34a7d](https://github.com/snelling-a/nvim/commit/7a34a7dc720c11a8f710adcf5a7e6582f6c3909b))
* ftplugins help json man ([#39](https://github.com/snelling-a/nvim/issues/39)) ([13b602c](https://github.com/snelling-a/nvim/commit/13b602c03aeacde4a52933d09cd7e2f627959897))
* **fzf:** telescope -&gt; fzf-lua ([d5c220f](https://github.com/snelling-a/nvim/commit/d5c220fb78e9972145ee710109f62a0d7255014e))
* **fzf:** use last used commands ([4ec709a](https://github.com/snelling-a/nvim/commit/4ec709a305b9b9c5f9bcc13cc43d6d09da4745f0))
* **git:** gh.nvim ([029b15e](https://github.com/snelling-a/nvim/commit/029b15e7533a166c28120ce4d5265df80b288bea))
* **git:** gh.nvim ([2839640](https://github.com/snelling-a/nvim/commit/283964029196ec4caaa5127e06dbf5d962ce31f8))
* graphql ([d4b6732](https://github.com/snelling-a/nvim/commit/d4b6732e3213f3f4fc1dfca9a1aba62a24cdfc34))
* has ([49eb628](https://github.com/snelling-a/nvim/commit/49eb6283a07091a396801cfee9feef722db4f3ac))
* html ([4ca5b3d](https://github.com/snelling-a/nvim/commit/4ca5b3d3b8475a2e2c310fb6dd90c91551e3cbb8))
* image_previewer ([beb97fc](https://github.com/snelling-a/nvim/commit/beb97fcf2b31bdeb4e424171aa49b0d702ffaec4))
* import cost ([0fa7ce9](https://github.com/snelling-a/nvim/commit/0fa7ce9b75334ca334c5b1e7ba5e1950d6a77846))
* improve autocmds ([3413151](https://github.com/snelling-a/nvim/commit/34131519d1f8644c0e9fc5f911bdab4fe3001452))
* init lazy ([446ba35](https://github.com/snelling-a/nvim/commit/446ba35200a49c4d255b991deece2d869469663a))
* json ([2e617b7](https://github.com/snelling-a/nvim/commit/2e617b7ef0f2c038df338e50137ac1375e2b2a48))
* **keys:** add missing descriptions ([580bfb7](https://github.com/snelling-a/nvim/commit/580bfb78586668592a625cae81731f7e7c156c83))
* **keys:** easy indent ([6b077a2](https://github.com/snelling-a/nvim/commit/6b077a27e8bdf388cc368973be296ec9a9ac5b0f))
* **keys:** make hard mode conditional ([e73f6fb](https://github.com/snelling-a/nvim/commit/e73f6fbe193b6b3bd66d8760ebfa226f799c36d2))
* **lsp:** add yaml features ([02487ad](https://github.com/snelling-a/nvim/commit/02487ada9e41c849bbc05d459a4c84f9c2b0631c))
* **lsp:** codeLens ([690652c](https://github.com/snelling-a/nvim/commit/690652c917d53f642f50ed5379989c4bdabe9ab9))
* **lsp:** improve handlers ([eea1d3e](https://github.com/snelling-a/nvim/commit/eea1d3ee16c9d41d4febc9ffa2756630d7b2de9b))
* **lsp:** improve server capabilities ([fb86306](https://github.com/snelling-a/nvim/commit/fb86306f1ae79929105f8d39ac78712ddb5a1d4b))
* **lsp:** improved capabilities ([de86b41](https://github.com/snelling-a/nvim/commit/de86b41f418970d0ed909346aae921666ccc7d08))
* **lsp:** Init lsp config ([4cc46a6](https://github.com/snelling-a/nvim/commit/4cc46a69773a7ca943dd28e12b0ebbac963ccc4c))
* **lsp:** inlay hints ([8025026](https://github.com/snelling-a/nvim/commit/8025026fbb8d806102d2dca5d0178fadb47042a6))
* **lsp:** use TSComment highlight for signature hint ([d82fb0b](https://github.com/snelling-a/nvim/commit/d82fb0be1e2b226c05370ca784cab7cf110f4590))
* neo-tree nesting rules ([a4cd2c9](https://github.com/snelling-a/nvim/commit/a4cd2c99111b2affbebd2d58ff461a708a173ba6))
* **plugin:** alpha init ([8fc0cdf](https://github.com/snelling-a/nvim/commit/8fc0cdf39c1ce406b4484b2af4e8643797332f0c))
* **plugin:** dressing opts ([7d4d62a](https://github.com/snelling-a/nvim/commit/7d4d62a12189b6db7ba3223af550acea3f774287))
* **plugin:** init dressing ([6d392f9](https://github.com/snelling-a/nvim/commit/6d392f999fa5a0ada6ec8157e1d0c222fe80816d))
* **plugin:** init pretty-fold ([d9909da](https://github.com/snelling-a/nvim/commit/d9909daf47c73535911597d1908f8fa79349157a))
* **plugin:** lightbulb ([5e610bd](https://github.com/snelling-a/nvim/commit/5e610bd09e081a692e5538c54b9402bf3f92428f))
* **plugin:** lsp_signature ([ca11c59](https://github.com/snelling-a/nvim/commit/ca11c59bdbc3a24260d1ecd45485f9af0fae3941))
* **plugin:** pretty-fold ([#35](https://github.com/snelling-a/nvim/issues/35)) ([4cd5bea](https://github.com/snelling-a/nvim/commit/4cd5bea08072fc50a580390eda43c1fdda9fd5bc))
* **plugin:** pretty-fold config ([0b60ae0](https://github.com/snelling-a/nvim/commit/0b60ae0f13955679ca92d05cf2b8785332fd4c51))
* **plugins:** convert plugins to lazy specs ([8ffa883](https://github.com/snelling-a/nvim/commit/8ffa8835eb98013b1892155f5c7af95489edd4ec))
* **plugin:** scretch ([1105903](https://github.com/snelling-a/nvim/commit/110590361e752188ca01c5c92daf6844f0f41d1e))
* **plugin:** scretch ([#34](https://github.com/snelling-a/nvim/issues/34)) ([7038bac](https://github.com/snelling-a/nvim/commit/7038bacc68f23f3c72b67984d16c12805caea270))
* **plugin:** setup alpha ([1e51321](https://github.com/snelling-a/nvim/commit/1e513217418433cf3ee8719faabdc5000879c786))
* **plugin:** smart-splits ([915ea27](https://github.com/snelling-a/nvim/commit/915ea27fef5890c127e53903d1d1489daf1c4685))
* **plugins:** migrate to lazy.nvim ([#30](https://github.com/snelling-a/nvim/issues/30)) ([6ff1039](https://github.com/snelling-a/nvim/commit/6ff103983ba3b3b7a542998b3beb47fb7d25e69e))
* **plugin:** spectre ([3ba3ee9](https://github.com/snelling-a/nvim/commit/3ba3ee930c3a9b818be57a2aae68025cdc7d97a2))
* **plugin:** vim-unimpaired ([a4d13ae](https://github.com/snelling-a/nvim/commit/a4d13aee6e7d7558662d76b305f940645ae51ea6))
* **plugin:** vim-unimpaired ([2f118aa](https://github.com/snelling-a/nvim/commit/2f118aac00b6c7854fccabae7f508ec92d62c8c5))
* relay ([070758d](https://github.com/snelling-a/nvim/commit/070758d8a6f9e296126a72703785e8cc4319dae1))
* server revamp ([#31](https://github.com/snelling-a/nvim/issues/31)) ([6725d1e](https://github.com/snelling-a/nvim/commit/6725d1ef88995e787cd5d3da9a74fe63f7109060))
* **session:** add user command to load session ([45a1855](https://github.com/snelling-a/nvim/commit/45a1855f4f11cf5481c8f5945003d71b329bb654))
* **spell:** SpellCheck command ([68adb03](https://github.com/snelling-a/nvim/commit/68adb03abe7ce701c3dc220dbd6585851c9fcc12))
* **spell:** Update cspell.json ([04ae75d](https://github.com/snelling-a/nvim/commit/04ae75d36c2a46f148441f2ab02f8871e008c30d))
* taplo ([98a7fb2](https://github.com/snelling-a/nvim/commit/98a7fb246da8a0bb3156609ad011a9dae90229e6))
* **treesitter:** regex highlighting for markdown ([b774f72](https://github.com/snelling-a/nvim/commit/b774f72d884a6bb518a26bd47c0918fb8402c3c1))
* **ui:** colorschemes/transparency ([21d5046](https://github.com/snelling-a/nvim/commit/21d504603a8b69f7e7480eb6a44dd75d41e0cfc1))
* **ui:** feline move ([d402f94](https://github.com/snelling-a/nvim/commit/d402f942e025b4f750420fb66263c417842233d0))
* **ui:** fix copilot icon on stausline ([cbce1b2](https://github.com/snelling-a/nvim/commit/cbce1b285f6ad76a9af45f9ab08c9e9c1b57f2e8))
* **ui:** guicursor ([a9fb4c8](https://github.com/snelling-a/nvim/commit/a9fb4c83b9c6a60306b401aa491525609b321770))
* **ui:** icons ([7c37f3a](https://github.com/snelling-a/nvim/commit/7c37f3acd0447c1f68c569139064dbafbd01abbd))
* **ui:** indentscope ([b52c868](https://github.com/snelling-a/nvim/commit/b52c86841a44e4164432462e07ce5d2eea6427b7))
* **ui:** inline inlay hints ([76bec3b](https://github.com/snelling-a/nvim/commit/76bec3bb9159ef79ea733bec0a472bc3e162c864))
* **ui:** override nvim-web-devicons for UNLICENSE ([5e52f92](https://github.com/snelling-a/nvim/commit/5e52f921a0214eca57eeed9102ec0e23e7108e86))
* **ui:** statusbar ([d60e321](https://github.com/snelling-a/nvim/commit/d60e321eae3ed5dbe6c72c95a084dbeb4fa8990f))
* **ui:** use devicons source ([e0a8c1e](https://github.com/snelling-a/nvim/commit/e0a8c1e2cbb933e870f31eee69b69a6459f29628))
* use dressing for imput/ui select ([3adbd43](https://github.com/snelling-a/nvim/commit/3adbd4302d8f20fcf54771dac65e3ff4f5397268))
* use notify as backup if noice doesn't load ([5fdb5cd](https://github.com/snelling-a/nvim/commit/5fdb5cde91432caeb8f2aa60891c1246ee22312a))
* vale diagnostics ([bc3cde3](https://github.com/snelling-a/nvim/commit/bc3cde38bac6ed3b9b5510b3d1ec6c087d247675))
* vimls ([da51188](https://github.com/snelling-a/nvim/commit/da51188234027407954f6135bcb5ec59b327892c))
* **winsep:** config ([50951b6](https://github.com/snelling-a/nvim/commit/50951b61d12237e38a74960bd62ab6cf31ae3954))
* **winsep:** init plugin ([dae8208](https://github.com/snelling-a/nvim/commit/dae8208a1712d6daad7651c6eb07a65f199b72d4))
* yamlls ([c2382cd](https://github.com/snelling-a/nvim/commit/c2382cd914b2d2a00c913670eca8ea2e776c50a7))


### Bug Fixes

* add pr to list of no_format filetypes ([7a012cc](https://github.com/snelling-a/nvim/commit/7a012cc9095832b6657869fdcddf2ae403b8f3ec))
* **alpha:** don't show dashboard in browser ([d9c96d7](https://github.com/snelling-a/nvim/commit/d9c96d76e053a6a8f2477304a0963bb1484a4476))
* **autopairs:** add cmp adapater ([ee58c13](https://github.com/snelling-a/nvim/commit/ee58c134576d6346569c0094f6b7f21872e8615f))
* **ci:** add permissions to workflow ([51016fe](https://github.com/snelling-a/nvim/commit/51016fe626c862140b2d52e911f7555be44715ea))
* **ci:** bot user email ([5527365](https://github.com/snelling-a/nvim/commit/5527365d8f256c7a5567a5a98619e456ec3dca28))
* **ci:** project name ([0678974](https://github.com/snelling-a/nvim/commit/0678974f41d05dde342292fe258bbf139c0c0b78))
* **ci:** secrets ([3f87a59](https://github.com/snelling-a/nvim/commit/3f87a594b0b2c521dbc433cc48e29b0584c9f6fe))
* **ci:** token ([7e797ea](https://github.com/snelling-a/nvim/commit/7e797ea786351770cfcf71cb3e9dd192960d898c))
* cmp ([#44](https://github.com/snelling-a/nvim/issues/44)) ([14ba834](https://github.com/snelling-a/nvim/commit/14ba834aa8830fdfd9899939c850f8198d6becf1))
* **cmp:** git completions ([8238fb9](https://github.com/snelling-a/nvim/commit/8238fb9f48251b1e47e65d3f5f7e6cc895e6a65c))
* copilot ([#49](https://github.com/snelling-a/nvim/issues/49)) ([2f3ae18](https://github.com/snelling-a/nvim/commit/2f3ae18cc5875e82351dd6a3312a6b46a46a4695))
* **copilot:** add config for copilot.lua ([60a580b](https://github.com/snelling-a/nvim/commit/60a580b2f18b43572a74a5eacd13e81dc1220e2f))
* **copilot:** fix dependencies ([3c5ab64](https://github.com/snelling-a/nvim/commit/3c5ab64fe293d5dcaf3e84686ed2b57a78eec66a))
* **copilot:** pass opts to setup ([dddfd54](https://github.com/snelling-a/nvim/commit/dddfd54e91b5d5266127a3224c003fa971d4c34f))
* **copilot:** remove unnecessary copilot.vim ([1a7df9f](https://github.com/snelling-a/nvim/commit/1a7df9f201db3c0f99b8338762685ac71137200c))
* correct ObsidianSearch button value ([0afcb94](https://github.com/snelling-a/nvim/commit/0afcb944bec3112f41da8fee32163a951ecaf41f))
* delete repeated keybinding ([c26aca5](https://github.com/snelling-a/nvim/commit/c26aca597adefbc96abea802187636ca2f592aae))
* don't use treesitter for indent-blankline ([2881f5d](https://github.com/snelling-a/nvim/commit/2881f5d447a0da2ba769621a298f6044e7c8c6e6))
* filetype property should be ft ([89b4247](https://github.com/snelling-a/nvim/commit/89b42473554a12c466c24a44c592bf589a18e5b4))
* **flit:** unmap commonly used keymaps ([08390c9](https://github.com/snelling-a/nvim/commit/08390c94a4ca39d325b98a02007af67209b8eaf8))
* fzf_lua ([eda2c7c](https://github.com/snelling-a/nvim/commit/eda2c7c0f8458745cd7c3f30a54b5be232a3b6e9))
* **fzf:** delete use of custom git log ([d7a09c9](https://github.com/snelling-a/nvim/commit/d7a09c94c927babc04e94013a90baf1d40b17673))
* **fzf:** fix typo ([9b97b95](https://github.com/snelling-a/nvim/commit/9b97b950b0cdcf6a4a1995a74e915b1545dfbd96))
* **fzf:** move diagnostics to root of opts ([757a456](https://github.com/snelling-a/nvim/commit/757a456ff13645176b1dcd38f558c4ae9073ccf8))
* **indentscope:** consistency ([3b3bda7](https://github.com/snelling-a/nvim/commit/3b3bda7e7e6e0388ef4fddc599d0b4c5eee554fd))
* json `opt` -&gt; `opt_local` ([30b9f41](https://github.com/snelling-a/nvim/commit/30b9f416764ca9cb441bb5d0fca4eb7d9a14cd93))
* **keymap:** delete unnecessary keymaps ([42de4b8](https://github.com/snelling-a/nvim/commit/42de4b816245960776852c33ffb08d80a3748ac2))
* **lint:** setting read-only global variable ([4b30099](https://github.com/snelling-a/nvim/commit/4b30099105e0be847b257fa47660fe87d500b713))
* **lsp:** change `_*` vars to unusedlocals ([f042625](https://github.com/snelling-a/nvim/commit/f0426250f24a4224c6e66fa70037fcab07bf04c4))
* **lsp:** change `_*` vars to unusedlocals ([#38](https://github.com/snelling-a/nvim/issues/38)) ([072eaa7](https://github.com/snelling-a/nvim/commit/072eaa74a5102b0cd406c4088c8e0982eae10571))
* **lsp:** disable noice hadling lsp signature ([9f4cf5b](https://github.com/snelling-a/nvim/commit/9f4cf5b02bf00139f7ad2db251f7af68723f8a53))
* **lsp:** remove runtime from lua_ls ([43be29c](https://github.com/snelling-a/nvim/commit/43be29c8daad33059a41ceffdfd06da790857d37))
* **lsp:** use fzf-lua code_action ([1bab365](https://github.com/snelling-a/nvim/commit/1bab3655ca32538662d2154c0157e7a64cc5ef04))
* **luasnip:** DRY ([eaa522c](https://github.com/snelling-a/nvim/commit/eaa522c3bf6c77172dd8b499b6b0de7fb4fb874f))
* remove commented code ([f4184ef](https://github.com/snelling-a/nvim/commit/f4184ef889f1ce08fded5ce6ace22be593e297b4))
* remove executable mode ([fb55d5f](https://github.com/snelling-a/nvim/commit/fb55d5f0ac58a611f9527ebebf11ead6b54f35bc))
* remove no filetype from no_format ([47a61c1](https://github.com/snelling-a/nvim/commit/47a61c1a4d7ff33b16dc906f614c47e84795373e))
* treesitter incremental selection ([#50](https://github.com/snelling-a/nvim/issues/50)) ([2ef2feb](https://github.com/snelling-a/nvim/commit/2ef2feb84d3e2a129c24872a8f2f798ff3c71e2c))
* **treesitter:** change conflicting mapping ([29521e0](https://github.com/snelling-a/nvim/commit/29521e099ddbe9b55dedaba10c551e16653d2016))
* turn off indent-blankline in browser ([3416b0b](https://github.com/snelling-a/nvim/commit/3416b0bf4419f65445d4a6a296babcf164c5bfa3))
* types ([107c5ae](https://github.com/snelling-a/nvim/commit/107c5ae376f1c3aa59613df7f03613448551e0cd))
* typo in filename ([53fdea3](https://github.com/snelling-a/nvim/commit/53fdea3636e40e41ca4c1d12710de69f3e6b3d48))
* **ui:** adjust dressing/nui settings ([b88460f](https://github.com/snelling-a/nvim/commit/b88460fdb5996d044a094e5d285ce1addca6ac3b))
* **ui:** breaking change in gitsigns internal api ([250c25b](https://github.com/snelling-a/nvim/commit/250c25b26fe0869b65714f1a8787f737a8c861f8))
* **ui:** fix toggle ui opts ([39ff537](https://github.com/snelling-a/nvim/commit/39ff537d62f52efc1069d07299da53d8018e38a5))
* **ui:** indent blankline ([215e842](https://github.com/snelling-a/nvim/commit/215e8426e5851f712eb8db8a45f76cc2006520d9))


### refactor

* **config:** move user/ files to config/ ([133b7ff](https://github.com/snelling-a/nvim/commit/133b7ffce1fc20be1d725d09488af4c8e84a9a62))


### ci

* use release-please-action workflow ([b69d78a](https://github.com/snelling-a/nvim/commit/b69d78a043fcaa5d9a0af967844a298d144a3b5b))
* use release-please-action workflow ([#53](https://github.com/snelling-a/nvim/issues/53)) ([399dbf3](https://github.com/snelling-a/nvim/commit/399dbf3069a775cd21673a076d992521336ee92e))


### Miscellaneous

* **copilot:** bump dependencies ([fc32fe9](https://github.com/snelling-a/nvim/commit/fc32fe9ebe94324a5ebc9a2d867cf510a20c81d0))
* **docs:** update README.md ([e52bcdf](https://github.com/snelling-a/nvim/commit/e52bcdf51243238de5f084f9c79b57550cb5aef2))
* license ([0cd6312](https://github.com/snelling-a/nvim/commit/0cd6312a2aaeae9493124e953b9bd4b35ea20872))
* **main:** release 3.0.0 ([fc48afa](https://github.com/snelling-a/nvim/commit/fc48afa78fa0962720709f5fddfd8099783ceed3))
* **main:** release 3.0.0 ([#54](https://github.com/snelling-a/nvim/issues/54)) ([564dafb](https://github.com/snelling-a/nvim/commit/564dafb5b0d589ae9069824559aa84f65d870266))
* **main:** release 3.1.0 ([#55](https://github.com/snelling-a/nvim/issues/55)) ([250c99e](https://github.com/snelling-a/nvim/commit/250c99e51a3d9f31c03861734c326a72070fb50f))
* **main:** release 3.1.1 ([#56](https://github.com/snelling-a/nvim/issues/56)) ([e02e6e9](https://github.com/snelling-a/nvim/commit/e02e6e904ef72e9bd3e3cef11880da2ad002acd1))
* **main:** release 3.1.2 ([#57](https://github.com/snelling-a/nvim/issues/57)) ([0e790a8](https://github.com/snelling-a/nvim/commit/0e790a83e680051f017d55495c19d77a5a37b0c7))
* **main:** release 3.10.0 ([#69](https://github.com/snelling-a/nvim/issues/69)) ([181c7ec](https://github.com/snelling-a/nvim/commit/181c7ec5ff73b433f1f7e449383c167e812b1a53))
* **main:** release 3.11.0 ([#70](https://github.com/snelling-a/nvim/issues/70)) ([94f83f1](https://github.com/snelling-a/nvim/commit/94f83f14ce5bf5543590af42559ad684948082e8))
* **main:** release 3.2.0 ([#58](https://github.com/snelling-a/nvim/issues/58)) ([d4c153b](https://github.com/snelling-a/nvim/commit/d4c153b8857b91b27fb273683c7f909c2cf4b32e))
* **main:** release 3.3.0 ([#59](https://github.com/snelling-a/nvim/issues/59)) ([8502b29](https://github.com/snelling-a/nvim/commit/8502b29f673ebc8408ca8fc7092fd1cdf2aac9df))
* **main:** release 3.4.0 ([#60](https://github.com/snelling-a/nvim/issues/60)) ([57a40cb](https://github.com/snelling-a/nvim/commit/57a40cb4dedd32107ff8c7248447061f6dc613b0))
* **main:** release 3.5.0 ([#61](https://github.com/snelling-a/nvim/issues/61)) ([81cddc6](https://github.com/snelling-a/nvim/commit/81cddc6192060bcd798510c8de5192c8ae53e45a))
* **main:** release 3.5.1 ([#62](https://github.com/snelling-a/nvim/issues/62)) ([769fe07](https://github.com/snelling-a/nvim/commit/769fe0727fefddf9272e0f16ef41c9493c588876))
* **main:** release 3.5.2 ([#63](https://github.com/snelling-a/nvim/issues/63)) ([31a0b7d](https://github.com/snelling-a/nvim/commit/31a0b7d2057e46bdb0df2dafa0d513b9c4be5d7f))
* **main:** release 3.6.0 ([#65](https://github.com/snelling-a/nvim/issues/65)) ([9dbac8e](https://github.com/snelling-a/nvim/commit/9dbac8edfc11736247b6bd92b2de55e4aec818dd))
* **main:** release 3.7.0 ([#66](https://github.com/snelling-a/nvim/issues/66)) ([6ef0a66](https://github.com/snelling-a/nvim/commit/6ef0a66ceeeeecaf0d1d0a1e2abb11f706e6843c))
* **main:** release 3.8.0 ([#67](https://github.com/snelling-a/nvim/issues/67)) ([188c5cc](https://github.com/snelling-a/nvim/commit/188c5cc4dfeed7f786d9d571c3064bda8a570ded))
* **main:** release 3.9.0 ([#68](https://github.com/snelling-a/nvim/issues/68)) ([b12ad0e](https://github.com/snelling-a/nvim/commit/b12ad0e705aadb47b43ad1870687058935b282f2))
* **main:** release 4.0.0 ([#71](https://github.com/snelling-a/nvim/issues/71)) ([6d140d7](https://github.com/snelling-a/nvim/commit/6d140d7b7c0d8c968a086d59a2953ff47e07a4a2))
* **main:** release 4.1.0 ([#72](https://github.com/snelling-a/nvim/issues/72)) ([35db375](https://github.com/snelling-a/nvim/commit/35db375ba53956eb782644738b6834af73126ace))
* **main:** release 4.2.0 ([#73](https://github.com/snelling-a/nvim/issues/73)) ([5570c30](https://github.com/snelling-a/nvim/commit/5570c306a44261b21997e3507cfe8f1c391ffba6))
* **main:** release 4.3.0 ([#74](https://github.com/snelling-a/nvim/issues/74)) ([0f45b69](https://github.com/snelling-a/nvim/commit/0f45b69cb331fbea711478ea48c3d866aeca18bb))
* **main:** release 4.4.0 ([#76](https://github.com/snelling-a/nvim/issues/76)) ([5fe8273](https://github.com/snelling-a/nvim/commit/5fe8273e8f200356c925ce04a0f53ba7b1b59edb))
* **plugin:** bump dependencies ([bae8592](https://github.com/snelling-a/nvim/commit/bae8592e1b6c58a8e4f57f5a65d5cf4508788473))
* **plugins:** lazy-lock.json ([a68fd2c](https://github.com/snelling-a/nvim/commit/a68fd2ca16fd7b9d1a028cdcdb11c67f1f83fb74))
* **plugins:** update packages ([815df14](https://github.com/snelling-a/nvim/commit/815df145c1e6e8f53bf46fb37a6a57b5cd2ccd20))
* **plugins:** update plugins ([79309a1](https://github.com/snelling-a/nvim/commit/79309a1f26e9876d384c06e76e16f77847222170))
* **plugins:** update plugins ([#37](https://github.com/snelling-a/nvim/issues/37)) ([871ff8f](https://github.com/snelling-a/nvim/commit/871ff8fb4baebe316d071fb592223cafd3db4db6))
* **plugin:** update fzf-lua ([936b3ac](https://github.com/snelling-a/nvim/commit/936b3ac10e9e59293a8817c28ad16bd7fff61484))
* **plugin:** update packages ([e72225a](https://github.com/snelling-a/nvim/commit/e72225ab01de1f2ecb9f3cf56c6e98befdb901a2))
* **plugin:** update plugins ([d8e57b6](https://github.com/snelling-a/nvim/commit/d8e57b6ec4610dbd2bb9053814366b0f518f0ca3))
* release 4.5.0 ([5b5434f](https://github.com/snelling-a/nvim/commit/5b5434f4499c137508e91de4a49f23b4398cdae2))
* **spelling:** update cspell.json ([3c74928](https://github.com/snelling-a/nvim/commit/3c74928e87e00f187559591892ae6aacfbdce7a7))
* **spell:** update cspell.json ([e830e4a](https://github.com/snelling-a/nvim/commit/e830e4a904880fb570b4a4743fd9c4c1be84d342))
* **spell:** update cspell.json ([2044aeb](https://github.com/snelling-a/nvim/commit/2044aeb61dc34cca23bef9083cff200bf73b14b5))
* **spell:** update cspell.json ([dc2bb3d](https://github.com/snelling-a/nvim/commit/dc2bb3d777fcb7a6fd911ca9581ab8d5bc5d375b))
* **spell:** update cspell.json ([840b46f](https://github.com/snelling-a/nvim/commit/840b46f1f01421e6acafc6fb4f15a5d44a8742bc))
* **spell:** update cspell.json ([116a7b8](https://github.com/snelling-a/nvim/commit/116a7b88c2f4d32ee60f4a985d0f3d1dc34bdfa4))
* **spell:** update cspell.json ([afa5a2e](https://github.com/snelling-a/nvim/commit/afa5a2e9d88c612691ca7a78d1ff288a6ffe170a))
* **spell:** update cspell.json ([8d48863](https://github.com/snelling-a/nvim/commit/8d48863ba4b10cf6abe219a350a21380051535e1))
* **spell:** update cspell.json ([518e28a](https://github.com/snelling-a/nvim/commit/518e28ad05fc3a7df18d1bde4e2fe2b7aeffc321))
* **spell:** update cspell.json ([1aaa3da](https://github.com/snelling-a/nvim/commit/1aaa3da07270a7d2e1630d801a6b929baf89b7e1))
* **spell:** update cspell.json ([bd695c9](https://github.com/snelling-a/nvim/commit/bd695c9d2617e089bee9515a7c749e2df15dfc97))
* **spell:** update cspell.json ([ab6b1df](https://github.com/snelling-a/nvim/commit/ab6b1df811d7f0989f8ca9be18b3f995055015c4))
* **spell:** update cspell.json ([733c3cd](https://github.com/snelling-a/nvim/commit/733c3cdd2630bb64604511b4bd7c76cd9cc82486))
* **spell:** update cspell.json ([3fa60dd](https://github.com/snelling-a/nvim/commit/3fa60dd458995774c761cd2a3cc40ca344f43a5b))
* update colorscheme repo name ([3f29f87](https://github.com/snelling-a/nvim/commit/3f29f87631fa3263354663e63ce5a57107df538f))
* update cspell.json ([0978713](https://github.com/snelling-a/nvim/commit/09787130192c3ec4d734fdcb3bcd6913912a6465))
* update fzf-lua ([#33](https://github.com/snelling-a/nvim/issues/33)) ([c2a7d2e](https://github.com/snelling-a/nvim/commit/c2a7d2e41946a19b1bb83629ab02f7343930db47))
* update packages ([5d9af3a](https://github.com/snelling-a/nvim/commit/5d9af3a4fdb26cb0848416435a82af2e87637536))
* update packages ([33de445](https://github.com/snelling-a/nvim/commit/33de44532499a3025d0aad27fdef6210d465d08c))
* update packages ([45abdbb](https://github.com/snelling-a/nvim/commit/45abdbb335d85650a4a64dc5c9f2f13d8f07099e))
* update plugins ([ba7486a](https://github.com/snelling-a/nvim/commit/ba7486a2b1e8aa3c021fcbd77ed7cf9a525bdbcc))

## [4.4.0](https://github.com/snelling-a/nvim/compare/v4.3.0...v4.4.0) (2023-05-29)


### Features

* image_previewer ([beb97fc](https://github.com/snelling-a/nvim/commit/beb97fcf2b31bdeb4e424171aa49b0d702ffaec4))
* **ui:** colorschemes/transparency ([21d5046](https://github.com/snelling-a/nvim/commit/21d504603a8b69f7e7480eb6a44dd75d41e0cfc1))
* **ui:** use devicons source ([e0a8c1e](https://github.com/snelling-a/nvim/commit/e0a8c1e2cbb933e870f31eee69b69a6459f29628))


### Bug Fixes

* typo in filename ([53fdea3](https://github.com/snelling-a/nvim/commit/53fdea3636e40e41ca4c1d12710de69f3e6b3d48))
* **ui:** breaking change in gitsigns internal api ([250c25b](https://github.com/snelling-a/nvim/commit/250c25b26fe0869b65714f1a8787f737a8c861f8))


### Miscellaneous

* update colorscheme repo name ([3f29f87](https://github.com/snelling-a/nvim/commit/3f29f87631fa3263354663e63ce5a57107df538f))
* update packages ([33de445](https://github.com/snelling-a/nvim/commit/33de44532499a3025d0aad27fdef6210d465d08c))
* update packages ([45abdbb](https://github.com/snelling-a/nvim/commit/45abdbb335d85650a4a64dc5c9f2f13d8f07099e))

## [4.3.0](https://github.com/snelling-a/nvim/compare/v4.2.0...v4.3.0) (2023-05-25)


### Features

* **spell:** SpellCheck command ([68adb03](https://github.com/snelling-a/nvim/commit/68adb03abe7ce701c3dc220dbd6585851c9fcc12))

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
