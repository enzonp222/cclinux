-- ==========================================
-- CCLinux 1.6 - LOGIN
-- ==========================================

local PASTA_PESSOAL =
    "/pasta pessoal"

local ARQUIVO_NOME =
    PASTA_PESSOAL .. "/nome"

local ARQUIVO_CODIGO =
    PASTA_PESSOAL .. "/codigo"

-- ==========================================
-- PRIMEIRA INICIALIZACAO
-- ==========================================

local function firstBoot()

    if fs.exists(PASTA_PESSOAL) then
        return
    end

    fs.makeDir(
        PASTA_PESSOAL
    )

    term.clear()
    term.setCursorPos(1, 1)

    print("================================")
    print("       PRIMEIRA INICIALIZACAO")
    print("================================")
    print()
    print("Bem-vindo ao CCLinux!")
    print()

    -- ======================================
    -- NOME
    -- ======================================

    while true do

        write("Digite seu nome: ")

        local nome =
            read()

        if nome ~= "" then

            local arquivo =
                fs.open(
                    ARQUIVO_NOME,
                    "w"
                )

            arquivo.write(nome)
            arquivo.close()

            break

        else

            print(
                "O nome nao pode estar vazio."
            )

        end

    end

    print()

    -- ======================================
    -- CODIGO
    -- ======================================

    while true do

        write("Crie um codigo: ")

        local codigo1 =
            read("*")

        print()

        write("Confirme o codigo: ")

        local codigo2 =
            read("*")

        print()

        if codigo1 == "" then

            print(
                "O codigo nao pode estar vazio."
            )

        elseif codigo1 ~= codigo2 then

            print(
                "Os codigos nao sao iguais."
            )

        else

            local arquivo =
                fs.open(
                    ARQUIVO_CODIGO,
                    "w"
                )

            arquivo.write(codigo1)
            arquivo.close()

            print("Codigo criado!")

            break
        end

        print()
    end

    print()
    print("Configuracao concluida!")
    print()
    print("Reinicie o computador para continuar.")

    sleep(3)

    os.reboot()
end

-- ==========================================
-- PEGAR NOME
-- ==========================================

local function getName()

    if not fs.exists(ARQUIVO_NOME) then
        return "Usuario"
    end

    local arquivo =
        fs.open(
            ARQUIVO_NOME,
            "r"
        )

    local nome =
        arquivo.readAll()

    arquivo.close()

    return nome
end

-- ==========================================
-- LOGIN
-- ==========================================

local function login()

    if not fs.exists(
        ARQUIVO_CODIGO
    ) then

        return getName()
    end

    local arquivo =
        fs.open(
            ARQUIVO_CODIGO,
            "r"
        )

    local codigoCorreto =
        arquivo.readAll()

    arquivo.close()

    local nome =
        getName()

    term.clear()
    term.setCursorPos(1, 1)

    print("================================")
    print("          CCLinux 1.6")
    print("================================")
    print()
    print("Ola, " .. nome .. "!")
    print()
    print("Sistema protegido.")
    print()

    while true do

        write("Codigo de entrada: ")

        local codigo =
            read("*")

        if codigo == codigoCorreto then

            print()
            print("Acesso permitido.")

            sleep(1)

            return nome

        else

            print()
            print("Codigo incorreto.")
            print()

        end
    end
end

-- ==========================================
-- RESETAR PASTA PESSOAL
-- ==========================================

local function reset()

    print()
    print("ATENCAO!")
    print()
    print(
        "Isso apagará sua pasta pessoal."
    )

    print(
        "Nome e codigo serao apagados."
    )

    print()

    write(
        "Digite SIM para continuar: "
    )

    local resposta =
        read()

    if resposta == "SIM" then

        if fs.exists(
            PASTA_PESSOAL
        ) then

            fs.delete(
                PASTA_PESSOAL
            )

        end

        print()
        print("Pasta pessoal apagada.")
        print("Reiniciando...")

        sleep(2)

        os.reboot()

    else

        print("Operacao cancelada.")
    end
end

-- ==========================================
-- EXPORTAR FUNCOES
-- ==========================================

return {
    firstBoot = firstBoot,
    login = login,
    reset = reset,
    getName = getName
}