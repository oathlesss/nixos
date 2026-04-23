local map = vim.keymap.set

local function fugitive(command)
  return function()
    vim.cmd.packadd("vim-fugitive")
    vim.cmd(command)
  end
end

map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Tmux sessionizer" })
map("n", "<leader>gs", fugitive("Git"), { desc = "Git status" })
map("n", "<leader>gb", fugitive("Git blame"), { desc = "Git blame" })
map("n", "<leader>gd", fugitive("Gvdiffsplit"), { desc = "Git diff" })
map("n", "<leader>gw", fugitive("Gwrite"), { desc = "Git stage file" })
map("n", "<leader>gl", fugitive("Git log --oneline --decorate --graph"), { desc = "Git log" })
map("n", "<leader>gc", fugitive("Git commit"), { desc = "Git commit" })
map("n", "<leader>gp", fugitive("Git push"), { desc = "Git push" })
map("n", "<leader>gP", fugitive("Git pull --rebase"), { desc = "Git pull rebase" })
map("n", "<leader>gr", fugitive("Gread"), { desc = "Git restore file" })

-- Gitsigns hunk navigation
map("n", "]c", function()
  if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
  else require("gitsigns").nav_hunk("next") end
end, { desc = "Next hunk" })
map("n", "[c", function()
  if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
  else require("gitsigns").nav_hunk("prev") end
end, { desc = "Prev hunk" })

-- Diffview
map("n", "<leader>gv", "<cmd>DiffviewOpen<cr>",          { desc = "Diffview open" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>",         { desc = "Diffview close" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              { desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>",                     { desc = "TODOs" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   { desc = "Quickfix" })
map("n", "]x", function() require("trouble").next({ skip_groups = true, jump = true }) end, { desc = "Next trouble item" })
map("n", "[x", function() require("trouble").prev({ skip_groups = true, jump = true }) end, { desc = "Prev trouble item" })

-- Obsidian
map("n", "<leader>of", "<cmd>ObsidianSearch<cr>",     { desc = "Find note" })
map("n", "<leader>on", "<cmd>ObsidianNew<cr>",        { desc = "New note" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>",  { desc = "Backlinks" })
map("n", "<leader>od", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link" })
