local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.preset('recommended')
lsp.ensure_installed({
    'tsserver',
    'eslint',
    'pyright',
    'gopls',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set('n', 'gtd', function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)

    vim.keymap.set('n', '<leader>e', function() vim.lsp.diagnostic.show_line_diagnostics() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<leader>wa', function() vim.lsp.buf.add_workspace_folder() end, opts)
    vim.keymap.set('n', '<leader>wr', function() vim.lsp.buf.remove_workspace_folder() end, opts)
    vim.keymap.set('n', '<leader>wl', function () print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)

    -- creates window with lsp error/warning
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })
end)

lspconfig.gopls.setup({
    cmd = {'gopls', '--remote=auto'},
    filetypes = { "go", "gomod" },
    settings = {
        gopls = {
            usePlaceholders = true,
            buildFlags =  {"-tags=integration"},
            gofumpt = true,
        },
    },
    completeUnimported = true, -- autocomplete unimported packages
    deepCompletion = true,     -- enable deep completion
})

lsp.setup()