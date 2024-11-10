-- keymaps.lua
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- LSP keymaps for navigation
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

-- Generate Doxygen comments with Neogen
map("n", "<leader>ng", ':lua require("neogen").generate()<CR>', opts)

-- Fuzzy search using Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)

-- Fast buffer change mappings
map("n", "<A-[>", ":bprevious<CR>", opts)
map("n", "<A-]>", ":bnext<CR>", opts)

-- Key mappings for todo-comments navigation
map("n", "]t", '<cmd>lua require("todo-comments").jump_next()<CR>', opts)
map("n", "[t", '<cmd>lua require("todo-comments").jump_prev()<CR>', opts)

-- Optional: Jump to the next error/warning todo comment
map("n", "]e", '<cmd>lua require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })<CR>', opts)
map("n", "[e", '<cmd>lua require("todo-comments").jump_prev({ keywords = { "ERROR", "WARNING" } })<CR>', opts)

-- Key mapping to list all TODOs in project
map("n", "<leader>tf", "<cmd>TodoTelescope<CR>", opts)

function TodoInCurrentDir()
        require("telescope").extensions["todo-comments"].todo({
                cwd = vim.fn.expand("%:p:h"), -- Search in the current buffer dir
                file_ignore_patterns = { "node_modules", "dist" }, -- Ignore certain directories
        })
end
map("n", "<leader>td", ":lua TodoInCurrentDir()<CR>", opts)

function TodoInParentDir()
        local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
        local parent_dir = vim.fn.fnamemodify(buf_dir, ":h")
        require("telescope").extensions["todo-comments"].todo({
                cwd = parent_dir, -- Search in the current buffer dir
                file_ignore_patterns = { "node_modules", "dist" }, -- Ignore certain directories
        })
end
map("n", "<leader>tp", ":lua TodoInParentDir()<CR>", opts)
