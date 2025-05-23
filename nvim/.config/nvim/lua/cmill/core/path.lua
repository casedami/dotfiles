local home = vim.uv.os_homedir()

---@class path
local P = {}

function P:new() end
function P:mkdir() end
function P:rm() end
function P:is_dir() end

-- function P.root(fname)
--     fname
-- end
function P:exists()
    local fname = vim.api.nvim_buf_get_name(0)
    print(fname)
    -- if fname then
    --     print(fname)
    --     -- print(P.root(fname))
    -- else
    --     print("hello")
    -- end
end

return P
