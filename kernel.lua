-- ============================================
-- CCLinux 1.7
-- KERNEL
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"

-- ============================================
-- CRIAR PASTA PESSOAL NA PRIMEIRA VEZ
-- ============================================

if not fs.exists(PERSONAL) then

    fs.makeDir(PERSONAL)

    local f = fs.open(
        PERSONAL .. "/config.txt",
        "w"
    )

    f.writeLine("nome=usuario")
    f.writeLine("senha=")

    f.close()
end

-- ============================================
-- LOGIN
-- ============================================

if fs.exists(BASE .. "/login.lua") then
    shell.run(BASE .. "/login.lua")
end

-- ============================================
-- SHELL
-- ============================================

if fs.exists(BASE .. "/shell.lua") then
    shell.run(BASE .. "/shell.lua")
else

    term.clear()
    term.setCursorPos(1, 1)

    print("ERRO: shell.lua nao encontrado.")
end