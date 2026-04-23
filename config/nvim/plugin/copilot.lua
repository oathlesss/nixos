require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept      = "<M-l>",
      accept_word = "<M-w>",
      accept_line = "<M-e>",
      next        = "<M-]>",
      prev        = "<M-[>",
      dismiss     = "<C-]>",
    },
  },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    help     = false,
  },
})
