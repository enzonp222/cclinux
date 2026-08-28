-- ============================================
-- CCLinux 1.7
-- MONITOR
-- ============================================

local M = {}

M.monitor =
    peripheral.find("monitor")

-- ============================================
-- CONFIGURAR
-- ============================================

function M.configurar()

    if not M.monitor then
        return false
    end

    M.monitor.setBackgroundColor(colors.black)
    M.monitor.setTextColor(colors.white)

    local w, h =
        M.monitor.getSize()

    if w >= 80 then
        M.monitor.setTextScale(1.5)
    elseif w >= 50 then
        M.monitor.setTextScale(1)
    else
        M.monitor.setTextScale(0.5)
    end

    M.monitor.clear()
    M.monitor.setCursorPos(1, 1)

    return true
end

-- ============================================
-- LIMPAR
-- ============================================

function M.clear()

    if not M.monitor then
        return
    end

    M.monitor.clear()
    M.monitor.setCursorPos(1, 1)
end

-- ============================================
-- ESCREVER
-- ============================================

function M.write(texto)

    if not M.monitor then
        return
    end

    local w, h =
        M.monitor.getSize()

    local x, y =
        M.monitor.getCursorPos()

    texto = tostring(texto)

    -- Quebrar textos grandes
    while #texto > w do

        M.monitor.setCursorPos(
            1,
            y
        )

        M.monitor.write(
            string.sub(
                texto,
                1,
                w
            )
        )

        texto =
            string.sub(
                texto,
                w + 1
            )

        y = y + 1

        if y > h then
            M.clear()
            y = 1
        end
    end

    if y > h then
        M.clear()
        y = 1
    end

    M.monitor.setCursorPos(
        1,
        y
    )

    M.monitor.write(texto)

    M.monitor.setCursorPos(
        1,
        y + 1
    )
end

-- ============================================
-- TEXTO CENTRALIZADO
-- ============================================

function M.center(texto, linha)

    if not M.monitor then
        return
    end

    local w =
        M.monitor.getSize()

    local x =
        math.max(
            1,
            math.floor(
                (w - #texto) / 2
            ) + 1
        )

    M.monitor.setCursorPos(
        x,
        linha
    )

    M.monitor.write(texto)
end

M.configurar()

return M