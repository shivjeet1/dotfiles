require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "vimdoc", "c", "bash", "python", "javascript", "rust", "lua"},
	sync_install = false,
	auto_install = true,
	ignore_install = { "javascript" },

	highlight = { enable = true },
	indent = { enable =true },
}
