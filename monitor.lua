-- ==========================================
-- CCLinux 1.6 - MONITOR
-- ==========================================

local M = {}

local monitor = nil
local speaker = nil

-- ==========================================
-- PROCURAR PERIFERICOS
-- ==========================================

local function findDevices()

    monitor =
        peripheral.find("monitor")

    speaker =
        peripheral.find("speaker")

end

-- ==========================================
-- CONFIGURAR MONITOR
-- ==========================================

local function configure()

    if not monitor then
        return
    end

    local largura, altura =
        monitor.getSize()

    local escala

    if largura >= 80 then

        escala = 0.5

    elseif largura >= 50 then

        escala = 0.75

    elseif largura >= 30 then

        escala = 1

    else

        escala = 1.5

    end

    monitor.setTextScale(
        escala
    )

    monitor.setBackgroundColor(
        colors.black
    )

    monitor.setTextColor(
        colors.white
    )

    monitor.clear()

    monitor.setCursorPos(
        1,
        1
    )
end

-- ==========================================
-- BEEP
-- ==========================================

function M.beep(
    pitch,
    volume
)

    if speaker then

        speaker.playNote(
            "pling",
            volume or 1,
            pitch or 12
        )

    end
end

-- ==========================================
-- INICIALIZAR
-- ==========================================

function M.init()

    findDevices()
    configure()

end

-- ==========================================
-- LIMPAR MONITOR
-- ==========================================

function M.clear()

    if not monitor then
        return
    end

    monitor.clear()

    monitor.setCursorPos(
        1,
        1
    )

end

-- ==========================================
-- ESCREVER NO MONITOR
-- ==========================================

function M.write(text)

    if not monitor then
        return
    end

    monitor.write(
        text
    )

end

-- ==========================================
-- ESCREVER LINHA
-- ==========================================

function M.print(text)

    if not monitor then
        return
    end

    local _, y =
        monitor.getCursorPos()

    monitor.write(
        text
    )

    monitor.setCursorPos(
        1,
        y + 1
    )

end

-- ==========================================
-- BARRA DE INICIALIZACAO
-- ==========================================

function M.loading()

    term.clear()
    term.setCursorPos(
        1,
        1
    )

    -- Monitor permanece preto.

    if monitor then

        monitor.clear()

        monitor.setCursorPos(
            1,
            1
        )

    end

    print(
        "================================"
    )

    print(
        "          CCLinux 1.6"
    )

    print(
        "================================"
    )

    print()

    print(
        "Inicializando..."
    )

    M.beep(
        12,
        0.5
    )

    local total = 30

    for i = 0, total do

        local porcentagem =
            math.floor(
                (i / total) * 100
            )

        local blocos =
            math.floor(
                (i / total) * 20
            )

        local barra =
            "[" ..
            string.rep(
                "#",
                blocos
            ) ..
            string.rep(
                "-",
                20 - blocos
            ) ..
            "] " ..
            porcentagem ..
            "%"

        term.setCursorPos(
            1,
            7
        )

        term.write(
            barra
        )

        if i % 5 == 0 then

            M.beep(
                10 +
                math.floor(i / 5),
                0.3
            )

        end

        sleep(0.05)

    end

    print()

    print(
        "Sistema iniciado!"
    )

    M.beep(
        18,
        0.7
    )

    sleep(1)

end

-- ==========================================
-- EXPORTAR
-- ==========================================

return M