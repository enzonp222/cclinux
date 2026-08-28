-- ============================================
-- CCLinux 1.7 - MONITOR
-- ============================================

local monitor = peripheral.find("monitor")

-- Se nao houver monitor, nao faz nada.
if not monitor then
    return
end

monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

-- --------------------------------------------
-- TAMANHO AUTOMATICO
-- --------------------------------------------

local largura, altura =
    monitor.getSize()

local escala = 1

if largura >= 80 then
    escala = 1.5
elseif largura >= 50 then
    escala = 1
elseif largura >= 30 then
    escala = 0.5
else
    escala = 1
end

monitor.setTextScale(escala)

monitor.clear()
monitor.setCursorPos(1, 1)

-- --------------------------------------------
-- FUNCAO DE LIMPEZA
-- --------------------------------------------

local function limpar()
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- --------------------------------------------
-- TELA DO MONITOR
-- --------------------------------------------

local w, h =
    monitor.getSize()

local titulo = "CCLinux 1.7"

local x =
    math.max(
        1,
        math.floor(
            (w - #titulo) / 2
        ) + 1
    )

monitor.setCursorPos(x, 1)
monitor.write(titulo)

if h >= 3 then
    monitor.setCursorPos(1, 3)
    monitor.write(
        string.rep("-", w)
    )
end

if h >= 5 then

    local texto =
        "Terminal pronto."

    local tx =
        math.max(
            1,
            math.floor(
                (w - #texto) / 2
            ) + 1
        )

    monitor.setCursorPos(tx, 5)
    monitor.write(texto)
end

-- --------------------------------------------
-- O MONITOR FICA PARADO
-- --------------------------------------------
-- O shell escreve nele quando necessario.

while true do
    sleep(60)
end