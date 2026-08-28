-- ============================================
-- CCLinux 1.7 - MONITOR
-- ============================================

local monitor = peripheral.find("monitor")

-- Se nao houver monitor, termina silenciosamente
if not monitor then
    return
end

-- Configura o monitor SOMENTE quando inicia
monitor.setTextScale(1)

local largura, altura = monitor.getSize()

monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

-- Centraliza texto
local function centralizar(texto, y)
    local x = math.floor((largura - #texto) / 2) + 1

    if x < 1 then
        x = 1
    end

    monitor.setCursorPos(x, y)
    monitor.write(texto)
end

centralizar("CCLinux 1.7", 1)

if altura >= 3 then
    monitor.setCursorPos(1, 3)
    monitor.write(string.rep("-", largura))
end

if altura >= 5 then
    centralizar("MONITOR ONLINE", 5)
end

if altura >= 7 then
    centralizar("Sistema operacional", 7)
end

if altura >= 9 then
    centralizar("Monitor detectado", 9)
end

-- Mantem o monitor ativo.
-- Ele nao interfere no teclado/terminal.
while true do
    sleep(60)
end