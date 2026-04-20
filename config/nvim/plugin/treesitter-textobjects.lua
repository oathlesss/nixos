require("nvim-treesitter-textobjects").setup({
  select = {
    enable    = true,
    lookahead = true,
    keymaps   = {
      ["af"] = { query = "@function.outer", desc = "outer function" },
      ["if"] = { query = "@function.inner", desc = "inner function" },
      ["ac"] = { query = "@class.outer",    desc = "outer class" },
      ["ic"] = { query = "@class.inner",    desc = "inner class" },
      ["aa"] = { query = "@parameter.outer", desc = "outer argument" },
      ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
    },
  },
  move = {
    enable              = true,
    set_jumps           = true,
    goto_next_start     = {
      ["]m"] = { query = "@function.outer", desc = "Next function start" },
      ["]o"] = { query = "@class.outer",    desc = "Next class start" },
    },
    goto_next_end       = {
      ["]M"] = { query = "@function.outer", desc = "Next function end" },
      ["]O"] = { query = "@class.outer",    desc = "Next class end" },
    },
    goto_previous_start = {
      ["[m"] = { query = "@function.outer", desc = "Prev function start" },
      ["[o"] = { query = "@class.outer",    desc = "Prev class start" },
    },
    goto_previous_end   = {
      ["[M"] = { query = "@function.outer", desc = "Prev function end" },
      ["[O"] = { query = "@class.outer",    desc = "Prev class end" },
    },
  },
})
