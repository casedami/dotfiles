return {
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/self/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/self/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      dir = "~/self/uni",
      disable_frontmatter = true,
      templates = {
        subdir = "resources/templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      mappings = {
        -- ["gf"] = ...
      },
      finder = "telescope.nvim",
      ui = {
        enable = true,
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#6a491d" },
        },
      },
    },
  },
  { "lervag/vimtex" },
}
