-- ============================================
-- CCLinux 1.7
-- INSTALLER
-- ============================================

local BASE_URL =
    "https://raw.githubusercontent.com/enzonp222/cclinux/refs/heads/main/"

local arquivos = {
    "startup.lua",
    "floppy.lua",
    "kernel.lua",
    "login.lua",
    "monitor.lua",
    "shell.lua"
}

local SISTEMA =
    "/cclinux"

-- ============================================
-- HTTP
-- ============================================

if not http then

    print("ERRO!")
    print("")
    print("HTTP nao esta habilitado.")
    print("")
    print("Ative HTTP nas configuracoes")
    print("do ComputerCraft.")

    return
end

-- ============================================
-- TELA
-- ============================================

term.clear()
term.setCursorPos(1, 1)

print("======================================")
print("       CCLinux 1.7 Installer")
print("======================================")
print("")
print("Baixando CCLinux do GitHub...")
print("")

-- ============================================
-- CRIAR PASTA
-- ============================================

if fs.exists(SISTEMA) then

    print("Pasta /cclinux encontrada.")
    print("")
    print("Atualizando arquivos...")
    print("")

else

    fs.makeDir(SISTEMA)

end

-- ============================================
-- BAIXAR
-- ============================================

for i, arquivo in ipairs(arquivos) do

    print(
        "[" ..
        i ..
        "/" ..
        #arquivos ..
        "] " ..
        arquivo
    )

    local url =
        BASE_URL .. arquivo

    local resposta, erro =
        http.get(url)

    if not resposta then

        print("")
        print(
            "ERRO ao baixar " ..
            arquivo
        )

        if erro then
            print(erro)
        end

        print("")
        print("Instalacao cancelada.")

        return
    end

    local conteudo =
        resposta.readAll()

    resposta.close()

    local destino

    if arquivo == "startup.lua" then

        destino =
            "/startup.lua"

    else

        destino =
            SISTEMA ..
            "/" ..
            arquivo
    end

    local f =
        fs.open(
            destino,
            "w"
        )

    if not f then

        print("")
        print(
            "ERRO ao salvar " ..
            destino
        )

        return
    end

    f.write(conteudo)
    f.close()

    print("OK")
end

-- ============================================
-- FINAL
-- ============================================

print("")
print("======================================")
print("        CCLinux instalado!")
print("======================================")
print("")
print("O computador sera reiniciado.")
print("")

sleep(3)

os.reboot()