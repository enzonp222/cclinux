-- ============================================
-- CCLinux 1.7 - FLOPPY
-- ============================================

local function encontrarDrive()

    for _, nome in ipairs(peripheral.getNames()) do

        if peripheral.getType(nome) == "drive" then
            return nome
        end
    end

    return nil
end

local drive = encontrarDrive()

if not drive then

    print("ERRO: nenhum floppy drive encontrado.")
    return
end

local disco = "/" .. drive

-- ============================================
-- VERIFICAR DISCO
-- ============================================

local function discoInserido()

    return disk.isPresent(disco)
end

-- ============================================
-- LISTAR
-- ============================================

local function listar()

    if not discoInserido() then
        print("Nenhum floppy inserido.")
        return
    end

    print("Floppy: " .. drive)
    print("")

    local arquivos = fs.list(disco)

    if #arquivos == 0 then
        print("(floppy vazio)")
        return
    end

    for _, arquivo in ipairs(arquivos) do
        print(arquivo)
    end
end

-- ============================================
-- COPIAR
-- ============================================

local function copiar(origem, destino)

    if not discoInserido() then
        print("Nenhum floppy inserido.")
        return
    end

    if not origem or not destino then
        print("Uso:")
        print("floppy_copy ARQUIVO DESTINO")
        return
    end

    local arquivoOrigem =
        disco .. "/" .. origem

    if not fs.exists(arquivoOrigem) then

        print(
            "Arquivo nao encontrado no floppy:"
        )

        print(origem)

        return
    end

    fs.copy(
        arquivoOrigem,
        destino
    )

    print("Arquivo copiado:")
    print(origem .. " -> " .. destino)
end

-- ============================================
-- ARGUMENTOS
-- ============================================

local args = {...}

if args[1] == "ls" then

    listar()

elseif args[1] == "copy" then

    copiar(
        args[2],
        args[3]
    )

else

    print("================================")
    print("       CCLinux - FLOPPY")
    print("================================")
    print("")
    print("Drive: " .. drive)
    print("")

    if discoInserido() then
        print("Floppy inserido.")
    else
        print("Nenhum floppy inserido.")
    end

    print("")
    print("Comandos:")
    print("")
    print("floppy_ls")
    print("floppy_copy ARQUIVO DESTINO")
end