-- ============================================
-- CCLinux 1.7 - SHELL
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"

-- ============================================
-- MONITOR
-- ============================================

local monitor = peripheral.find("monitor")

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
    monitor.setCursorPos(1, 1)
end

-- ============================================
-- ESCREVER NO MONITOR
-- ============================================

local function monitorWrite(texto)

    if not monitor then
        return
    end

    texto = tostring(texto)

    local w, h = monitor.getSize()
    local x, y = monitor.getCursorPos()

    while #texto > w do

        monitor.setCursorPos(x, y)

        monitor.write(
            string.sub(texto, 1, w - x + 1)
        )

        texto = string.sub(
            texto,
            w - x + 2
        )

        x = 1
        y = y + 1

        if y > h then
            monitor.scroll(1)
            y = h
        end
    end

    if y > h then
        monitor.scroll(1)
        y = h
    end

    monitor.setCursorPos(x, y)
    monitor.write(texto)

    local nx = x + #texto

    if nx > w then
        nx = 1
        y = y + 1
    end

    if y > h then
        monitor.scroll(1)
        y = h
    end

    monitor.setCursorPos(nx, y)
end

-- ============================================
-- MONITOR PRINT
-- ============================================

local function monitorPrint(texto)

    if not monitor then
        return
    end

    monitorWrite(texto)

    local _, y =
        monitor.getCursorPos()

    monitor.setCursorPos(
        1,
        y + 1
    )
end

-- ============================================
-- TERMINAL + MONITOR
-- ============================================

local function ambos(texto)

    print(texto)
    monitorPrint(texto)

end

-- ============================================
-- NOME DO USUARIO
-- ============================================

local nome =
    os.getComputerLabel()

if not nome or nome == "" then
    nome = "usuario"
end

-- ============================================
-- HELP
-- ============================================

local function help()

    print("")
    print("CCLinux 1.7")
    print("")

    print("help       - mostra a lista de comandos")
    print("ls         - mostra os arquivos")
    print("cd NOME    - entra em uma pasta")
    print("cd ..      - volta uma pasta")
    print("mkdir NOME - cria uma pasta")
    print("clear      - limpa as telas")
    print("echo TEXTO - mostra um texto")
    print("reboot     - reinicia o computador")
    print("shutdown   - desliga o computador")
    print("password   - altera o codigo")
    print("resetpessoal - reinicia a pasta pessoal")
    print("floppy     - comandos do floppy")
    print("floppy_ls  - mostra o floppy")
    print("floppy_copy ARQUIVO DESTINO")
    print("makefloppy - cria floppy instalador")

    print("")
end

-- ============================================
-- ALTERAR CODIGO
-- ============================================

local function password()

    local config =
        PERSONAL .. "/config.txt"

    local senhaAtual = ""

    if fs.exists(config) then

        local f =
            fs.open(config, "r")

        while true do

            local linha =
                f.readLine()

            if not linha then
                break
            end

            local s =
                string.match(
                    linha,
                    "^senha=(.*)$"
                )

            if s then
                senhaAtual = s
            end
        end

        f.close()
    end

    if senhaAtual ~= "" then

        write("Codigo atual: ")

        local atual =
            read("*")

        if atual ~= senhaAtual then

            print("Codigo incorreto.")

            return
        end
    end

    write("Novo codigo: ")

    local novo =
        read("*")

    print("")

    write("Confirme o novo codigo: ")

    local confirmar =
        read("*")

    if novo ~= confirmar then

        print("")
        print("Os codigos nao sao iguais.")

        return
    end

    local f =
        fs.open(config, "w")

    f.writeLine(
        "nome=" .. nome
    )

    f.writeLine(
        "senha=" .. novo
    )

    f.close()

    print("")
    print("Codigo alterado.")
end

-- ============================================
-- RESETAR PASTA PESSOAL
-- ============================================

local function resetPessoal()

    print("")
    print("ATENCAO!")
    print("Isso vai apagar a pasta pessoal.")
    print("")

    write("Digite SIM para continuar: ")

    local resposta =
        read()

    if resposta ~= "SIM" then

        print("Cancelado.")

        return
    end

    if fs.exists(PERSONAL) then
        fs.delete(PERSONAL)
    end

    fs.makeDir(PERSONAL)

    local f =
        fs.open(
            PERSONAL .. "/config.txt",
            "w"
        )

    f.writeLine(
        "nome=" .. nome
    )

    f.writeLine(
        "senha="
    )

    f.close()

    print("")
    print("Pasta pessoal reiniciada.")
    print("O computador sera reiniciado.")

    sleep(2)

    os.reboot()
end

-- ============================================
-- SL
-- COMANDO ESCONDIDO
-- ============================================

local function sl()

    term.clear()
    term.setCursorPos(1, 1)

    local w, h =
        term.getSize()

    local trem = {
        "      ====        ________",
        "  _D _|  |_______/        \\",
        " |   _     |                |",
        "'-(_)---(_)--(_)------------'"
    }

    for pos = w + 5, -40, -1 do

        term.clear()

        for i, linha in ipairs(trem) do

            local y =
                math.floor(h / 2) + i - 2

            if y >= 1 and y <= h then

                term.setCursorPos(
                    pos,
                    y
                )

                term.write(linha)
            end
        end

        sleep(0.06)
    end

    term.clear()
    term.setCursorPos(1, 1)

    if monitor then
        monitor.clear()
        monitor.setCursorPos(1, 1)
    end
