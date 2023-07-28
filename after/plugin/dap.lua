local dap, dapui = require("dap"), require("dapui")
local dapgo, dappy = require("dap-go"), require("dap-python")


dapui.setup()
dapgo.setup()
dappy.setup('~/.venv/bin/python')

-- listeners to run debug ui (dapui)
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- keymaps for debugging
vim.keymap.set("n", "<F9>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F8>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F7>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<S-F7>", ":lua require'dap'.step_back()<CR>")
vim.keymap.set("n", "<S-F8>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>db", ":lua require'dap'.clear_breakpoints()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>dc", ":lua require'dap'.repl.open()<CR>") -- debug console
vim.keymap.set("n", "<F6>", ":lua require'dap'.terminate()<CR>")


