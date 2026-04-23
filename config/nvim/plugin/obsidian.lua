require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "/home/ruben/repos/obsidian",
    },
  },

  -- New notes go into the inbox
  notes_subdir = "In",
  new_notes_location = "notes_subdir",

  -- Note filename = slugified title
  note_id_func = function(title)
    if title ~= nil then
      return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      return tostring(os.time())
    end
  end,

  -- Templates
  templates = {
    folder = "templates",
    date_format = "%Y-%m-%dT%H:%M",
  },

  -- Use [[wikilink]] syntax (compatible with Obsidian app)
  preferred_link_style = "wiki",

  -- Disable auto-frontmatter injection (we use our own template)
  disable_frontmatter = true,

  -- Completion via blink.compat (nvim_cmp = true registers the nvim-cmp source)
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },

  -- Explicitly use fzf-lua as picker
  picker = {
    name = "fzf-lua",
  },
})
