-- mason.lua

require("mason").setup()

-- LSP servers setup
require("mason-lspconfig").setup({
	ensure_installed = {
		"clangd", -- C++
		"bashls", -- Bash
		"pyright", -- Python
		"cmake", -- cmake
		"lua_ls", -- Lua (if you use Lua in config)
		"harper_ls",
		"marksman",
		"jsonls",
	},
	automatic_installation = true, -- Automatically install any LSP that is configured
})

-- Install formatters directly using Mason
local mason_registry = require("mason-registry")

-- List of formatters you want to ensure are installed
local formatters = {
	"clang-format", -- C++ formatter
	"jq", -- JSON formatter
	"black", -- Python formatter
	"codespell", -- Spell check
}

-- Ensure all formatters are installed
for _, tool in ipairs(formatters) do
	local p = mason_registry.get_package(tool)
	if not p:is_installed() then
		p:install() -- Install the formatter if it's not already installed
	end
end

-- Conform setup for formatters
require("conform").setup({
	formatters_by_ft = {
		cpp = { "clang_format" }, -- C++ formatter
		json = { "jq" }, -- JSON formatter
		python = { "black", "isort" }, -- Python formatters
	},
	-- Configure auto-format on save
	format_on_save = {
		lsp_fallback = true,
	},
})

local lspconfig = require("lspconfig")
local blink_cmp = require("blink.cmp")

require("mason-lspconfig").setup_handlers({
	function(server_name)
		-- Default capabilities extended with blink.cmp
		local capabilities = blink_cmp.get_lsp_capabilities()

		-- Default configuration shared across servers
		local default_opts = {
			capabilities = capabilities,
		}
		-- Server-specific configurations
		local server_specific_opts = {
			clangd = {
				cmd = {
					"clangd",
					"--header-insertion=never",
					"--all-scopes-completion",
					"--background-index",
					"--pch-storage=disk",
					"--log=info",
					"--completion-style=detailed",
					"--enable-config",
					"--clang-tidy",
					"--offset-encoding=utf-16",
					"--fallback-style=llvm",
				},
				on_init = function(client)
					client.offset_encoding = "utf-8"
				end,
			},
			harper_ls = {
				settings = {
					["harper-ls"] = {
						linters = {
							spell_check = true,
							spelled_numbers = false,
							an_a = true,
							sentence_capitalization = false,
							unclosed_quotes = true,
							wrong_quotes = false,
							long_sentences = true,
							repeated_words = true,
							spaces = true,
							matcher = true,
							correct_number_suffix = true,
							number_suffix_capitalization = true,
							multiple_sequential_pronouns = true,
							linking_verbs = false,
							avoid_curses = true,
							terminating_conjunctions = true,
						},
					},
				},
			},
		}

		-- Merge default and server-specific options
		local opts = vim.tbl_deep_extend("force", default_opts, server_specific_opts[server_name] or {})
		-- Setup the server
		lspconfig[server_name].setup(opts) -- Merge specific options if they exist
	end,
})

require("blink.cmp").setup({
	formatters = {
		ensure_installed = { "clang-format", "jq", "black", "codespell" },
		setup = {
			cpp = { "clang-format" },
			json = { "jq" },
			python = { "black", "isort" },
		},
		format_on_save = true,
	},
})
