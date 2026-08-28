-- ============================================
-- CCLinux 1.7 - FLOPPY
-- ============================================

local function encontrarFloppy()
    local lista = peripheral.getNames()

    for _, lado in ipairs(lista) do
        if peripheral.getType(lado) == "drive" then
            return lado
        end
    end

    return nil
end

local function listar()
    local drive = encontrarFloppy()

    if not drive then
        print("Nenhum floppy drive encontrado.")
        return
    end

    local caminho = "/" .. drive

    if not fs.exists(caminho) then
        print("Drive encontrado, mas sem floppy.")
        return
    end

    print("Arquivos do floppy:")

    local arquivos = fs.list(caminho)

    if #arquivos == 0 then
        print("  (vazio)")
        return
    end

    for _, arquivo in ipairs(arquivos) do
        print("  " .. arquivo)
    end
end

local function copiar(origem, destino)
    local drive = encontrarFloppy()

    if not drive then
        print("Nenhum floppy drive encontrado.")
        return
    end

    local origemFloppy = "/" .. drive .. "/" .. origem

    if not fs.exists(origemFloppy) then
        print("Arquivo nao encontrado no floppy.")
        return
    end

    fs.copy(origemFloppy, destino)

    print("Arquivo copiado para:")
    print(destino)
end

local args = {...}

if args[1] == "ls" then
    listar()

elseif args[1] == "copy" then

    if not args[2] or not args[3] then
        print("Uso: floppy_copy ARQUIVO DESTINO")
        return
    end

    copiar(args[2], args[3])

else
    print("Floppy CCLinux")
    print("")
    print("Use:")
    print("  floppy_ls")
    print("  floppy_copy ARQUIVO DESTINO")
end