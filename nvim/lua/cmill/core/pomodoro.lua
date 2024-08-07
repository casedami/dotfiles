local M = {}

local Menu = require("nui.menu")
local Event = require("nui.utils.autocmd").event
local show_menu

local session_len = 25
local break_len = 5
local longbreak_len = 15
local sessions_until_longbreak = 2

local state = "inactive"
local session_start
local break_start
local sessions_completed = 0
local uv_timer = vim.uv.new_timer()

local function get_break_len()
  return sessions_completed == 0 and longbreak_len or break_len
end

function M.start_session()
  local ms = session_len * 60 * 1000
  uv_timer:start(ms, 0, vim.schedule_wrap(show_menu))
  session_start = os.time()
  state = "running"
end

function M.start_break()
  sessions_completed = (sessions_completed + 1) % sessions_until_longbreak
  local ms = get_break_len() * 60 * 1000
  uv_timer:start(ms, 0, vim.schedule_wrap(show_menu))
  break_start = os.time()
  state = "break"
end

function M.statusline()
  if state == "inactive" then
    return "(inactive)"
  end

  local duration = state == "running" and session_len or get_break_len()
  local start = state == "running" and session_start or break_start
  local seconds = duration * 60 - os.difftime(os.time(), start)

  if seconds <= 0 then
    return "--:--"
  end

  local icon = state == "running" and " " or " "
  return icon .. os.date("!%0M:%0S", seconds)
end

function M.stop()
  uv_timer:stop()
  state = "inactive"
end

show_menu = function()
  local popup_opts = {
    border = {
      style = "rounded",
      padding = { 1, 3 },
    },
    position = "50%",
    size = {
      width = "25%",
    },
    opacity = 1,
  }
  local session_lines = {
    Menu.item("Start session"),
    Menu.item("Quit"),
  }
  local break_lines = {
    Menu.item("Take a break"),
    Menu.item("Quit"),
  }
  local menu_opts = {
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      submit = { "<CR>", "<Space>" },
    },
    lines = (state == "break" or state == "inactive") and session_lines or break_lines,
    on_submit = function(item)
      if item.text == "Quit" then
        M.stop()
      elseif state == "break" or state == "inactive" then
        M.start_session()
      else
        M.start_break()
      end
    end,
  }
  local menu = Menu(popup_opts, menu_opts)
  menu:mount()
  menu:on(Event.BufLeave, function()
    menu:unmount()
  end, { once = true })
  menu:map("n", "q", function()
    M.stop()
    menu:unmount()
  end, { noremap = true })
end

vim.api.nvim_create_user_command("Pomo", M.start_session, { nargs = 0 })
vim.api.nvim_create_user_command("Pomoq", M.stop, { nargs = 0 })

return M
