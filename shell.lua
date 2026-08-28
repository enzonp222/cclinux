-- ============================================
-- CCLinux 1.7 - SHELL
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"

local monitor =
    peripheral.find("monitor")

-- --------------------------------------------
-- NOME
-- --------------------------------------------

local function obterNome()

    local nome =
        os.getComputerLabel()

    if nome and nome ~= "" then
        return nome
    end

    return "usuario"
end

local nome =
    obterNome()

-- --------------------------------------------
-- MONITOR
-- --------------------------------------------

local function monitorClear()

    if not monitor then
        return
    end

    monitor.clear()
    monitor.setCursorPos(1, 1)
end

local function monitorPrint(texto)

    if not monitor then
        return
    end

    local w, h =
        monitor.getSize()

    local x, y =
        monitor.getCursorPos()

    -- Quebra de linha quando chega
    -- ao final da tela.

    if y > h then
        monitorClear()
        x = 1
        y = 1
    end

    monitor.setCursorPos(x, y)
    monitor.write(
        tostring(texto)
    )

    monitor.setCursorPos(
        1,
        y + 1
    )
end

local function ambos(texto)

    print(texto)

    monitorPrint(texto)

end

-- --------------------------------------------
-- HELP
-- --------------------------------------------

local function help()

    print("")
    print("help       - Mostra a lista de comandos")
    print("ls         - Mostra os arquivos")
    print("cd NOME    - Entra em uma pasta")
    print("cd ..      - Volta para a pasta anterior")
    print("mkdir NOME - Cria uma pasta")
    print("clear      - Limpa a tela")
    print("echo TEXTO - Mostra um texto")
    print("reboot     - Reinicia o computador")
    print("shutdown   - Desliga o computador")
    print("password   - Altera o codigo")
    print("resetpessoal - Reinicia a pasta pessoal")
    print("floppy     - Mostra comandos do floppy")
    print("floppy_ls  - Lista o floppy")
    print("floppy_copy - Copia arquivo do floppy")
    print("install_cclinux - Instala o CCLinux")

    if monitor then

        monitorClear()

        monitorPrint(
            "CCLinux 1.7 - HELP"
        )

        monitorPrint(
            "--------------------------------"
        )

        monitorPrint(
            "help - Mostra a lista de comandos"
        )

        monitorPrint(
            "ls - Mostra os arquivos"
        )

        monitorPrint(
            "cd NOME - Entra em uma pasta"
        )

        monitorPrint(
            "cd .. - Volta uma pasta"
        )

        monitorPrint(
            "mkdir NOME - Cria uma pasta"
        )

        monitorPrint(
            "clear - Limpa a tela"
        )

        monitorPrint(
            "echo TEXTO - Mostra um texto"
        )

        monitorPrint(
            "reboot - Reinicia"
        )

        monitorPrint(
            "shutdown - Desliga"
        )

        monitorPrint(
            "password - Altera o codigo"
        )

        monitorPrint(
            "resetpessoal - Reinicia pasta pessoal"
        )

        monitorPrint(
            "floppy - Comandos do floppy"
        )

        monitorPrint(
            "floppy_ls - Lista o floppy"
        )

        monitorPrint(
            "floppy_copy - Copia arquivo"
        )

        monitorPrint(
            "install_cclinux - Instala o CCLinux"
        )
    end
end

-- --------------------------------------------
-- PASSWORD
-- --------------------------------------------

local function mudarSenha()

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

    local f =
        fs.open(config, "w")

    f.writeLine(
        "nome=" .. nome
    )

    f.writeLine(
        "senha=" .. novo
    )

    f.close()

    print("Codigo alterado.")
end

-- --------------------------------------------
-- RESET PESSOAL
-- --------------------------------------------

local function resetPessoal()

    print("ATENCAO!")
    print("Isso apaga a pasta pessoal.")
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

    print("Pasta pessoal reiniciada.")
end

-- --------------------------------------------
-- SL
-- --------------------------------------------

