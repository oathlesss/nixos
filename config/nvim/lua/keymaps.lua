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

-- Obsidian
map("n", "<leader>of", "<cmd>ObsidianSearch<cr>",     { desc = "Find note" })
map("n", "<leader>on", "<cmd>ObsidianNew<cr>",        { desc = "New note" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>",  { desc = "Backlinks" })
map("n", "<leader>od", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link" })
