-- ============================================
-- CCLinux 1.7 - STARTUP
-- ============================================

local BASE = "/cclinux"

local monitor = peripheral.find("monitor")
local speaker = peripheral.find("speaker")

-- --------------------------------------------
-- FUNCOES DE MONITOR
-- --------------------------------------------

local function monitorInit()
    if not monitor then
        return
    end

    monitor.setTextScale(1)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.clear()
    monitor.setCursorPos(1, 1)

    local w, h = monitor.getSize()

    local titulo = "CCLinux 1.7"
    local x = math.max(1, math.floor((w - #titulo) / 2) + 1)

    monitor.setCursorPos(x, 2)
    monitor.write(titulo)

    if h >= 4 then
        local texto = "Inicializando..."
        local tx = math.max(1, math.floor((w - #texto) / 2) + 1)

        monitor.setCursorPos(tx, 4)
        monitor.write(texto)
    end
end

local function monitorFinal()
    if not monitor then
        return
    end

    local w, h = monitor.getSize()

    monitor.clear()

    local titulo = "CCLinux 1.7"
    local x = math.max(1, math.floor((w - #titulo) / 2) + 1)

    monitor.setCursorPos(x, 2)
    monitor.write(titulo)

    if h >= 4 then
        local texto = "Sistema iniciado!"
        local tx = math.max(1, math.floor((w - #texto) / 2) + 1)

        monitor.setCursorPos(tx, 4)
        monitor.write(texto)
    end
end

-- --------------------------------------------
-- SOM
-- --------------------------------------------

local function som(pitch, tempo)
    if speaker then
        pcall(function()
            speaker.playNote("harp", 1, pitch)
        end)
    end

    sleep(tempo or 0.05)
end

-- --------------------------------------------
-- TELA INICIAL
-- --------------------------------------------

term.clear()
term.setCursorPos(1, 1)

monitorInit()

print("======================================")
print("             CCLinux 1.7")
print("======================================")
print("")
print("Inicializando...")
print("")

-- --------------------------------------------
-- BARRA
-- --------------------------------------------

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

    -- sons durante o carregamento
    if i == 5 then
        som(12, 0.05)
    elseif i == 10 then
        som(14, 0.05)
    elseif i == 15 then
        som(16, 0.05)
    elseif i == 20 then
        som(18, 0.05)
    elseif i == 25 then
        som(20, 0.05)
    elseif i == 30 then
        som(24, 0.15)
    else
        sleep(0.03)
    end
end

print("")
print("")
print("Sistema iniciado!")

som(24, 0.08)
som(20, 0.08)
som(24, 0.15)

monitorFinal()

sleep(1)

-- --------------------------------------------
-- VERIFICAR SISTEMA
-- --------------------------------------------

if not fs.exists(BASE) then

    term.clear()
    term.setCursorPos(1, 1)

    print("ERRO!")
    print("")
    print("A pasta /cclinux nao existe.")
    print("")
    print("Instale o sistema primeiro.")

    return
end

if not fs.exists(BASE .. "/kernel.lua") then

    term.clear()
    term.setCursorPos(1, 1)

    print("ERRO!")
    print("")
    print("kernel.lua nao encontrado.")

    return
end

shell.run(BASE .. "/kernel.lua")