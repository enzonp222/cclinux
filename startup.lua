-- ============================================
-- CCLinux 1.7 - STARTUP
-- ============================================

local monitor = peripheral.find("monitor")
local speaker = peripheral.find("speaker")

local function beep(pitch, duration)
    if speaker then
        pcall(function()
            speaker.playNote("harp", 1, pitch)
        end)
    end
    sleep(duration or 0.08)
end

-- ============================================
-- TELA DE INICIALIZACAO
-- ============================================

term.clear()
term.setCursorPos(1, 1)

if monitor then
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)

    local w = monitor.getSize()

    if w >= 80 then
        monitor.setTextScale(0.5)
    elseif w >= 50 then
        monitor.setTextScale(0.75)
    else
        monitor.setTextScale(1)
    end

    monitor.clear()

    local mw, mh = monitor.getSize()

    local titulo = "CCLinux 1.7"
    local texto = "INICIALIZANDO..."

    monitor.setCursorPos(
        math.max(1, math.floor((mw - #titulo) / 2) + 1),
        math.max(1, math.floor(mh / 2) - 1)
    )
    monitor.write(titulo)

    monitor.setCursorPos(
        math.max(1, math.floor((mw - #texto) / 2) + 1),
        math.max(1, math.floor(mh / 2) + 1)
    )
    monitor.write(texto)
end

print("======================================")
print("             CCLinux 1.7")
print("======================================")
print("")
print("Inicializando...")
print("")

-- ============================================
-- BARRA DE CARREGAMENTO
-- SOMENTE NO COMPUTADOR
-- ============================================

local total = 30

for i = 0, total do

    local porcentagem =
        math.floor((i / total) * 100)

    local preenchido =
        math.floor((i / total) * 30)

    term.setCursorPos(1, 7)

    term.write(
        "[" ..
        string.rep("#", preenchido) ..
        string.rep("-", 30 - preenchido) ..
        "] " ..
        porcentagem ..
        "%"
    )

    if i % 5 == 0 then
        beep(12 + math.floor(i / 5))
    end

    sleep(0.04)
end

print("")
print("")
print("Inicializacao concluida!")

beep(24)
sleep(0.2)
beep(24)

-- ============================================
-- MONITOR PRONTO
-- ============================================

if monitor then

    monitor.clear()

    local w, h = monitor.getSize()

    local titulo = "CCLinux 1.7"
    local texto = "Sistema iniciado!"

    monitor.setCursorPos(
        math.max(1, math.floor((w - #titulo) / 2) + 1),
        math.max(1, math.floor(h / 2) - 1)
    )

    monitor.write(titulo)

    monitor.setCursorPos(
        math.max(1, math.floor((w - #texto) / 2) + 1),
        math.max(1, math.floor(h / 2) + 1)
    )

    monitor.write(texto)
end

sleep(1)

-- ============================================
-- INICIAR KERNEL
-- ============================================

if fs.exists("/cclinux/kernel.lua") then
    shell.run("/cclinux/kernel.lua")
else
    term.clear()
    term.setCursorPos(1, 1)

    print("ERRO: kernel.lua nao encontrado.")
    print("")
    print("CCLinux nao esta instalado corretamente.")
end