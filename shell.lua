-- ============================================
-- CCLinux 1.7
-- SHELL
-- ============================================

local BASE = "/cclinux"

local PERSONAL =
    BASE .. "/pasta pessoal"

-- ============================================
-- MONITOR
-- ============================================

local monitor = nil

if fs.exists(
    BASE .. "/monitor.lua"
) then

    local ok, resultado =
        pcall(function()
            return dofile(
                BASE .. "/monitor.lua"
            )
        end)

    if ok then
        monitor = resultado
    end
end

-- ============================================
-- NOME
-- ============================================

local nome =
    os.getComputerLabel()

if not nome or nome == "" then
    nome = "usuario"
end

-- ============================================
-- MONITOR
-- ============================================

local function monitorPrint(texto)

    if monitor then
        monitor.write(
            tostring(texto)
        )
    end
end

local function monitorClear()

    if monitor then
        monitor.clear()
    end
end

-- ============================================
-- ESCREVER NOS DOIS
-- ============================================

local function ambos(texto)

    print(texto)
    monitorPrint(texto)

end

-- ============================================
-- HELP
-- ============================================

local function help()

    print("")
    print("CCLinux 1.7")
    print("")

    print(
        "help       - mostra a lista de comandos"
    )

    print(
        "ls         - mostra os arquivos"
    )

    print(
        "cd NOME    - entra em uma pasta"
    )

    print(
        "cd ..      - volta uma pasta"
    )

    print(
        "mkdir NOME - cria uma pasta"
    )

    print(
        "clear      - limpa as telas"
    )

    print(
        "echo TEXTO - mostra um texto"
    )

    print(
        "reboot     - reinicia o computador"
    )

    print(
        "shutdown   - desliga o computador"
    )

    print(
        "password   - altera o codigo"
    )

    print(
        "resetpessoal - reinicia a pasta pessoal"
    )

    print(
        "floppy     - mostra comandos do floppy"
    )

    print(
        "floppy_ls  - mostra o floppy"
    )

    print(
        "floppy_copy - copia arquivo do floppy"
    )

    print(
        "makefloppy - cria floppy instalador"
    )

    print("")
end

-- ============================================
-- ALTERAR SENHA
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

-- ============================================
-- RESET DA PASTA PESSOAL
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

    print("Pasta pessoal reiniciada.")

    print("O computador sera reiniciado.")

    sleep(2)

    os.reboot()
end

-- ============================================
-- SL
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

    for pos = w + 5, -25, -1 do

        term.clear()

        for i, linha in ipairs(trem) do

            local y =
                math.floor(h / 2)
                + i - 2

            local x = pos

            if y >= 1 and y <= h then

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

-- ============================================
-- DOOM MEME
-- ============================================

local function doom()

    term.clear()
    term.setCursorPos(1, 1)

    print("================================")
    print("             DOOM ")
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

    write(
        nome .. ":~$ "
    )

    -- O monitor NAO recebe nada ainda.
    -- Somente depois do ENTER.

    local entrada =
        read()

    -- ========================================
    -- ENVIAR COMANDO AO MONITOR
    -- ========================================

    monitorPrint(
        nome .. ":~$ " .. entrada
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

        monitorClear()

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
    -- COMANDO ESCONDIDO
    -- ========================================

    elseif entrada == "sl" then

        sl()

    -- ========================================
    -- COMANDO ESCONDIDO
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