require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    section_separators = { left = '', right = ' '},
    component_separators = { left = '', right = '' },
    disabled_filetypes = { 'packer', 'NvimTree' },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {{'branch', icon = '', padding = {left=2}}, 'diff', 'diagnostics'},
    lualine_c = {'%f'},
    lualine_x = {'filetype'},
    lualine_y = {'location'},
    lualine_z = {'progress'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  winbar = {
	  lualine_a = { { 'filename', icon = '', file_status = false, path = 0, use_mode_colors = false, separator = {right = ''}} },
  },
  inactive_winbar = {},
  extensions = {}
}
