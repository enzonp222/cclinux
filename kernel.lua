-- ==========================================
-- CCLinux 1.6 - KERNEL
-- ==========================================

local CCLINUX = "/cclinux"

-- Verifica os arquivos necessários

local arquivos = {
    "monitor.lua",
    "login.lua",
    "floppy.lua",
    "shell.lua"
}

for _, arquivo in ipairs(arquivos) do

    if not fs.exists(
        CCLINUX .. "/" .. arquivo
    ) then

        term.clear()
        term.setCursorPos(1, 1)

        print("ERRO DO CCLINUX")
        print()
        print(
            "Arquivo ausente: " ..
            arquivo
        )

        return
    end
end

-- ==========================================
-- CARREGAR MONITOR
-- ==========================================

local monitorModule =
    dofile(
        CCLINUX .. "/monitor.lua"
    )

-- ==========================================
-- CARREGAR FLOPPY
-- ==========================================

local floppyModule =
    dofile(
        CCLINUX .. "/floppy.lua"
    )

-- ==========================================
-- CARREGAR LOGIN
-- ==========================================

local loginModule =
    dofile(
        CCLINUX .. "/login.lua"
    )

-- ==========================================
-- INICIALIZAR MONITOR
-- ==========================================

monitorModule.init()

-- ==========================================
-- PRIMEIRA INICIALIZACAO
-- ==========================================

loginModule.firstBoot()

-- ==========================================
-- LOGIN
-- ==========================================

local nome =
    loginModule.login()

if not nome then
    return
end

-- ==========================================
-- TELA DE INICIALIZACAO
-- ==========================================

monitorModule.loading()

-- ==========================================
-- INICIAR SHELL
-- ==========================================

shell.run(
    CCLINUX .. "/shell.lua",
    nome
)