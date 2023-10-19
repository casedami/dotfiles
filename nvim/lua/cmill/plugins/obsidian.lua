-- TODO: remove from cade
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
      completion = {
        nvim_cmp = true,
        min_chars = 2,
        new_notes_location = "current_dir",
        prepend_note_id = false,
      },
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
    },
  },
  { "lervag/vimtex" },
}
