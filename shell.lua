-- ==========================================
-- CCLinux 1.6 - SHELL
-- ==========================================

local nome =
    ...

if not nome then
    nome = "Usuario"
end

local CCLINUX =
    "/cclinux"

-- ==========================================
-- CARREGAR MODULOS
-- ==========================================

local monitorModule =
    dofile(
        CCLINUX ..
        "/monitor.lua"
    )

local floppyModule =
    dofile(
        CCLINUX ..
        "/floppy.lua"
    )

local loginModule =
    dofile(
        CCLINUX ..
        "/login.lua"
    )

-- ==========================================
-- DIRETORIO
-- ==========================================

local currentDir = "/"

-- ==========================================
-- PROMPT
-- ==========================================

local function prompt()

    if currentDir == "/" then

        return nome ..
            ":~$ "

    else

        return nome ..
            ":~" ..
            currentDir ..
            "$ "

    end

end

-- ==========================================
-- MONITOR + TERMINAL
-- ==========================================

local function readCommand()

    local texto =
        prompt()

    -- Prompt aparece imediatamente
    -- no monitor.

    term.write(texto)

    monitorModule.write(
        texto
    )

    -- A pessoa digita normalmente
    -- no terminal.

    local entrada =
        read()

    -- Só depois de ENTER a entrada
    -- aparece no monitor.

    monitorModule.print(
        entrada
    )

    return entrada

end

-- ==========================================
-- PRINT NOS DOIS
-- ==========================================

local function printBoth(
    texto
)

    print(texto)

    monitorModule.print(
        texto
    )

end

-- ==========================================
-- CLEAR
-- ==========================================

local function clear()

    term.clear()
    term.setCursorPos(
        1,
        1
    )

    monitorModule.clear()

end

-- ==========================================
-- LS
-- ==========================================

local function commandLS()

    local caminho =
        currentDir

    if caminho == "/" then
        caminho = ""
    end

    local arquivos =
        fs.list(caminho)

    for _, arquivo in ipairs(
        arquivos
    ) do

        local caminhoCompleto =
            fs.combine(
                caminho,
                arquivo
            )

        if fs.isDir(
            caminhoCompleto
        ) then

            printBoth(
                "[DIR] " ..
                arquivo
            )

        else

            printBoth(
                "      " ..
                arquivo
            )

        end

    end

end

-- ==========================================
-- CD
-- ==========================================

local function commandCD(
    destino
)

    if not destino then

        printBoth(
            "Uso: cd NOME"
        )

        return

    end

    local novoCaminho

    if destino == ".." then

        if currentDir == "/" then

            novoCaminho = "/"

        else

            novoCaminho =
                fs.getDir(
                    currentDir
                )

            if novoCaminho == "" then
                novoCaminho = "/"
            end

        end

    else

        novoCaminho =
            fs.combine(
                currentDir,
                destino
            )

    end

    if fs.isDir(
        novoCaminho
    ) then

        if novoCaminho == "" then
            novoCaminho = "/"
        end

        currentDir =
            "/" ..
            fs.combine(
                "",
                novoCaminho
            )

        currentDir =
            currentDir:gsub(
                "//",
                "/"
            )

        if currentDir == "" then
            currentDir = "/"
        end

    else

        printBoth(
            "Diretorio nao encontrado."
        )

    end

end

-- ==========================================
-- MKDIR
-- ==========================================

local function commandMkdir(
    nomePasta
)

    if not nomePasta then

        printBoth(
            "Uso: mkdir NOME"
        )

        return

    end

    local caminho =
        fs.combine(
            currentDir,
            nomePasta
        )

    if fs.exists(caminho) then

        printBoth(
            "Esse arquivo ou pasta ja existe."
        )

        return

    end

    fs.makeDir(caminho)

    printBoth(
        "Pasta criada: " ..
        nomePasta
    )

end

-- ==========================================
-- ECHO
-- ==========================================

local function commandEcho(
    comando
)

    local texto =
        comando:sub(6)

    printBoth(texto)

end

-- ==========================================
-- HELP
-- ==========================================

local function commandHelp()

    printBoth("")
    printBoth("CCLinux 1.6 - Comandos")
    printBoth("-----------------------")
    printBoth("help")
    printBoth("ls")
    printBoth("cd NOME")
    printBoth("cd ..")
    printBoth("mkdir NOME")
    printBoth("clear")
    printBoth("echo TEXTO")
    printBoth("reboot")
    printBoth("shutdown")
    printBoth("passwd")
    printBoth("resetpessoal")
    printBoth("")
    printBoth("floppy")
    printBoth("floppy_ls")
    printBoth("floppy_copy ARQUIVO")
    printBoth("instalar_cclinux")
    printBoth("")

