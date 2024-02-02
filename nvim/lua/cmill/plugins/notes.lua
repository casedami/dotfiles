return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
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
        substitutions = {},
      },
      mappings = {},
      finder = "telescope.nvim",
      ui = {
        enable = true,
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#e67e80" },
          ObsidianDone = { bold = true, fg = "#b7c3e3" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#bfce94", bg = "#151515" },
          ObsidianRefText = { underline = true, fg = "#A07A93" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#8799cf" },
          ObsidianHighlightText = { bg = "#3f4a33" },
        },
      },
      note_id_func = function(tag)
        local prefix = tag or ""
        return prefix .. os.date("%Y%m%d%H%M")
      end,
    },
  },
  { "lervag/vimtex" },
}
