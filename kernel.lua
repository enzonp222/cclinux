-- ============================================
-- CCLinux 1.7 - KERNEL
-- ============================================

local BASE = "/cclinux"
local PERSONAL = BASE .. "/pasta pessoal"
local CONFIG = PERSONAL .. "/config.txt"

-- Cria a pasta pessoal na primeira inicializacao
if not fs.exists(PERSONAL) then
    fs.makeDir(PERSONAL)

    local f = fs.open(CONFIG, "w")
    f.writeLine("nome=usuario")
    f.writeLine("senha=")
    f.close()

    local info = fs.open(PERSONAL .. "/LEIA-ME.txt", "w")
    info.writeLine("Esta e a pasta pessoal do CCLinux.")
    info.writeLine("Seus arquivos pessoais podem ficar aqui.")
    info.close()
end

-- Carrega nome
local nome = "usuario"

if fs.exists(CONFIG) then
    local f = fs.open(CONFIG, "r")

    while true do
        local linha = f.readLine()

        if not linha then
            break
        end

        local n = string.match(linha, "^nome=(.*)$")

        if n then
            nome = n
        end
    end

    f.close()
end

-- Define label do computador
if os.getComputerLabel() == nil then
    os.setComputerLabel(nome)
end

-- Executa login
if fs.exists(BASE .. "/login.lua") then
    local ok, novoNome = pcall(function()
        return shell.run(BASE .. "/login.lua")
    end)
end

-- Inicia monitor em paralelo
local function iniciarMonitor()
    if fs.exists(BASE .. "/monitor.lua") then
        shell.run(BASE .. "/monitor.lua")
    end
end

-- Inicia shell
local function iniciarShell()
    if fs.exists(BASE .. "/shell.lua") then
        shell.run(BASE .. "/shell.lua")
    end
end

parallel.waitForAny(
    iniciarShell,
    iniciarMonitor
)