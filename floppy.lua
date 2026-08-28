-- ==========================================
-- CCLinux 1.6 - FLOPPY
-- ==========================================

local F = {}

-- ==========================================
-- ENCONTRAR DRIVE
-- ==========================================

local function getDrive()

    return peripheral.find(
        "drive"
    )

end

-- ==========================================
-- VERIFICAR FLOPPY
-- ==========================================

local function getMount()

    local drive =
        getDrive()

    if not drive then

        return nil,
            "Nenhum drive de floppy encontrado."

    end

    local nome =
        peripheral.getName(
            drive
        )

    if not disk.isPresent(nome) then

        return nil,
            "Nenhum floppy inserido."

    end

    local mount =
        disk.getMountPath(
            nome
        )

    if not mount then

        return nil,
            "Nao foi possivel acessar o floppy."

    end

    return mount
end

-- ==========================================
-- INFORMACOES
-- ==========================================

function F.info()

    local mount, erro =
        getMount()

    if not mount then

        print(erro)
        return

    end

    local drive =
        getDrive()

    local nome =
        peripheral.getName(
            drive
        )

    local label =
        disk.getLabel(nome)

    print(
        "Floppy encontrado!"
    )

    print(
        "Local: " .. mount
    )

    if label then

        print(
            "Nome: " .. label
        )

    else

        print(
            "Nome: sem nome"
        )

    end

end

-- ==========================================
-- LISTAR FLOPPY
-- ==========================================

function F.list()

    local mount, erro =
        getMount()

    if not mount then

        print(erro)
        return

    end

    print(
        "Conteudo do floppy:"
    )

    print()

    for _, arquivo in ipairs(
        fs.list(mount)
    ) do

        local caminho =
            fs.combine(
                mount,
                arquivo
            )

        if fs.isDir(caminho) then

            print(
                "[DIR] " .. arquivo
            )

        else

            print(
                "      " .. arquivo
            )

        end

    end

end

-- ==========================================
-- COPIAR ARQUIVO
-- ==========================================

function F.copyToFloppy(
    arquivo
)

    if not arquivo then

        print(
            "Uso: floppy_copy ARQUIVO"
        )

        return

    end

    if not fs.exists(arquivo) then

        print(
            "Arquivo nao encontrado."
        )

        return

    end

    local mount, erro =
        getMount()

    if not mount then

        print(erro)
        return

    end

    local destino =
        fs.combine(
            mount,
            fs.getName(
                arquivo
            )
        )

    if fs.exists(destino) then

        print(
            "O arquivo ja existe no floppy."
        )

        return

    end

    fs.copy(
        arquivo,
        destino
    )

    print(
        "Arquivo copiado para o floppy!"
    )

end

-- ==========================================
-- INSTALAR CCLINUX
-- ==========================================

function F.install()

    local mount, erro =
        getMount()

    if not mount then

        print(erro)
        return

    end

    print(
        "Instalador do CCLinux 1.6"
    )

    print(
        "=========================="
    )

    print()

    local pasta =
        fs.combine(
            mount,
            "cclinux"
        )

    if not fs.exists(pasta) then

        fs.makeDir(pasta)

    end

    local arquivos = {
        "kernel.lua",
        "login.lua",
        "monitor.lua",
        "floppy.lua",
        "shell.lua"
    }

    for _, arquivo in ipairs(
        arquivos
    ) do

        local origem =
            "/cclinux/" ..
            arquivo

        local destino =
            fs.combine(
                pasta,
                arquivo
            )

        if fs.exists(origem) then

            fs.copy(
                origem,
                destino
            )

            print(
                "Copiado: " ..
                arquivo
            )

        else

            print(
                "Nao encontrado: " ..
                arquivo
            )

        end

    end

    print()

    print(
        "CCLinux copiado para o floppy!"
    )

end

return F