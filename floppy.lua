-- ============================================
-- CCLinux 1.7 - FLOPPY
-- ============================================

local function encontrarDrive()

    for _, nome in ipairs(
        peripheral.getNames()
    ) do

        if peripheral.getType(nome) == "drive" then
            return nome
        end

    end

    return nil
end

local args = {...}

local drive =
    encontrarDrive()

if not drive then

    print("Nenhum floppy drive encontrado.")
    return
end

-- --------------------------------------------
-- LISTAR
-- --------------------------------------------

if args[1] == "ls" then

    local caminho = "/" .. drive

    if not fs.exists(caminho) then
        print("Nenhum floppy inserido.")
        return
    end

    print("Arquivos do floppy:")

    local arquivos =
        fs.list(caminho)

    if #arquivos == 0 then
        print("  (vazio)")
        return
    end

    for _, arquivo in ipairs(arquivos) do
        print("  " .. arquivo)
    end

    return
end

-- --------------------------------------------
-- COPIAR
-- --------------------------------------------

if args[1] == "copy" then

    local origem = args[2]
    local destino = args[3]

    if not origem or not destino then
        print(
            "Uso: floppy_copy ARQUIVO DESTINO"
        )
        return
    end

    local arquivo =
        "/" .. drive .. "/" .. origem

    if not fs.exists(arquivo) then
        print("Arquivo nao encontrado no floppy.")
        return
    end

    fs.copy(
        arquivo,
        destino
    )

    print("Arquivo copiado.")

    return
end

-- --------------------------------------------
-- MENU
-- --------------------------------------------

print("Floppy:")
print("  floppy_ls")
print("  floppy_copy ARQUIVO DESTINO")