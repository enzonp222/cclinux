-- ============================================
-- CCLinux 1.7 - MAKEFLOPPY
-- Cria um floppy instalador do CCLinux
-- ============================================

local INSTALLER_URL =
    "https://raw.githubusercontent.com/enzonp222/cclinux/refs/heads/main/installer.lua"

-- ============================================
-- ENCONTRAR FLOPPY DRIVE
-- ============================================

local drive = nil

for _, nome in ipairs(peripheral.getNames()) do
    if peripheral.getType(nome) == "drive" then
        drive = nome
        break
    end
end

if not drive then
    print("ERRO: nenhum floppy drive encontrado.")
    return
end

local floppy = "/" .. drive

-- ============================================
-- VERIFICAR FLOPPY
-- ============================================

if not fs.exists(floppy) then
    print("ERRO: nenhum floppy inserido.")
    return
end

-- ============================================
-- VERIFICAR HTTP
-- ============================================

if not http then
    print("ERRO: HTTP nao esta habilitado.")
    return
end

term.clear()
term.setCursorPos(1, 1)

print("======================================")
print("       CCLinux 1.7 - MakeFloppy")
print("======================================")
print("")
print("Floppy encontrado: " .. drive)
print("")
print("Preparando floppy...")
print("")

-- ============================================
-- APAGAR CONTEUDO ANTIGO
-- ============================================

for _, arquivo in ipairs(fs.list(floppy)) do
    fs.delete(floppy .. "/" .. arquivo)
end

-- ============================================
-- BAIXAR INSTALLER
-- ============================================

print("Baixando installer.lua...")

local resposta, erro = http.get(INSTALLER_URL)

if not resposta then
    print("")
    print("ERRO: nao foi possivel baixar installer.lua.")

    if erro then
        print(erro)
    end

    return
end

local conteudo = resposta.readAll()
resposta.close()

-- ============================================
-- SALVAR NO FLOPPY
-- ============================================

local arquivo = fs.open(
    floppy .. "/installer.lua",
    "w"
)

arquivo.write(conteudo)
arquivo.close()

-- ============================================
-- FINAL
-- ============================================

print("")
print("======================================")
print("       FLOPPY PRONTO!")
print("======================================")
print("")
print("O floppy agora contem:")
print("")
print("installer.lua")
print("")
print("Coloque o floppy em outro computador")
print("e execute:")
print("")
print("installer")
print("")
print("O instalador baixara o CCLinux do GitHub.")