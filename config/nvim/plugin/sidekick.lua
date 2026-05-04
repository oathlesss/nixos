require("sidekick").setup({
  nes = {
    enabled = true,
  },
  cli = {
    picker = "fzf-lua",
    tools = {
      claude = {},
      codex  = {},
    },
  },
})

local map = vim.keymap.set

-- NES: jump to suggestion, then apply on second Tab
map("n", "<Tab>", function()
  local nes = require("sidekick.nes")
  if nes.have() then
    if not nes.jump() then
      nes.apply()
    end
  else
    return "<Tab>"
  end
end, { expr = true, desc = "NES: jump/apply suggestion" })

-- CLI
map("n", "<leader>aa", function() require("sidekick.cli").toggle() end,  { desc = "AI: toggle terminal" })
map("n", "<leader>as", function() require("sidekick.cli").select() end,  { desc = "AI: select tool" })
map("n", "<leader>ap", function() require("sidekick.cli").prompt() end,  { desc = "AI: prompt menu" })
map("n", "<leader>af", function() require("sidekick.cli").send({ prompt = "file" }) end, { desc = "AI: send file" })
map({ "n", "v" }, "<leader>at", function()
  require("sidekick.cli").send({ prompt = vim.fn.mode() == "n" and "position" or "selection" })
end, { desc = "AI: send context" })
