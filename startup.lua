-- ==========================================
-- CCLinux 1.6 - STARTUP
-- ==========================================

if not fs.exists("/cclinux") then
    print("CCLinux nao encontrado!")
    print()
    print("A pasta /cclinux nao existe.")
    return
end

if not fs.exists("/cclinux/kernel.lua") then
    print("Erro: kernel.lua nao encontrado!")
    return
end

shell.run("/cclinux/kernel.lua")