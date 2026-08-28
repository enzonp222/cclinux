-- ============================================
-- CCLinux 1.7 - LOGIN
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"
local CONFIG = PERSONAL .. "/config.txt"

if not fs.exists(PERSONAL) then
    fs.makeDir(PERSONAL)
end

-- Le configuracao
local nome = nil
local senha = nil

if fs.exists(CONFIG) then
    local f = fs.open(CONFIG, "r")

    while true do
        local linha = f.readLine()

        if not linha then
            break
        end

        local n = string.match(linha, "^nome=(.*)$")
        local s = string.match(linha, "^senha=(.*)$")

        if n then
            nome = n
        end

        if s then
            senha = s
        end
    end

    f.close()
end

-- Primeira inicializacao
if not nome or nome == "" or nome == "usuario" then

    term.clear()
    term.setCursorPos(1, 1)

    print("======================================")
    print("          PRIMEIRA INICIALIZACAO")
    print("======================================")
    print("")
    print("Vamos configurar sua conta.")
    print("")

    write("Digite seu nome: ")
    nome = read()

    if nome == "" then
        nome = "usuario"
    end

    print("")
    write("Digite uma senha: ")
    senha = read("*")

    local f = fs.open(CONFIG, "w")
    f.writeLine("nome=" .. nome)
    f.writeLine("senha=" .. senha)
    f.close()

    os.setComputerLabel(nome)

    print("")
    print("Conta criada!")
    sleep(1)

    return
end

-- Login
term.clear()
term.setCursorPos(1, 1)

print("======================================")
print("             CCLinux 1.7")
print("======================================")
print("")
print("Usuario: " .. nome)
print("")

if senha and senha ~= "" then

    write("Senha: ")
    local tentativa = read("*")

    if tentativa ~= senha then
        print("")
        print("Senha incorreta.")
        sleep(2)
        os.reboot()
    end
end

os.setComputerLabel(nome)

term.clear()
term.setCursorPos(1, 1)