end

-- ==========================================
-- SENHA
-- ==========================================

local function commandPasswd()

    local arquivo =
        fs.open(
            "/pasta pessoal/codigo",
            "r"
        )

    if not arquivo then

        printBoth(
            "Codigo nao encontrado."
        )

        return

    end

    local atualCorreto =
        arquivo.readAll()

    arquivo.close()

    term.write(
        "Codigo atual: "
    )

    local atual =
        read("*")

    if atual ~= atualCorreto then

        printBoth(
            "Codigo incorreto."
        )

        return

    end

    term.write(
        "Novo codigo: "
    )

    local novo1 =
        read("*")

    term.write(
        "Confirme: "
    )

    local novo2 =
        read("*")

    if novo1 == "" then

        printBoth(
            "O codigo nao pode estar vazio."
        )

        return

    end

    if novo1 ~= novo2 then

        printBoth(
            "Os codigos nao sao iguais."
        )

        return

    end

    local novoArquivo =
        fs.open(
            "/pasta pessoal/codigo",
            "w"
        )

    novoArquivo.write(
        novo1
    )

    novoArquivo.close()

    printBoth(
        "Codigo alterado!"
    )

end

-- ==========================================
-- EXECUTAR COMANDOS
-- ==========================================

while true do

    local comando =
        readCommand()

    local args = {}

    for palavra in string.gmatch(
        comando,
        "%S+"
    ) do

        table.insert(
            args,
            palavra
        )

    end

    local cmd =
        args[1]

    -- ======================================
    -- HELP
    -- ======================================

    if cmd == "help" then

        commandHelp()

    -- ======================================
    -- LS
    -- ======================================

    elseif cmd == "ls" then

        commandLS()

    -- ======================================
    -- CD
    -- ======================================

    elseif cmd == "cd" then

        commandCD(
            args[2]
        )

    -- ======================================
    -- MKDIR
    -- ======================================

    elseif cmd == "mkdir" then

        commandMkdir(
            args[2]
        )

    -- ======================================
    -- CLEAR
    -- ======================================

    elseif cmd == "clear" then

        clear()

    -- ======================================
    -- ECHO
    -- ======================================

    elseif cmd == "echo" then

        commandEcho(
            comando
        )

    -- ======================================
    -- REBOOT
    -- ======================================

    elseif cmd == "reboot" then

        printBoth(
            "Reiniciando..."
        )

        monitorModule.beep(
            8,
            0.7
        )

        sleep(1)

        os.reboot()

    -- ======================================
    -- SHUTDOWN
    -- ======================================

    elseif cmd == "shutdown" then

        printBoth(
            "Desligando..."
        )

        monitorModule.beep(
            5,
            0.7
        )

        sleep(1)

        os.shutdown()

    -- ======================================
    -- PASSWORD
    -- ======================================

    elseif cmd == "passwd" then

        commandPasswd()

    -- ======================================
    -- RESET PESSOAL
    -- ======================================

    elseif cmd == "resetpessoal" then

        loginModule.reset()

    -- ======================================
    -- FLOPPY
    -- ======================================

    elseif cmd == "floppy" then

        floppyModule.info()

    -- ======================================
    -- FLOPPY LS
    -- ======================================

    elseif cmd == "floppy_ls" then

        floppyModule.list()

    -- ======================================
    -- FLOPPY COPY
    -- ======================================

    elseif cmd == "floppy_copy" then

        floppyModule.copyToFloppy(
            args[2]
        )

    -- ======================================
    -- INSTALAR CCLINUX
    -- ======================================

    elseif cmd == "instalar_cclinux" then

        floppyModule.install()

    -- ======================================
    -- EXIT
    -- ======================================

    elseif cmd == "exit" then

        printBoth(
            "Use shutdown para desligar."
        )

    -- ======================================
    -- COMANDO VAZIO
    -- ======================================

    elseif cmd == "" then

        -- Não faz nada.

    -- ======================================
    -- COMANDO DESCONHECIDO
    -- ======================================

    else

        printBoth(
            "Comando nao encontrado: " ..
            tostring(cmd)
        )

    end

end