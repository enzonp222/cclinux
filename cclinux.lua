-- ============================================
--  CCLinux 1.0 - Shell principal
--  Coloque este arquivo como "cclinux.lua"
--  na raiz do computador
-- ============================================

local VERSION = "1.0"
local currentDir = ""  -- "" representa a raiz "/"
local history = {}
local running = true

local function resolvePath(path)
  if not path or path == "" then
    return currentDir
  end
  if path:sub(1, 1) == "/" then
    return fs.combine("", path)
  end
  return fs.combine(currentDir, path)
end

local function prettyPath(path)
  if path == "" then return "/" end
  return "/" .. path
end

-- ===== Suporte a monitor externo (opcional) =====
-- Se houver um monitor conectado, o CCLinux espelha nele
-- tudo que aparece no terminal. Se nao houver, o sistema
-- funciona normalmente sem erro nenhum.
local monitor = nil
local monY = 1

-- verifica todas as conexoes do computador uma unica vez,
-- na inicializacao, procurando por um monitor conectado
for _, side in ipairs(peripheral.getNames()) do
  if peripheral.getType(side) == "monitor" then
    monitor = peripheral.wrap(side)
    break
  end
end

if monitor then
  pcall(function()
    monitor.setTextScale(0.5)
  end)
  monitor.setBackgroundColor(colors.black)
  monitor.clear()
  monitor.setCursorPos(1, 1)
  monY = 1
end

local function monWrite(text, color)
  if not monitor then return end
  local mw, mh = monitor.getSize()
  text = tostring(text)

  local ok = pcall(function()
    if color and monitor.isColor and monitor.isColor() then
      monitor.setTextColor(color)
    end
  end)

  -- quebra o texto em varias linhas se for maior que a largura do monitor
  repeat
    local chunk = text:sub(1, mw)
    text = text:sub(mw + 1)

    monitor.setCursorPos(1, monY)
    monitor.clearLine()
    monitor.write(chunk)

    monY = monY + 1
    if monY > mh then
      monitor.scroll(1)
      monY = mh
    end
  until #text == 0

  pcall(function()
    if monitor.isColor and monitor.isColor() then
      monitor.setTextColor(colors.white)
    end
  end)
end

-- Sombreia o "print" nativo: tudo que o sistema imprime no
-- terminal tambem aparece no monitor (se existir um conectado)
local nativePrint = print
local function print(...)
  nativePrint(...)
  local n = select("#", ...)
  local parts = {}
  for i = 1, n do
    parts[i] = tostring((select(i, ...)))
  end
  monWrite(table.concat(parts, " "))
end

local function printColor(text, color)
  if term.isColor and term.isColor() then
    term.setTextColor(color)
  end
  nativePrint(text)
  term.setTextColor(colors.white)
  monWrite(text, color)
end

-- ===== Suporte a speaker externo (opcional) =====
-- Assim como o monitor, o speaker so e verificado uma
-- unica vez, na inicializacao. Se nao houver um conectado,
-- o CCLinux funciona normalmente sem tocar nenhum som.
local speaker = nil

for _, side in ipairs(peripheral.getNames()) do
  if peripheral.getType(side) == "speaker" then
    speaker = peripheral.wrap(side)
    break
  end
end

local function playNote(instrument, pitch, volume)
  if not speaker then return end
  pcall(function()
    speaker.playNote(instrument or "pling", volume or 1, pitch or 12)
  end)
end

-- ===== Suporte a impressora externa (opcional) =====
-- Mesmo padrao do monitor e do speaker: verificada uma
-- unica vez, na inicializacao.
local printerDevice = nil

for _, side in ipairs(peripheral.getNames()) do
  if peripheral.getType(side) == "printer" then
    printerDevice = peripheral.wrap(side)
    break
  end
end

