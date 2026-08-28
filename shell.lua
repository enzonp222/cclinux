-- ============================================
-- CCLinux 1.7 - SHELL
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"

local function obterNome()
    local label = os.getComputerLabel()

    if label and label ~= "" then
        return label
    end

    return "usuario"
end

local nome = obterNome()

-- ============================================
-- HELP
-- ============================================

local function help()
    print("")
    print("help       - Mostra a lista de comandos")
    print("ls         - Mostra os arquivos")
    print("cd NOME    - Entra em uma pasta")
    print("cd ..      - Volta para a pasta anterior")
    print("mkdir NOME - Cria uma nova pasta")
    print("clear      - Limpa o terminal")
    print("echo TEXTO - Mostra um texto")
    print("reboot     - Reinicia o computador")
    print("shutdown   - Desliga o computador")
    print("password   - Altera a senha")
    print("resetpessoal - Reinicia a pasta pessoal")
    print("floppy     - Mostra os comandos do floppy")
    print("floppy_ls  - Lista os arquivos do floppy")
    print("floppy_copy - Copia arquivo do floppy")
    print("install_cclinux - Instala o CCLinux")
end

-- ============================================
-- SENHA
-- ============================================

local function mudarSenha()

    local config = PERSONAL .. "/config.txt"
    local senhaAtual = ""

    if fs.exists(config) then
        local f = fs.open(config, "r")

        while true do
            local linha = f.readLine()

            if not linha then
                break
            end

            local s = string.match(linha, "^senha=(.*)$")

            if s then
                senhaAtual = s
            end
        end

        f.close()
    end

    if senhaAtual ~= "" then
        write("Senha atual: ")
        local atual = read("*")

        if atual ~= senhaAtual then
            print("Senha incorreta.")
            return
        end
    end

    write("Nova senha: ")
    local nova = read("*")

    local nomeAtual = obterNome()

    local f = fs.open(config, "w")
    f.writeLine("nome=" .. nomeAtual)
    f.writeLine("senha=" .. nova)
    f.close()

    print("Senha alterada.")
end

-- ============================================
-- RESET DA PASTA PESSOAL
-- ============================================

local function resetPessoal()

    print("ATENCAO!")
    print("Isso vai apagar a pasta pessoal.")
    write("Digite SIM para continuar: ")

    local resposta = read()

    if resposta ~= "SIM" then
        print("Cancelado.")
        return
    end

    if fs.exists(PERSONAL) then
        fs.delete(PERSONAL)
    end

    fs.makeDir(PERSONAL)

    local f = fs.open(PERSONAL .. "/config.txt", "w")
    f.writeLine("nome=" .. nome)
    f.writeLine("senha=")
    f.close()

    print("Pasta pessoal reiniciada.")
end

-- ============================================
-- SL - COMANDO ESCONDIDO
-- ============================================

local function sl()

    term.clear()
    term.setCursorPos(1, 1)

    local trem = {
        "      ====        ________",
        "  _D _|  |_______/        \\",
        " |   _     |                |",
        "'-(_)---(_)--(_)------------'"
    }

    local largura, altura = term.getSize()

    for pos = 1, largura + 5 do

        term.clear()

        for i, linha in ipairs(trem) do
            local y = math.floor(altura / 2) + i - 2

            if y >= 1 and y <= altura then
                term.setCursorPos(pos, y)
                term.write(linha)
            end
        end

        sleep(0.06)
    end

    term.clear()
end

-- ============================================
-- /DOOM - JOGO MEME
-- ============================================

local function doom()

    term.clear()
    term.setCursorPos(1, 1)

    print("======================================")
    print("                DOOM ")
    print("======================================")
    print("")
    print("Voce entrou no DOOM.")
    print("")
    print("[1] Atacar")
    print("[2] Procurar")
    print("[3] Sair")
    print("")

    while true do

        write("> ")
        local escolha = read()

        if escolha == "1" then
            print("BANG! Voce derrotou um inimigo imaginario.")
            print("")

        elseif escolha == "2" then
            print("Voce encontrou uma sala secreta.")
            print("")

        elseif escolha == "3" then
            break

        else
            print("Comando desconhecido.")
        end
    end

    term.clear()
end

-- ============================================
-- LOOP PRINCIPAL
-- ============================================

while true do

    write(nome .. ":~$ ")

    local entrada = read()

    if entrada == "" then

    elseif entrada == "help" then
        help()

    elseif entrada == "ls" then

        local diretorio = shell.dir()
        local arquivos = fs.list(diretorio)

        for _, arquivo in ipairs(arquivos) do
            print(arquivo)
        end

    elseif string.sub(entrada, 1, 3) == "cd " then

        local destino = string.sub(entrada, 4)

        if fs.exists(destino) and fs.isDir(destino) then
            shell.setDir(destino)
        else
            print("Pasta nao encontrada.")
        end

    elseif string.sub(entrada, 1, 6) == "mkdir " then

        local pasta = string.sub(entrada, 7)

        if fs.exists(pasta) then
            print("Essa pasta ja existe.")
        else
            fs.makeDir(pasta)
            print("Pasta criada.")
        end

    elseif entrada == "clear" then

        term.clear()
        term.setCursorPos(1, 1)

    elseif string.sub(entrada, 1, 5) == "echo " then

        print(string.sub(entrada, 6))

    elseif entrada == "reboot" then

        os.reboot()

    elseif entrada == "shutdown" then

        os.shutdown()

    elseif entrada == "password" then

        mudarSenha()

    elseif entrada == "resetpessoal" then

        resetPessoal()

    elseif entrada == "floppy" then

        shell.run(BASE .. "/floppy.lua")

    elseif entrada == "floppy_ls" then

        shell.run(BASE .. "/floppy.lua", "ls")

    elseif string.sub(entrada, 1, 12) == "floppy_copy " then

        local resto = string.sub(entrada, 13)
        local arquivo, destino = string.match(resto, "^(%S+)%s+(.+)$")

        if arquivo and destino then
            shell.run(BASE .. "/floppy.lua", "copy", arquivo, destino)
        else
            print("Uso: floppy_copy ARQUIVO DESTINO")
        end

    elseif entrada == "install_cclinux" then

        print("Para instalar o CCLinux pelo GitHub, use o instalador.")
        print("")

    -- ========================================
    -- COMANDOS ESCONDIDOS
    -- ========================================

    elseif entrada == "sl" then

        sl()

    elseif entrada == "/doom" then

        doom()

    else

        print("Comando nao encontrado: " .. entrada)
        print("Digite help para ver os comandos.")

    end
end