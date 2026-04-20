require("lualine").setup({
  options = {
    theme            = "catppuccin",
    globalstatus     = true,
    section_separators    = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      { "diff", symbols = { added = " ", modified = " ", removed = " " } },
    },
    lualine_c = {
      { "filename", path = 1, symbols = { modified = "●", readonly = "", unnamed = "[No Name]" } },
    },
    lualine_x = {
      {
        "diagnostics",
        sources  = { "nvim_lsp" },
        symbols  = { error = " ", warn = " ", info = " ", hint = " " },
      },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
  },
})