local function sl()

    term.clear()
    term.setCursorPos(1, 1)

    local largura, altura =
        term.getSize()

    local trem = {
        "      ====        ________",
        "  _D _|  |_______/        \\",
        " |   _     |                |",
        "'-(_)---(_)--(_)------------'"
    }

    local inicio =
        largura + 5

    for pos = inicio, -30, -1 do

        term.clear()

        for i, linha in ipairs(trem) do

            local x =
                pos

            local y =
                math.floor(
                    altura / 2
                ) + i - 2

            if x < largura + 1
            and y >= 1
            and y <= altura then

                term.setCursorPos(
                    x,
                    y
                )

                term.write(linha)
            end
        end

        sleep(0.06)
    end

    term.clear()
    term.setCursorPos(1, 1)
end

-- --------------------------------------------
-- /DOOM
-- --------------------------------------------

local function doom()

    term.clear()
    term.setCursorPos(1, 1)

    print("======================================")
    print("                DOOM ")
    print("======================================")
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

-- --------------------------------------------
-- LOOP
-- --------------------------------------------

while true do

    write(
        nome .. ":~$ "
    )

    local entrada =
        read()

    -- ----------------------------------------
    -- SOMENTE AGORA vai para o monitor
    -- ----------------------------------------

    if monitor then

        monitorPrint(
            nome .. ":~$ " .. entrada
        )

    end

    -- ----------------------------------------
    -- HELP
    -- ----------------------------------------

    if entrada == "help" then

        help()

    -- ----------------------------------------
    -- LS
    -- ----------------------------------------

    elseif entrada == "ls" then

        local diretorio =
            shell.dir()

        local arquivos =
            fs.list(diretorio)

        for _, arquivo in ipairs(
            arquivos
        ) do

            ambos(arquivo)
        end

    -- ----------------------------------------
    -- CD
    -- ----------------------------------------

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

            shell.setDir(
                fs.getDir(
                    shell.dir()
                )
            )

        elseif fs.exists(destino)
        and fs.isDir(destino) then

            shell.setDir(destino)

        else

            ambos(
                "Pasta nao encontrada."
            )
        end

    -- ----------------------------------------
    -- MKDIR
    -- ----------------------------------------

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

    -- ----------------------------------------
    -- CLEAR
    -- ----------------------------------------

    elseif entrada == "clear" then

        term.clear()
        term.setCursorPos(1, 1)

        monitorClear()

    -- ----------------------------------------
    -- ECHO
    -- ----------------------------------------

    elseif string.sub(
        entrada,
        1,
        5
    ) == "echo " then

        ambos(
            string.sub(
                entrada,
                6
            )
        )

    -- ----------------------------------------
    -- REBOOT
    -- ----------------------------------------

    elseif entrada == "reboot" then

        ambos(
            "Reiniciando..."
        )

        sleep(1)

        os.reboot()

    -- ----------------------------------------
    -- SHUTDOWN
    -- ----------------------------------------

    elseif entrada == "shutdown" then

        ambos(
            "Desligando..."
        )

        sleep(1)

        os.shutdown()

    -- ----------------------------------------
    -- PASSWORD
    -- ----------------------------------------

    elseif entrada == "password" then

        mudarSenha()

    -- ----------------------------------------
    -- RESET
    -- ----------------------------------------

    elseif entrada == "resetpessoal" then

        resetPessoal()

    -- ----------------------------------------
    -- FLOPPY
    -- ----------------------------------------

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

    -- ----------------------------------------
    -- INSTALADOR
    -- ----------------------------------------

    elseif entrada == "install_cclinux" then

        ambos(
            "Instalador CCLinux ainda nao configurado."
        )

    -- ----------------------------------------
    -- COMANDO SECRETO: SL
    -- ----------------------------------------

    elseif entrada == "sl" then

        sl()

    -- ----------------------------------------
    -- COMANDO SECRETO: DOOM
    -- ----------------------------------------

    elseif entrada == "/doom" then

        doom()

    -- ----------------------------------------
    -- DESCONHECIDO
    -- ----------------------------------------

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