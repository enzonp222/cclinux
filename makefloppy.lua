-- ============================================
-- CCLinux 1.7
-- MAKEFLOPPY
-- ============================================

local URL =
    "https://raw.githubusercontent.com/enzonp222/cclinux/refs/heads/main/installer.lua"

-- ============================================
-- PROCURAR DRIVE
-- ============================================

local drive = nil

for _, nome in ipairs(
    peripheral.getNames()
) do

    if peripheral.getType(nome) == "drive" then

        drive = nome

        break
    end
end

if not drive then

    print(
        "ERRO: nenhum floppy drive encontrado."
    )

    return
end

local disco =
    "/" .. drive

-- ============================================
-- VERIFICAR HTTP
-- ============================================

if not http then

    print(
        "ERRO: HTTP nao esta habilitado."
    )

    return
end

-- ============================================
-- INICIO
-- ============================================

term.clear()
term.setCursorPos(1, 1)

print("======================================")
print("       CCLinux 1.7 - MakeFloppy")
print("======================================")
print("")
print("Floppy: " .. drive)
print("")
print("Baixando installer.lua...")
print("")

-- ============================================
-- BAIXAR
-- ============================================

local resposta, erro =
    http.get(URL)

if not resposta then

    print(
        "ERRO ao baixar installer.lua."
    )

    if erro then
        print(erro)
    end

    return
end

local conteudo =
    resposta.readAll()

resposta.close()

-- ============================================
-- APAGAR CONTEUDO DO FLOPPY
-- ============================================

for _, arquivo in ipairs(
    fs.list(disco)
) do

    fs.delete(
        disco .. "/" .. arquivo
    )
end

-- ============================================
-- GRAVAR
-- ============================================

local f =
    fs.open(
        disco .. "/installer.lua",
        "w"
    )

if not f then

    print(
        "ERRO: nao foi possivel escrever no floppy."
    )

    return
end

f.write(conteudo)
f.close()

-- ============================================
-- FINAL
-- ============================================

print("")
print("======================================")
print("          FLOPPY PRONTO!")
print("======================================")
print("")
print("O disco contem:")
print("")
print("installer.lua")
print("")
print("No outro computador, execute:")
print("")
print("/disk/installer.lua")
print("")