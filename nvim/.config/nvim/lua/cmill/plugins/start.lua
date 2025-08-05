return {
    "echasnovski/mini.starter",
    version = "*",
    event = "VimEnter",
    opts = function()
        local new_section = function(name, action, section)
            section = section or ""
            return { name = name, action = action, section = section }
        end
        local starter = require("mini.starter")
        local config = {
            evaluate_single = true,
            content_hooks = {
                starter.gen_hook.padding(0, 10),
                starter.gen_hook.aligning("center", "top"),
            },
            items = {
                new_section("Find", "FzfLua files"),
                new_section("Explorer", "Yazi"),
                new_section("Recents", "FzfLua oldfiles"),
                new_section("Grep", "FzfLua live_grep"),
                new_section("Session", "Sesh load"),
                new_section("Lazy", "Lazy"),
                new_section("Quit", "qa"),
            },
            silent = true,
            header = function()
                local hour = tonumber(vim.fn.strftime("%H"))
                -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
                local part_id = math.floor((hour + 4) / 8) + 1
                local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
                local username = vim.loop.os_get_passwd()["username"] or "USERNAME"
                local cwd = vim.uv.cwd():gsub(vim.fn.getenv("HOME"), "~")
                local version = vim.version()

                local greeting = ("Good %s, %s"):format(day_part, username)
                local nvim = ("using Neovim %s.%s.%s"):format(
                    version.major,
                    version.minor,
                    version.patch
                )
                local context = ("in %s"):format(cwd)

                local center_ref = math.max(#greeting, #nvim, #context)
                local center = function(s)
                    local offset = math.floor(center_ref / 2)
                        - math.floor(vim.fn.strchars(s) / 2)
                    return string.rep(" ", offset) .. s
                end

                local sep = string.rep("", #greeting)
                local header = {
                    center(greeting),
                    center(sep),
                    center(nvim),
                    center(context),
                }

                return table.concat(header, "\n")
            end,
            footer = "",
        }

        return config
    end,
}
