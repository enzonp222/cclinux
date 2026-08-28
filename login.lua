-- ============================================
-- CCLinux 1.7
-- LOGIN
-- ============================================

local PERSONAL =
    "/cclinux/pasta pessoal"

local CONFIG =
    PERSONAL .. "/config.txt"

-- ============================================
-- GARANTIR PASTA
-- ============================================

if not fs.exists(PERSONAL) then
    fs.makeDir(PERSONAL)
end

-- ============================================
-- PRIMEIRA CONFIGURACAO
-- ============================================

local nome = nil
local senha = nil

if fs.exists(CONFIG) then

    local f = fs.open(CONFIG, "r")

    while true do

        local linha = f.readLine()

        if not linha then
            break
        end

        local n =
            string.match(
                linha,
                "^nome=(.*)$"
            )

        local s =
            string.match(
                linha,
                "^senha=(.*)$"
            )

        if n then
            nome = n
        end

        if s then
            senha = s
        end
    end

    f.close()
end

-- ============================================
-- PRIMEIRA VEZ
-- ============================================

if not nome
or nome == ""
or nome == "usuario" then

    term.clear()
    term.setCursorPos(1, 1)

    print("======================================")
    print("           CONFIGURACãO")
    print("======================================")
    print("")

    write("Nome: ")

    nome = read()

    if nome == "" then
        nome = "usuario"
    end

    print("")

    write("Codigo: ")

    senha = read("*")

    local f =
        fs.open(CONFIG, "w")

    f.writeLine(
        "nome=" .. nome
    )

    f.writeLine(
        "senha=" .. senha
    )

    f.close()

    os.setComputerLabel(nome)

    print("")
    print("Configuracao concluida!")

    sleep(1)

    return
end

-- ============================================
-- LOGIN NORMAL
-- ============================================

term.clear()
term.setCursorPos(1, 1)

print("======================================")
print("             CCLinux 1.7")
print("======================================")
print("")
print("Usuario: " .. nome)
print("")

if senha ~= "" then

    write("Codigo: ")

    local tentativa =
        read("*")

    if tentativa ~= senha then

        print("")
        print("Codigo incorreto.")

        sleep(2)

        os.reboot()
    end
end

os.setComputerLabel(nome)

term.clear()
term.setCursorPos(1, 1)