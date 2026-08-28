-- ============================================
-- CCLinux 1.7
-- FLOPPY
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

local disco =
    "/" .. drive

-- ============================================
-- LISTAR
-- ============================================

if args[1] == "ls" then

    print("Floppy: " .. drive)
    print("")

    local arquivos =
        fs.list(disco)

    if #arquivos == 0 then

        print("(vazio)")

        return
    end

    for _, arquivo in ipairs(arquivos) do

        print(arquivo)
    end

    return
end

-- ============================================
-- COPIAR DO FLOPPY
-- ============================================

if args[1] == "copy" then

    local origem =
        args[2]

    local destino =
        args[3]

    if not origem or not destino then

        print(
            "Uso: floppy_copy ARQUIVO DESTINO"
        )

        return
    end

    local arquivo =
        disco .. "/" .. origem

    if not fs.exists(arquivo) then

        print(
            "Arquivo nao encontrado no floppy."
        )

        return
    end

    fs.copy(
        arquivo,
        destino
    )

    print("Arquivo copiado.")

    return
end

-- ============================================
-- INFORMACOES
-- ============================================

print("Floppy encontrado: " .. drive)
print("")
print("Comandos:")
print("")
print("floppy_ls")
print("floppy_copy ARQUIVO DESTINO")