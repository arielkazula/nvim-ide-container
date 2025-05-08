-- mason.lua

-- 1. Bootstrap Mason
require("mason").setup()

local lspconfig = require("lspconfig")
local blink_cmp = require("blink.cmp")

-- Shared capabilities
local capabilities = blink_cmp.get_lsp_capabilities()

vim.lsp.config("clangd", {
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
})

-- 2. Per-server overrides
local server_specific_opts = {
  clangd = {
    cmd = {
      "clangd", "--header-insertion=never", "--all-scopes-completion",
      "--background-index", "--pch-storage=disk", "--log=info",
      "--completion-style=detailed", "--enable-config", "--clang-tidy",
      "--offset-encoding=utf-16", "--fallback-style=llvm",
    },
    on_init = function(client) client.offset_encoding = "utf-8" end,
  },
  harper_ls = {
    settings = {
      ["harper-ls"] = {
        linters = {
          spell_check                 = true,
          spelled_numbers             = false,
          an_a                        = true,
          sentence_capitalization     = false,
          unclosed_quotes             = true,
          wrong_quotes                = false,
          long_sentences              = true,
          repeated_words              = true,
          spaces                      = true,
          matcher                     = true,
          correct_number_suffix       = true,
          number_suffix_capitalization = true,
          multiple_sequential_pronouns = true,
          linking_verbs               = false,
          avoid_curses                = true,
          terminating_conjunctions    = true,
        },
      },
    },
  },
}

-- 2. Mason-LSPConfig: single setup with handlers
require("mason-lspconfig").setup({
  ensure_installed       = {
    "clangd", "bashls", "pyright", "cmake",
    "lua_ls", "harper_ls", "marksman", "jsonls",
  },
  automatic_installation = true,
  handlers               = {
    function(server_name)
      local opts = vim.tbl_deep_extend(
        "force",
        { capabilities = capabilities },
        server_specific_opts[server_name] or {}
      )
      lspconfig[server_name].setup(opts)
    end,
  },
})

-- 3. Install formatters
local mason_registry = require("mason-registry")
for _, tool in ipairs({ "clang-format", "jq", "black", "codespell" }) do
  local pkg = mason_registry.get_package(tool)
  if not pkg:is_installed() then pkg:install() end
end

-- 4. Conform setup
require("conform").setup({
  formatters_by_ft = {
    cpp    = { "clang_format" },
    json   = { "jq" },
    python = { "black", "isort" },
  },
  format_on_save = { lsp_fallback = true },
})

-- 5. Blink.cmp setup
require("blink.cmp").setup({
  formatters = {
    ensure_installed = { "clang-format", "jq", "black", "codespell" },
    setup            = {
      cpp    = { "clang-format" },
      json   = { "jq" },
      python = { "black", "isort" },
    },
    format_on_save   = true,
  },
})
