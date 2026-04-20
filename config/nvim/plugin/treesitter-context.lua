require("treesitter-context").setup({
  max_lines     = 3,
  trim_scope    = "outer",
  mode          = "cursor",
})

vim.keymap.set("n", "[x", function() require("treesitter-context").go_to_context(vim.v.count1) end,
  { desc = "Jump to context" })
