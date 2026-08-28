-- ============================================
-- CCLinux 1.7 - KERNEL
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"
local CONFIG = PERSONAL .. "/config.txt"

-- --------------------------------------------
-- CRIAR PASTA PESSOAL
-- --------------------------------------------

if not fs.exists(PERSONAL) then

    fs.makeDir(PERSONAL)

    local f =
        fs.open(CONFIG, "w")

    f.writeLine("nome=usuario")
    f.writeLine("senha=")

    f.close()

end

-- --------------------------------------------
-- LOGIN
-- --------------------------------------------

if fs.exists(BASE .. "/login.lua") then
    shell.run(BASE .. "/login.lua")
end

-- --------------------------------------------
-- MONITOR
-- --------------------------------------------

if fs.exists(BASE .. "/monitor.lua") then

    local ok, erro =
        pcall(function()
            shell.run(BASE .. "/monitor.lua")
        end)

    if not ok then
        print("Erro no monitor:")
        print(erro)
    end

end

-- --------------------------------------------
-- SHELL
-- --------------------------------------------

if fs.exists(BASE .. "/shell.lua") then
    shell.run(BASE .. "/shell.lua")
end