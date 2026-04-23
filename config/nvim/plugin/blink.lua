require("blink.cmp").setup({
  fuzzy = {
    implementation = "lua", -- use pure Lua, no binary needed
  },
  keymap     = { preset = "default" },
  sources    = {
    default = { "lsp", "path", "snippets", "buffer", "obsidian", "obsidian_new", "obsidian_tags" },
    providers = {
      obsidian = {
        name = "obsidian",
        module = "blink.compat.source",
        opts = { name = "obsidian" },
      },
      obsidian_new = {
        name = "obsidian_new",
        module = "blink.compat.source",
        opts = { name = "obsidian_new" },
      },
      obsidian_tags = {
        name = "obsidian_tags",
        module = "blink.compat.source",
        opts = { name = "obsidian_tags" },
      },
    },
  },
  cmdline    = { sources = { "cmdline" } },
  completion = {
    trigger       = { show_on_keyword = true, show_on_trigger_character = true },
    menu          = { auto_show = true },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
})
