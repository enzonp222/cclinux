-- ============================================
-- CCLinux 1.7 - STARTUP
-- ============================================

local BASE = "/cclinux"

term.clear()
term.setCursorPos(1, 1)

print("======================================")
print("              CCLinux 1.7")
print("======================================")
print("")
print("Inicializando...")
print("")

-- Verifica se o sistema está instalado
if not fs.exists(BASE) then
    print("ERRO: pasta /cclinux nao encontrada.")
    print("")
    print("Instale o CCLinux primeiro.")
    return
end

-- Verifica o kernel
if not fs.exists(BASE .. "/kernel.lua") then
    print("ERRO: kernel.lua nao encontrado.")
    return
end

-- Barra de carregamento
local total = 24

for i = 1, total do
    local porcentagem = math.floor((i / total) * 100)

    term.write("[")
    term.write(string.rep("#", i))
    term.write(string.rep(" ", total - i))
    term.write("] " .. porcentagem .. "%")

    -- Som opcional
    local speaker = peripheral.find("speaker")
    if speaker and i % 4 == 0 then
        pcall(function()
            speaker.playNote("harp", 1, 12)
        end)
    end

    sleep(0.04)

    if i < total then
        term.setCursorPos(1, term.getCursorPos())
        term.clearLine()
    end
end

print("")
print("")
print("Sistema iniciado!")
sleep(0.5)

shell.run(BASE .. "/kernel.lua")