-- ===== Sistema de login (dono do computador) =====
-- Na primeira vez que o CCLinux inicia, ele pede o nome do
-- dono e uma senha (opcional, mascarada com *) e guarda tudo
-- numa pasta oculta (".conta") que so o computador usa.
-- Nas proximas vezes, ele so pede a senha (se tiver uma).
local ACCOUNT_DIR = ".conta"
local NOME_FILE = fs.combine(ACCOUNT_DIR, "nome")
local SENHA_FILE = fs.combine(ACCOUNT_DIR, "senha")

local function lerArquivoConta(path)
  if not fs.exists(path) then return nil end
  local f = fs.open(path, "r")
  local content = f.readAll()
  f.close()
  return content
end

local function escreverArquivoConta(path, content)
  local f = fs.open(path, "w")
  f.write(content)
  f.close()
end

local function configurarConta()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
  printColor("Bem-vindo ao CCLinux! Vamos configurar sua conta.", colors.yellow)

  term.write("Nome do dono deste computador: ")
  local nome = read()
  while not nome or nome == "" do
    printColor("O nome nao pode ficar em branco.", colors.red)
    term.write("Nome do dono deste computador: ")
    nome = read()
  end

  term.write("Senha (opcional, deixe em branco se nao quiser): ")
  local senha = read("*")

  if not fs.exists(ACCOUNT_DIR) then
    fs.makeDir(ACCOUNT_DIR)
  end
  escreverArquivoConta(NOME_FILE, nome)
  if senha and senha ~= "" then
    escreverArquivoConta(SENHA_FILE, senha)
  end

  printColor("Conta configurada! Iniciando o CCLinux...", colors.lime)
  sleep(1)
  return nome
end

local function fazerLogin()
  local nome = lerArquivoConta(NOME_FILE)
  if not nome then
    return configurarConta()
  end

  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
  printColor("Bem-vindo de volta, " .. nome .. "!", colors.yellow)

  local senhaSalva = lerArquivoConta(SENHA_FILE)
  if senhaSalva and senhaSalva ~= "" then
    local tentativas = 3
    while tentativas > 0 do
      term.write("Senha: ")
      local digitada = read("*")
      if digitada == senhaSalva then
        return nome
      end
      tentativas = tentativas - 1
      if tentativas > 0 then
        printColor("Senha incorreta. Tentativas restantes: " .. tentativas, colors.red)
      end
    end
    printColor("Muitas tentativas erradas. Desligando por seguranca...", colors.red)
    sleep(2)
    os.shutdown()
  end

  return nome
end

local ownerName = fazerLogin()

