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

local function printColor(text, color)
  if term.isColor and term.isColor() then
    term.setTextColor(color)
  end
  print(text)
  term.setTextColor(colors.white)
end

local commands = {}

commands["help"] = function(args)
  local list = {
    "ls [path]      - lista arquivos",
    "sl             - ??? (tente digitar errado 'ls')",
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

  local startY = math.max(1, math.floor(h / 2) - #train)
  local oldBg = colors.black

  local x = w + 1
  while x > -trainWidth do
    term.setCursorPos(1, startY)
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

  for i = 1, #train do
    term.setCursorPos(1, startY + i - 1)
    term.clearLine()
  end
  term.setCursorPos(1, startY)
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
  print("root")
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
    "user@" .. label,
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

commands["reboot"] = function(args)
  os.reboot()
end

commands["shutdown"] = function(args)
  os.shutdown()
end

commands["exit"] = function(args)
  running = false
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
printColor("Bem-vindo ao CCLinux " .. VERSION .. "! Digite 'help' para ver os comandos.", colors.yellow)

while running do
  if term.isColor and term.isColor() then
    term.setTextColor(colors.lime)
  end
  term.write("root@cclinux:" .. prettyPath(currentDir) .. "$ ")
  term.setTextColor(colors.white)

  local line = read()
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
    end
  end
end

term.setTextColor(colors.white)
print("Saindo do CCLinux...")
if shell then
  shell.run("shell")
end
