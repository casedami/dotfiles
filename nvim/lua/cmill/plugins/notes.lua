return {
  {
    "lervag/vimtex",
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/self/notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/self/notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "ObsidianNew",
    opts = {
      dir = "~/self/notes/main/",
      templates = {
        subdir = "resources/templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
      mappings = {},
      finder = "telescope.nvim",
      log_level = vim.log.levels.OFF,
      ui = {
        enable = true,
        hl_groups = {},
      },
      note_id_func = function(tag)
        local prefix = tag or ""
        return prefix .. os.date("%Y%m%d%H%M")
      end,
      disable_frontmatter = function(note)
        return string.find(note, "python") or string.find(note, "tasks")
      end,
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
    },
  },
}