-- ===== Tela de boas-vindas =====
-- Aparece toda vez, logo depois do login, e fica na tela
-- (nao some sozinha, o shell continua embaixo dela)
local function telaBoasVindas(nome)
  local w = select(1, term.getSize())
  local linha = string.rep("=", w)

  local function centerText(text, color)
    local x = math.max(1, math.floor((w - #text) / 2) + 1)
    term.setCursorPos(x, ({ term.getCursorPos() })[2])
    if term.isColor and term.isColor() and color then
      term.setTextColor(color)
    end
    term.write(text)
    term.setTextColor(colors.white)
    monWrite(text, color)
  end

  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)

  printColor(linha, colors.white)
  centerText("CCLinux " .. VERSION, colors.white)
  print("")
  printColor(linha, colors.white)
  print("")
  print("Bem-vindo ao CCLinux!")
  print("feito por enzo")
  print("")

  playNote("harp", 12)
end

telaBoasVindas(ownerName)



-- ===== Calculadora =====
-- Interpretador de expressoes matematicas simples,
-- suporta + - * / % ^ e parenteses
local function calcEval(exprStr)
  local pos = 1
  local len = #exprStr

  local function skipSpaces()
    while pos <= len and exprStr:sub(pos, pos):match("%s") do
      pos = pos + 1
    end
  end

  local function peek()
    skipSpaces()
    return exprStr:sub(pos, pos)
  end

  local parseExpr

  local function parseNumber()
    skipSpaces()
    local start = pos
    while pos <= len and exprStr:sub(pos, pos):match("[%d%.]") do
      pos = pos + 1
    end
    local numStr = exprStr:sub(start, pos - 1)
    local num = tonumber(numStr)
    if not num then error("numero invalido perto de '" .. exprStr:sub(start) .. "'") end
    return num
  end

  local function parseFactor()
    skipSpaces()
    local c = peek()
    if c == "(" then
      pos = pos + 1
      local val = parseExpr()
      skipSpaces()
      if peek() ~= ")" then error("parenteses nao fechados") end
      pos = pos + 1
      return val
    elseif c == "-" then
      pos = pos + 1
      return -parseFactor()
    elseif c == "" then
      error("expressao incompleta")
    else
      return parseNumber()
    end
  end

  local function parsePow()
    local base = parseFactor()
    if peek() == "^" then
      pos = pos + 1
      return base ^ parsePow()
    end
    return base
  end

  local function parseTerm()
    local val = parsePow()
    while true do
      local c = peek()
      if c == "*" then
        pos = pos + 1
        val = val * parsePow()
      elseif c == "/" then
        pos = pos + 1
        local divisor = parsePow()
        if divisor == 0 then error("divisao por zero") end
        val = val / divisor
      elseif c == "%" then
        pos = pos + 1
        val = val % parsePow()
      else
        break
      end
    end
    return val
  end

  parseExpr = function()
    local val = parseTerm()
    while true do
      local c = peek()
      if c == "+" then
        pos = pos + 1
        val = val + parseTerm()
      elseif c == "-" then
        pos = pos + 1
        val = val - parseTerm()
      else
        break
      end
    end
    return val
  end

  local result = parseExpr()
  skipSpaces()
  if pos <= len then
    error("caractere inesperado: '" .. exprStr:sub(pos) .. "'")
  end
  return result
end

local commands = {}

commands["help"] = function(args)
  local list = {
    "ls [path]      - lista arquivos",
    "cd <path>      - muda de diretorio",
    "pwd            - mostra diretorio atual",
    "cat <file>     - mostra conteudo do arquivo",
    "mkdir <dir>    - cria diretorio",
    "touch <file>   - cria arquivo vazio",
    "rm <path> [-r] - remove arquivo/diretorio",
    "cp <src> <dst> - copia arquivo",
    "mv <src> <dst> - move/renomeia arquivo",
    "echo <text>    - imprime texto",
    "clear          - limpa a tela",
    "whoami         - mostra usuario atual",
    "uname          - mostra info do sistema",
    "date           - mostra data/hora",
    "neofetch       - resumo do sistema",
    "history        - mostra historico de comandos",
    "edit <file>    - edita um arquivo",
    "disco          - mostra unidades de disco conectadas",
    "ejetar [lado]  - ejeta o disquete da unidade",
    "cdc            - grava um disquete auto-instalavel",
    "beep [nota]    - toca um som no speaker (se houver)",
    "imprimir <txt> - imprime texto na impressora (se houver)",
    "calc <expr>    - calculadora rapida (ex: calc 2+2*5)",
    "calculadora    - abre a calculadora interativa",
    "resetconta     - apaga nome/senha salvos da conta",
    "reboot         - reinicia o computador",
    "shutdown       - desliga o computador",
    "exit           - sai do CCLinux para o CraftOS",
  }
  printColor("CCLinux " .. VERSION .. " - Comandos disponiveis:", colors.yellow)
  for _, l in ipairs(list) do
    print("  " .. l)
  end
end

commands["ls"] = function(args)
  local path = resolvePath(args[1])
  if not fs.exists(path) then
    printColor("ls: nao foi possivel acessar '" .. (args[1] or ".") .. "': arquivo ou diretorio inexistente", colors.red)
    return
  end
  if not fs.isDir(path) then
    print(fs.getName(path))
    return
  end
  local items = fs.list(path)
  table.sort(items)
  for _, item in ipairs(items) do
    local full = fs.combine(path, item)
    if fs.isDir(full) then
      printColor(item .. "/", colors.cyan)
    else
      print(item)
    end
  end
end

commands["sl"] = function(args)
  local train = {
    "      ====        ________                ___________ ",
    "  _D _|  |_______/        \\__I_I_____===__|_________| ",
    "   |(_)---  |   H\\________/ |   |        =|___ ___|   ",
    "   /     |  |   H  |  |     |   |         ||_| |_||   ",
    "  |      |  |   H  |__--------------------| [___] |   ",
    "  | ________|___H__/__|_____/[][]~\\_______|       |   ",
    "  |/ |   |-----------I_____I [][] []  D   |=======|__ ",
    "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
    " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
    "  \\_/      \\O=====O=====O=====O_/      \\_/            ",
  }

  local w, h = term.getSize()
  local trainWidth = 0
  for _, line in ipairs(train) do
    trainWidth = math.max(trainWidth, #line)
  end

  -- limpa a tela inteira e centraliza o trem verticalmente no meio
  term.setBackgroundColor(colors.black)
  term.clear()
  local startY = math.max(1, math.floor((h - #train) / 2) + 1)

  local x = w + 1
  while x > -trainWidth do
    for i = 1, #train do
      term.setCursorPos(1, startY + i - 1)
      term.clearLine()
    end
    for i, line in ipairs(train) do
      local drawX = x
      if drawX + #line > 1 and drawX < w then
        term.setCursorPos(drawX, startY + i - 1)
        term.write(line)
      end
    end
    sleep(0.05)
    x = x - 2
  end

  -- limpa tudo de novo no final, deixando a tela limpa
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
end

commands["cd"] = function(args)
  local target = args[1]
  if not target or target == "~" then
    currentDir = ""
    return
  end
  local path = resolvePath(target)
  if not fs.exists(path) then
    printColor("cd: arquivo ou diretorio inexistente: " .. target, colors.red)
    return
  end
  if not fs.isDir(path) then
    printColor("cd: nao e um diretorio: " .. target, colors.red)
    return
  end
  currentDir = path
end

commands["pwd"] = function(args)
  print(prettyPath(currentDir))
end

commands["cat"] = function(args)
  if not args[1] then
    printColor("cat: operando de arquivo ausente", colors.red)
    return
  end
  local path = resolvePath(args[1])
  if not fs.exists(path) or fs.isDir(path) then
    printColor("cat: " .. args[1] .. ": arquivo inexistente", colors.red)
    return
  end
  local f = fs.open(path, "r")
  print(f.readAll())
  f.close()
end

commands["mkdir"] = function(args)
  if not args[1] then
    printColor("mkdir: operando ausente", colors.red)
    return
  end
  fs.makeDir(resolvePath(args[1]))
end

commands["touch"] = function(args)
  if not args[1] then
    printColor("touch: operando ausente", colors.red)
    return
  end
  local path = resolvePath(args[1])
  if not fs.exists(path) then
    local f = fs.open(path, "w")
    f.close()
  end
end

commands["rm"] = function(args)
  local target, flag = nil, nil
  for _, a in ipairs(args) do
    if a == "-r" or a == "-rf" then
      flag = "-r"
    else
      target = a
    end
  end
  if not target then
    printColor("rm: operando ausente", colors.red)
    return
  end
  local path = resolvePath(target)
  if not fs.exists(path) then
    printColor("rm: nao foi possivel remover '" .. target .. "': arquivo inexistente", colors.red)
    return
  end
  if fs.isDir(path) and #fs.list(path) > 0 and flag ~= "-r" then
    printColor("rm: nao foi possivel remover '" .. target .. "': diretorio nao vazio (use -r)", colors.red)
    return
  end
  if fs.isReadOnly(path) then
    printColor("rm: nao foi possivel remover '" .. target .. "': sistema de arquivos somente leitura", colors.red)
    return
  end
  fs.delete(path)
end

commands["cp"] = function(args)
  if not args[1] or not args[2] then
    printColor("cp: operando ausente", colors.red)
    return
  end
  local src = resolvePath(args[1])
  local dst = resolvePath(args[2])
  if not fs.exists(src) then
    printColor("cp: nao foi possivel acessar '" .. args[1] .. "': inexistente", colors.red)
    return
  end
  fs.copy(src, dst)
end

commands["mv"] = function(args)
  if not args[1] or not args[2] then
    printColor("mv: operando ausente", colors.red)
    return
  end
  local src = resolvePath(args[1])
  local dst = resolvePath(args[2])
  if not fs.exists(src) then
    printColor("mv: nao foi possivel acessar '" .. args[1] .. "': inexistente", colors.red)
    return
  end
  fs.move(src, dst)
end

commands["echo"] = function(args)
  print(table.concat(args, " "))
end

commands["clear"] = function(args)
  term.clear()
  term.setCursorPos(1, 1)
end

commands["whoami"] = function(args)
  print(ownerName)
end

commands["uname"] = function(args)
  print("CCLinux " .. VERSION .. " rodando sobre CraftOS " .. os.version())
end

commands["date"] = function(args)
  print(os.date())
end

commands["neofetch"] = function(args)
  local label = os.getComputerLabel() or "cclinux"
  local id = os.getComputerID()
  local free = "desconhecido"
  if fs.getFreeSpace then
    local ok, result = pcall(fs.getFreeSpace, "/")
    if ok then free = tostring(result) end
  end
  local logo = {
    " ____ ____ _     _                 ",
    "/ ___/ ___| |   (_)_ __  _   ___  _",
    "| |  | |   | |   | | '_ \\| | | \\ \\/ ",
    "| |__| |___| |___| | | | | |_| |>  <",
    "\\____\\____|_____|_|_| |_|\\__,_/_/\\_\\",
  }
  local info = {
    ownerName .. "@" .. label,
    "-------------------",
    "OS: CCLinux " .. VERSION,
    "Host: " .. label .. " (#" .. id .. ")",
    "Kernel: CraftOS " .. os.version(),
    "Espaco livre: " .. free,
  }
  for i = 1, math.max(#logo, #info) do
    printColor(logo[i] or "", colors.lime)
    if info[i] then
      term.setCursorPos(math.max(#(logo[i] or ""), 20) + 3, ({term.getCursorPos()})[2] or 1)
    end
  end
  for _, l in ipairs(info) do
    print(l)
  end
end

commands["history"] = function(args)
  for i, h in ipairs(history) do
    print(i .. "  " .. h)
  end
end

commands["edit"] = function(args)
  if not args[1] then
    printColor("edit: operando de arquivo ausente", colors.red)
    return
  end
  if shell then
    shell.run("edit", resolvePath(args[1]))
  else
    printColor("edit: nenhum editor disponivel", colors.red)
  end
end

commands["disco"] = function(args)
  local found = false
  for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "drive" then
      found = true
      if disk.isPresent(side) then
        local label = disk.getLabel(side) or "sem nome"
        local mount = disk.getMountPath(side)
        local free = "?"
        pcall(function() free = tostring(fs.getFreeSpace(mount)) end)
        print(side .. ": disco '" .. label .. "' em /" .. mount .. " (livre: " .. free .. ")")
      else
        print(side .. ": unidade vazia")
      end
    end
  end
  if not found then
    printColor("disco: nenhuma unidade de disco (disk drive) conectada", colors.red)
  end
end

commands["ejetar"] = function(args)
  local side = args[1]
  if not side then
    for _, s in ipairs(peripheral.getNames()) do
      if peripheral.getType(s) == "drive" and disk.isPresent(s) then
        side = s
        break
      end
    end
  end
  if not side then
    printColor("ejetar: nenhum disquete encontrado para ejetar", colors.red)
    return
  end
  disk.eject(side)
  printColor("Disquete ejetado.", colors.yellow)
  playNote("bass", 8)
end

commands["cdc"] = function(args)
  local side = nil
  for _, s in ipairs(peripheral.getNames()) do
    if peripheral.getType(s) == "drive" and disk.isPresent(s) then
      side = s
      break
    end
  end
  if not side then
    printColor("cdc: coloque um disquete na unidade primeiro", colors.red)
    return
  end
  if not http then
    printColor("cdc: a API http esta desativada neste servidor", colors.red)
    return
  end

  local mount = disk.getMountPath(side)
  local installerPath = fs.combine(mount, "startup.lua")
  if fs.exists(installerPath) then fs.delete(installerPath) end

  -- este e o script que roda SOZINHO quando o disquete for
  -- colocado num computador que ainda nao tem startup.lua.
  -- ele baixa o CCLinux direto do GitHub via http, entao
  -- sempre pega a versao mais atual.
  local installerCode = [[
local STARTUP_URL = "https://raw.githubusercontent.com/enzonp222/cclinux/refs/heads/main/startup.lua"
local CCLINUX_URL = "https://raw.githubusercontent.com/enzonp222/cclinux/refs/heads/main/cclinux.lua"

-- o CC:Tweaked roda o startup.lua do disquete TODA VEZ que o
-- computador liga (nao so quando ele nao tem startup proprio).
-- por isso, se o CCLinux ja estiver instalado aqui, nao faz
-- nada -- so deixa o boot normal continuar, sem reinstalar
-- nem reiniciar de novo (evita o loop infinito).
-- o disquete tem PRIORIDADE sobre o startup.lua local quando
-- esta inserido (assim funciona o boot do CC:Tweaked), entao
-- so dar "return" aqui faria o computador cair no CraftOS
-- puro. Por isso, se ja estiver instalado, chamamos o
-- startup.lua local na mao pra realmente abrir o CCLinux.
if fs.exists("cclinux.lua") and fs.exists("startup.lua") then
  dofile("startup.lua")
  return
end

term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1, 1)
print("Instalando CCLinux pela internet...")
print("")

local w, h = term.getSize()
local barWidth = math.min(w - 4, 30)
local barY = 4

local function desenharBarra(percentual, texto)
  local filled = math.floor((percentual / 100) * (barWidth - 2))
  term.setCursorPos(1, barY)
  term.clearLine()
  term.write("[" .. string.rep("=", filled) .. string.rep(" ", barWidth - 2 - filled) .. "] " .. percentual .. "%")
  term.setCursorPos(1, barY + 2)
  term.clearLine()
  term.write(texto)
end

local function baixar(url, caminho)
  local ok, response = pcall(http.get, url)
  if not ok or not response then
    print("Falha ao baixar: " .. url)
    return false
  end
  local conteudo = response.readAll()
  response.close()
  if fs.exists(caminho) then fs.delete(caminho) end
  local f = fs.open(caminho, "w")
  f.write(conteudo)
  f.close()
  return true
end

-- barra de progresso rapida, mas com pausinhas de vez em
-- quando pra nao passar tao instantaneo
desenharBarra(10, "Conectando ao servidor...")
sleep(0.15)
desenharBarra(30, "Baixando startup.lua...")
local ok1 = baixar(STARTUP_URL, "startup.lua")
desenharBarra(55, "Baixando cclinux.lua...")
sleep(0.2)
local ok2 = baixar(CCLINUX_URL, "cclinux.lua")
desenharBarra(80, "Finalizando instalacao...")
sleep(0.25)
desenharBarra(100, "Concluido!")
sleep(0.3)

if ok1 and ok2 then
  print("")
  print("CCLinux instalado com sucesso! Reiniciando...")
  sleep(1)
  os.reboot()
else
  print("")
  print("Erro na instalacao. Verifique se a API http esta ativada no servidor.")
end
]]

  local f = fs.open(installerPath, "w")
  f.write(installerCode)
  f.close()

  pcall(function() disk.setLabel(side, "CCLinux Installer") end)

  printColor("Disquete de instalacao (via internet) criado com sucesso!", colors.lime)
  print("Tire o disquete e coloque em outro computador sem CCLinux.")
  print("Ele vai baixar e instalar sozinho (precisa da API http ativada).")
  playNote("pling", 18)
end

commands["beep"] = function(args)
  if not speaker then
    printColor("beep: nenhum speaker conectado", colors.red)
    return
  end
  playNote(args[1], tonumber(args[2]))
  print("Bip!")
end

commands["imprimir"] = function(args)
  if not printerDevice then
    printColor("imprimir: nenhuma impressora conectada", colors.red)
    return
  end
  local texto = table.concat(args, " ")
  if texto == "" then
    printColor("imprimir: nada para imprimir. Uso: imprimir <texto>", colors.red)
    return
  end
  local ok = printerDevice.newPage()
  if not ok then
    printColor("imprimir: coloque papel e tinta na impressora", colors.red)
    return
  end
  printerDevice.setPageTitle("CCLinux")
  printerDevice.write(texto)
  printerDevice.endPage()
  printColor("Pagina impressa!", colors.lime)
end

commands["calc"] = function(args)
  if #args == 0 then
    printColor("calc: uso: calc <expressao> (ex: calc 2+2*5)", colors.red)
    return
  end
  local expr = table.concat(args, " ")
  local ok, result = pcall(calcEval, expr)
  if ok then
    print(expr .. " = " .. tostring(result))
  else
    printColor("calc: erro - " .. tostring(result), colors.red)
  end
end

commands["calculadora"] = function(args)
  printColor("Calculadora CCLinux - digite uma expressao ou 'sair' pra voltar", colors.yellow)
  while true do
    term.write("calc> ")
    local line = read()
    monWrite("calc> " .. (line or ""))
    if not line or line == "sair" or line == "exit" then
      break
    end
    if line ~= "" then
      local ok, result = pcall(calcEval, line)
      if ok then
        print("= " .. tostring(result))
      else
        printColor("Erro: " .. tostring(result), colors.red)
      end
    end
  end
end

commands["resetconta"] = function(args)
  printColor("Isso vai apagar o nome e a senha salvos. Digite 'sim' pra confirmar:", colors.yellow)
  term.write("> ")
  local confirm = read()
  if confirm == "sim" then
    if fs.exists(ACCOUNT_DIR) then
      fs.delete(ACCOUNT_DIR)
    end
    printColor("Conta resetada! Reinicie o computador pra configurar de novo.", colors.lime)
  else
    printColor("Cancelado.", colors.yellow)
  end
end

commands["reboot"] = function(args)
  os.reboot()
end

commands["shutdown"] = function(args)
  os.shutdown()
end

commands["exit"] = function(args)
  running = false
  printColor("Desligando o computador...", colors.yellow)
  sleep(0.5)
  os.shutdown()
end

local function parseLine(line)
  local words = {}
  for w in line:gmatch("%S+") do
    table.insert(words, w)
  end
  return words
end

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)

while running do
  local promptText = ownerName .. ":" .. prettyPath(currentDir) .. "$ "

  if term.isColor and term.isColor() then
    term.setTextColor(colors.lime)
  end
  term.write(promptText)
  term.setTextColor(colors.white)

  -- o monitor (se existir) so recebe o prompt + comando
  -- DEPOIS que o jogador aperta Enter, nao tecla por tecla
  local line = read()
  monWrite(promptText .. (line or ""))

  if line and line ~= "" then
    table.insert(history, line)
    local words = parseLine(line)
    local cmd = table.remove(words, 1)
    if commands[cmd] then
      local ok, err = pcall(commands[cmd], words)
      if not ok then
        printColor("Erro: " .. tostring(err), colors.red)
      end
    else
      printColor(cmd .. ": comando nao encontrado", colors.red)
      playNote("bass", 4)
    end
  end
end
