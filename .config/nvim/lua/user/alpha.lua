local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[                   YAao,                          ]],
	[[                    Y8888b,                       ]],
	[[                  ,oA8888888b,                    ]],
	[[            ,aaad8888888888888888bo,              ]],
	[[         ,d888888888888888888888888888b,          ]],
	[[       ,888888888888888888888888888888888b,       ]],
  [[      d8888888888888888888888888888888888888,     ]],
  [[     d888888888888888888888888888888888888888b    ]],
  [[    d888888P'                    `Y888888888888,  ]],
  [[    88888P'                    Ybaaaa8888888888l  ]],
  [[   a8888'                      `Y8888P' `V888888  ]],
  [[ d8888888a                                `Y8888  ]],
  [[AY/'' `\Y8b                                 ``Y8b ]],
  [[Y'      `YP                                    ~~ ]],
  [[         `'                                       ]],
}
dashboard.section.buttons.val = {
	dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	--[[ dashboard.button("p", "  Find project", ":Telescope projects <CR>"), ]]
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	--[[ dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"), ]]
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "󰗼  Quit Neovim", ":qa<CR>"),
}

local function footer()
-- NOTE: requires the fortune-mod package to work
	-- local handle = io.popen("fortune")
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- return fortune
	return "Adi's Neovim config"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
