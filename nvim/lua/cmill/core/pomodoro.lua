local session_len = 25
local break_len = 5
local longbreak_len = 15
local sessions_until_longbreak = 2

local state = "inactive"
local session_start
local break_start
local sessions_completed = 0
local uv_timer = nil

local function get_break_len()
  if sessions_completed == 0 then
    return longbreak_len
  else
    return break_len
  end
end

local function time_remaining(duration, start)
  local seconds = duration * 60 - os.difftime(os.time(), start)
  if seconds < 0 then
    state = "stopped"
    return "--:--"
  end

  if math.floor(seconds / 60) >= 60 then
    return os.date("!%0H:%0M:%0S", seconds)
  else
    return os.date("!%0M:%0S", seconds)
  end
end

local show_sessioncomplete_menu
local function start_session()
  if uv_timer == nil then
    uv_timer = vim.loop.new_timer()
  end

  local ms = session_len * 60 * 1000
  uv_timer:start(ms, 0, vim.schedule_wrap(show_sessioncomplete_menu))
  session_start = os.time()
  state = "running"
end

local show_startsession_menu
local function start_break()
  if uv_timer == nil then
    vim.notify("pomodoro: instantiation error", 4, nil)
    return
  end

  sessions_completed = (sessions_completed + 1) % sessions_until_longbreak
  local ms = get_break_len() * 60 * 1000
  uv_timer:start(ms, 0, vim.schedule_wrap(show_startsession_menu))
  break_start = os.time()
  state = "break"
end

local Pomodoro = {}

function Pomodoro.start()
  uv_timer = vim.loop.new_timer()
  start_session()
end

function Pomodoro.statusline()
  if state == "inactive" then
    return "(inactive)"
  elseif state == "stopped" then
    return "--:--"
  elseif state == "running" then
    return " " .. time_remaining(session_len, session_start)
  else
    local break_minutes = get_break_len()
    return "󰒲 " .. time_remaining(break_minutes, break_start)
  end
end

function Pomodoro.status()
  print(Pomodoro.statusline())
end

function Pomodoro.stop()
  if uv_timer ~= nil then
    uv_timer:stop()
    uv_timer:close()
    state = "inactive"
  end
end

local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

show_sessioncomplete_menu = function()
  local popup_options = {
    border = {
      style = "none",
      padding = { 1, 3 },
    },
    position = "50%",
    size = {
      width = "25%",
    },
    opacity = 1,
  }

  local menu_options = {
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    lines = { Menu.item("Take a break"), Menu.item("Quit") },
    on_submit = function(item)
      if item.text == "Quit" then
        Pomodoro.stop()
      else
        start_break()
      end
    end,
  }
  local menu = Menu(popup_options, menu_options)
  menu:mount()
  menu:on(event.BufEnter, function()
    state = "stopped"
    if uv_timer ~= nil then
      uv_timer:stop()
      uv_timer:close()
    end
  end, { once = true })
  menu:on(event.BufLeave, function()
    menu:unmount()
  end, { once = true })
  menu:map("n", "b", function()
    start_break()
    menu:unmount()
  end, { noremap = true })
  menu:map("n", "q", function()
    Pomodoro.stop()
    menu:unmount()
  end, { noremap = true })
end

show_startsession_menu = function()
  local popup_options = {
    border = {
      style = "none",
      padding = { 1, 3 },
    },
    position = "50%",
    size = {
      width = "25%",
    },
    opacity = 1,
  }

  local menu_options = {
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    lines = { Menu.item("Start session"), Menu.item("Quit") },
    on_submit = function(item)
      if item.text == "Quit" then
        Pomodoro.stop()
      else
        start_session()
      end
    end,
  }

  local menu = Menu(popup_options, menu_options)
  menu:mount()
  menu:on(event.BufEnter, function()
    if uv_timer ~= nil then
      uv_timer:stop()
      uv_timer:close()
    end
  end, { once = true })
  menu:on(event.BufLeave, function()
    menu:unmount()
  end, { once = true })
  menu:map("n", "p", function()
    start_session()
    menu:unmount()
  end, { noremap = true })
  menu:map("n", "q", function()
    Pomodoro.stop()
    menu:unmount()
  end, { noremap = true })
end

vim.api.nvim_create_user_command("Pstart", show_startsession_menu, { nargs = 0 })
vim.api.nvim_create_user_command("Pstop", Pomodoro.stop, { nargs = 0 })
vim.api.nvim_create_user_command("Pstatus", Pomodoro.status, { nargs = 0 })

return Pomodoro
