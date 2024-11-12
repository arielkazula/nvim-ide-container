-- plugins.lua
return {
        -- Mason and LSP integration
        { "williamboman/mason.nvim", run = ":MasonUpdate" },
        {
                "williamboman/mason-lspconfig.nvim",
                config = function()
                        require("mason-lspconfig").setup({
                                ensure_installed = { "clangd" },
                                automatic_installation = true,
                        })
                end,
        },

        -- Neovim LSP configurations
        { "neovim/nvim-lspconfig" },

        -- Completion and Snippets

        {
                "hrsh7th/nvim-cmp",
                dependencies = {
                        "L3MON4D3/LuaSnip",
                        "saadparwaiz1/cmp_luasnip",
                },
        },

        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        -- Add more Treesitter parsers
        {
                "nvim-treesitter/nvim-treesitter",
                opts = {
                        ensure_installed = {
                                "bash",
                                "json",
                                "lua",
                                "markdown",
                                "markdown_inline",
                                "python",
                                "regex",
                                "vim",
                                "cpp", -- C++ parser
                                "c", -- C parser
                        },
                },
        },

        { "nvim-treesitter/playground" },
        -- Telescope for fuzzy searching
        { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

        -- Neogen for generating Doxygen comments
        {
                "danymat/neogen",
                dependencies = "nvim-treesitter",
                config = function()
                        require("neogen").setup({
                                enabled = true,
                                languages = {
                                        cpp = {
                                                template = {
                                                        annotation_convention = "custom",
                                                        custom = {
                                                                { nil, "/**", { no_results = true, type = { "func", "file" } } },
                                                                { nil, " * @file", { no_results = true, type = { "file" } } },
                                                                { nil, " * $1", { no_results = true, type = { "func", "file" } } },
                                                                { nil, " */", { no_results = true, type = { "func", "file" } } },
                                                                { nil, "", { no_results = true, type = { "file" } } },

                                                                { nil, "/**", { type = { "func" } } },
                                                                { nil, " * $1", { type = { "func" } } },
                                                                { nil, " *", { type = { "func" } } },
                                                                { "tparam", " * @tparam %s $1" },
                                                                { "parameters", " * @param %s $1" },
                                                                { "return_statement", " * @return $1" },
                                                                { nil, " */" },
                                                        },
                                                },
                                        },
                                },
                        })
                end,
        },

        -- Fuzzy finder with fzf
        {
                "junegunn/fzf",
                run = function()
                        vim.fn["fzf#install"]()
                end,
        },
        { "junegunn/fzf.vim" },

        -- Autopairs for brackets and parentheses
        {
                "windwp/nvim-autopairs",
                config = function()
                        require("nvim-autopairs").setup()
                end,
        },

        {
                "navarasu/onedark.nvim",
                config = function()
                        require("onedark").setup({
                                -- Main options --
                                style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                                transparent = true, -- Show/hide background
                                term_colors = true, -- Change terminal color as per the selected theme style
                                ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
                                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                                -- toggle theme style ---
                                toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
                                toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

                                -- Change code style ---
                                -- Options are italic, bold, underline, none
                                -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
                                code_style = {
                                        comments = "italic",
                                        keywords = "none",
                                        functions = "none",
                                        strings = "none",
                                        variables = "none",
                                },

                                -- Lualine options --
                                lualine = {
                                        transparent = false, -- lualine center bar transparency
                                },

                                -- Custom Highlights --
                                colors = {}, -- Override default colors
                                highlights = {
                                        -- Tree-sitter specific highlight groups
                                        --["@comment"] = { fg = "#228B22" }, -- Dark green for Tree-sitter comments
                                        ["@comment.documentation"] = { fg = "#3cb371" }, -- Dark green for Tree-sitter documentation comments
                                }, -- Override highlight groups

                                -- Plugins Config --
                                diagnostics = {
                                        darker = true, -- darker colors for diagnostic
                                        undercurl = true, -- use undercurl instead of underline for diagnostics
                                        background = false, -- use background color for virtual text
                                },
                        })
                end,
        },
        {
                "chrisgrieser/nvim-rip-substitute",
                cmd = "RipSubstitute",
                keys = {
                        {
                                "<leader>fs",
                                function()
                                        require("rip-substitute").sub()
                                end,
                                mode = { "n", "x" },
                                desc = " rip substitute",
                        },
                },
        },
        -- Allow moving lines up down left right
        {
                "echasnovski/mini.nvim",
                version = "*",
                config = function()
                        require("mini.move").setup({
                                -- Module mappings. Use `''` (empty string) to disable one.
                                mappings = {
                                        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                                        left = "",
                                        right = "",
                                        down = "<M-j>",
                                        up = "<M-k>",

                                        -- Move current line in Normal mode
                                        line_left = "",
                                        line_right = "",
                                        line_down = "<M-j>",
                                        line_up = "<M-k>",
                                },
                        })
                end,
        },
        {
                "nvimdev/dashboard-nvim",
                event = "VimEnter",
                opts = function(_, opts)
                        local logo = [[
             _______     _                  _________ ______   _______
            (  ___  )   | \    /\           \__   __/(  __  \ (  ____ \
            | (   ) |   |  \  / /              ) (   | (  \  )| (    \/
            | (___) |   |  (_/ /    _____      | |   | |   ) || (__
            |  ___  |   |   _ (    (_____)     | |   | |   | ||  __)
            | (   ) |   |  ( \ \               | |   | |   ) || (
            | )   ( | _ |  /  \ \           ___) (___| (__/  )| (____/\
            |/     \|(_)|_/    \/           \_______/(______/ (_______/
            ]]

                        logo = string.rep("\n", 8) .. logo .. "\n\n"
                        opts.config.header = vim.split(logo, "\n")
                        opts.theme = "doom"
                end,
        },
        {
                "kdheepak/lazygit.nvim",
                lazy = true,
                cmd = {
                        "LazyGit",
                        "LazyGitConfig",
                        "LazyGitCurrentFile",
                        "LazyGitFilter",
                        "LazyGitFilterCurrentFile",
                },
                -- optional for floating window border decoration
                dependencies = {
                        "nvim-lua/plenary.nvim",
                },
                -- setting the keybinding for LazyGit with 'keys' is recommended in
                -- order to load the plugin when the command is run for the first time
                keys = {
                        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
                },
        },
        -- nvim-rip-substitute plugin configuration
        {
                "chrisgrieser/nvim-rip-substitute",
                config = function()
                        require("rip-substitute").setup({
                                highlight = {
                                        duration = 500, -- Highlight duration in milliseconds
                                },
                                mappings = {
                                        substitute = "<leader>rs",
                                        substitute_word = "<leader>rw",
                                },
                        })
                end,
        },

        {
                "tris203/precognition.nvim",
                -- event = "VeryLazy", -- Uncomment if you want to lazy load
                opts = {
                        -- Configuration options for precognition
                        -- Customize further as needed
                        startVisible = true,
                        showBlankVirtLine = true,
                        highlightColor = { link = "Comment" },
                        hints = {
                                Caret = { text = "^", prio = 2 },
                                Dollar = { text = "$", prio = 1 },
                                MatchingPair = { text = "%", prio = 5 },
                                Zero = { text = "0", prio = 1 },
                                w = { text = "w", prio = 10 },
                                b = { text = "b", prio = 9 },
                                e = { text = "e", prio = 8 },
                                W = { text = "W", prio = 7 },
                                B = { text = "B", prio = 6 },
                                E = { text = "E", prio = 5 },
                        },
                        gutterHints = {
                                G = { text = "G", prio = 10 },
                                gg = { text = "gg", prio = 9 },
                                PrevParagraph = { text = "{", prio = 8 },
                                NextParagraph = { text = "}", prio = 8 },
                        },
                        -- Disable precognition for specific file types
                        disabled_fts = {
                                "startify", -- Disable for startify if applicable
                                "dashboard", -- Ensure precognition does not show in dashboard-nvim
                        },
                },
        },
        {
                "kevinhwang91/nvim-ufo",
                dependencies = {
                        "kevinhwang91/promise-async", -- Required dependency
                },
                config = function()
                        require("ufo").setup({
                                provider_selector = function(bufnr, filetype, buftype)
                                        -- Use treesitter as the main provider, then fall back to lsp and then indent
                                        return { "treesitter", "indent" }
                                end,
                        })
                end,
        },

        -- Plugin configuration for lazy.nvim
        {
                "folke/todo-comments.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
                opts = {
                        signs = true,
                        sign_priority = 8,
                        keywords = {
                                FIX = {
                                        icon = " ",
                                        color = "error",
                                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                                },
                                TODO = { icon = " ", color = "info" },
                                HACK = { icon = " ", color = "warning" },
                                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                        },
                        gui_style = {
                                fg = "NONE",
                                bg = "BOLD",
                        },
                        merge_keywords = true,
                        highlight = {
                                multiline = true,
                                multiline_pattern = "^.",
                                multiline_context = 10,
                                before = "",
                                keyword = "wide",
                                after = "fg",
                                pattern = [[.*<(KEYWORDS)\s*:]],
                                comments_only = true,
                                max_line_len = 400,
                                exclude = {},
                        },
                        colors = {
                                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                                info = { "DiagnosticInfo", "#2563EB" },
                                hint = { "DiagnosticHint", "#10B981" },
                                default = { "Identifier", "#7C3AED" },
                                test = { "Identifier", "#FF00FF" },
                        },
                        search = {
                                command = "rg",
                                args = {
                                        "--color=never",
                                        "--no-heading",
                                        "--with-filename",
                                        "--line-number",
                                        "--column",
                                },
                                pattern = [[\b(KEYWORDS):]],
                        },
                },
        },
        {
                "rachartier/tiny-code-action.nvim",
                dependencies = {
                        { "nvim-lua/plenary.nvim" },
                        { "nvim-telescope/telescope.nvim" },
                },
                event = "LspAttach",
                config = function()
                        require("tiny-code-action").setup({
                                telescope_opts = {
                                        layout_strategy = "horizontal",
                                        layout_config = {
                                                width = 0.6,
                                                height = 0.6,
                                                preview_cutoff = 1,
                                        },
                                },
                        })
                end,
        },
}