end

-- ============================================
-- DOOM
-- COMANDO ESCONDIDO
-- ============================================

local function doom()

    term.clear()
    term.setCursorPos(1, 1)

    print("================================")
    print("            DOOM ")
    print("================================")
    print("")
    print("1 - Atacar")
    print("2 - Procurar")
    print("3 - Sair")
    print("")

    while true do

        write("> ")

        local escolha =
            read()

        if escolha == "1" then

            print(
                "BANG! Inimigo imaginario derrotado."
            )

        elseif escolha == "2" then

            print(
                "Voce encontrou uma sala secreta."
            )

        elseif escolha == "3" then

            break

        else

            print("Opcao invalida.")

        end

        print("")
    end

    term.clear()
    term.setCursorPos(1, 1)
end

-- ============================================
-- LOOP PRINCIPAL
-- ============================================

while true do

    local prompt =
        nome .. ":~$ "

    -- Prompt no terminal
    write(prompt)

    -- A digitacao fica somente no terminal.
    -- O monitor recebe depois do ENTER.

    local entrada =
        read()

    -- Agora manda o comando para o monitor

    monitorPrint(
        prompt .. entrada
    )

    -- ========================================
    -- HELP
    -- ========================================

    if entrada == "help" then

        help()

    -- ========================================
    -- LS
    -- ========================================

    elseif entrada == "ls" then

        local arquivos =
            fs.list(
                shell.dir()
            )

        for _, arquivo in ipairs(arquivos) do

            ambos(arquivo)

        end

    -- ========================================
    -- CD
    -- ========================================

    elseif string.sub(
        entrada,
        1,
        3
    ) == "cd " then

        local destino =
            string.sub(
                entrada,
                4
            )

        if destino == ".." then

            local atual =
                shell.dir()

            local pai =
                fs.getDir(atual)

            shell.setDir(pai)

        elseif fs.exists(destino)
        and fs.isDir(destino) then

            shell.setDir(destino)

        else

            ambos(
                "Pasta nao encontrada."
            )

        end

    -- ========================================
    -- MKDIR
    -- ========================================

    elseif string.sub(
        entrada,
        1,
        6
    ) == "mkdir " then

        local pasta =
            string.sub(
                entrada,
                7
            )

        if fs.exists(pasta) then

            ambos(
                "Essa pasta ja existe."
            )

        else

            fs.makeDir(pasta)

            ambos(
                "Pasta criada."
            )

        end

    -- ========================================
    -- CLEAR
    -- ========================================

    elseif entrada == "clear" then

        term.clear()
        term.setCursorPos(1, 1)

        if monitor then

            monitor.clear()
            monitor.setCursorPos(1, 1)

        end

    -- ========================================
    -- ECHO
    -- ========================================

    elseif string.sub(
        entrada,
        1,
        5
    ) == "echo " then

        local texto =
            string.sub(
                entrada,
                6
            )

        ambos(texto)

    -- ========================================
    -- REBOOT
    -- ========================================

    elseif entrada == "reboot" then

        ambos("Reiniciando...")

        sleep(1)

        os.reboot()

    -- ========================================
    -- SHUTDOWN
    -- ========================================

    elseif entrada == "shutdown" then

        ambos("Desligando...")

        sleep(1)

        os.shutdown()

    -- ========================================
    -- PASSWORD
    -- ========================================

    elseif entrada == "password" then

        password()

    -- ========================================
    -- RESET PESSOAL
    -- ========================================

    elseif entrada == "resetpessoal" then

        resetPessoal()

    -- ========================================
    -- FLOPPY
    -- ========================================

    elseif entrada == "floppy" then

        shell.run(
            BASE .. "/floppy.lua"
        )

    elseif entrada == "floppy_ls" then

        shell.run(
            BASE .. "/floppy.lua",
            "ls"
        )

    elseif string.sub(
        entrada,
        1,
        12
    ) == "floppy_copy " then

        local resto =
            string.sub(
                entrada,
                13
            )

        local arquivo, destino =
            string.match(
                resto,
                "^(%S+)%s+(.+)$"
            )

        if arquivo and destino then

            shell.run(
                BASE .. "/floppy.lua",
                "copy",
                arquivo,
                destino
            )

        else

            ambos(
                "Uso: floppy_copy ARQUIVO DESTINO"
            )

        end

    -- ========================================
    -- MAKEFLOPPY
    -- ========================================

    elseif entrada == "makefloppy" then

        shell.run(
            BASE .. "/makefloppy.lua"
        )

    -- ========================================
    -- SL ESCONDIDO
    -- ========================================

    elseif entrada == "sl" then

        sl()

    -- ========================================
    -- DOOM ESCONDIDO
    -- ========================================

    elseif entrada == "/doom" then

        doom()

    -- ========================================
    -- COMANDO DESCONHECIDO
    -- ========================================

    else

        ambos(
            "Comando nao encontrado: " ..
            entrada
        )

        ambos(
            "Digite help para ver os comandos."
        )

    end
end