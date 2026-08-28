-- ============================================
-- CCLinux 1.7
-- STARTUP
-- ============================================

local monitor = peripheral.find("monitor")
local speaker = peripheral.find("speaker")

-- ============================================
-- FUNCAO DE SOM
-- ============================================

local function som(pitch, tempo)
    if speaker then
        pcall(function()
            speaker.playNote("harp", 1, pitch)
        end)
    end

    sleep(tempo or 0.08)
end

-- ============================================
-- TELA DE INICIALIZACAO DO MONITOR
-- ============================================

local function monitorStartup()

    if not monitor then
        return
    end

    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)

    -- Tamanho automatico apenas na inicializacao
    local w, h = monitor.getSize()

    if w >= 80 then
        monitor.setTextScale(1.5)
    elseif w >= 50 then
        monitor.setTextScale(1)
    elseif w >= 30 then
        monitor.setTextScale(0.5)
    else
        monitor.setTextScale(0.5)
    end

    monitor.clear()

    local titulo = "CCLinux 1.7"
    local texto = "Inicializando..."

    local x1 = math.max(1, math.floor((w - #titulo) / 2) + 1)
    local x2 = math.max(1, math.floor((w - #texto) / 2) + 1)

    monitor.setCursorPos(x1, 2)
    monitor.write(titulo)

    if h >= 4 then
        monitor.setCursorPos(x2, 4)
        monitor.write(texto)
    end
end

-- ============================================
-- TELA FINAL DO MONITOR
-- ============================================

local function monitorPronto()

    if not monitor then
        return
    end

    local w, h = monitor.getSize()

    monitor.clear()

    local titulo = "CCLinux 1.7"
    local texto = "Sistema iniciado!"

    local x1 = math.max(1, math.floor((w - #titulo) / 2) + 1)
    local x2 = math.max(1, math.floor((w - #texto) / 2) + 1)

    monitor.setCursorPos(x1, 2)

    monitor.write(titulo)

    if h >= 4 then
        monitor.setCursorPos(x2, 4)
        monitor.write(texto)
    end
end

-- ============================================
-- TERMINAL
-- ============================================

term.clear()
term.setCursorPos(1, 1)

monitorStartup()

print("======================================")
print("             CCLinux 1.7")
print("======================================")
print("")
print("Inicializando...")
print("")

-- ============================================
-- BARRA DE CARREGAMENTO
-- SOMENTE NO TERMINAL
-- ============================================

local total = 30

for i = 0, total do

    local porcentagem =
        math.floor((i / total) * 100)

    local preenchido =
        math.floor((i / total) * 30)

    local vazio =
        30 - preenchido

    term.setCursorPos(1, 7)

    term.write("[")

    term.write(
        string.rep("#", preenchido)
    )

    term.write(
        string.rep("-", vazio)
    )

    term.write(
        "] " .. porcentagem .. "%"
    )

    if i == 5 then
        som(12)
    elseif i == 10 then
        som(14)
    elseif i == 15 then
        som(16)
    elseif i == 20 then
        som(18)
    elseif i == 25 then
        som(20)
    elseif i == 30 then
        som(24, 0.15)
    else
        sleep(0.03)
    end
end

print("")
print("")
print("Sistema iniciado!")

som(24)
som(20)
som(24, 0.15)

monitorPronto()

sleep(1)

-- ============================================
-- INICIAR KERNEL
-- ============================================

if not fs.exists("/cclinux/kernel.lua") then

    term.clear()
    term.setCursorPos(1, 1)

    print("ERRO!")
    print("")
    print("kernel.lua não foi encontrado.")
    print("")
    print("O CCLinux não esta instalado corretamente.")

    return
end