-- ============================================
--  CCLinux 1.0 - Boot Loader
--  Coloque este arquivo como "startup.lua"
--  na raiz do computador junto com "cclinux.lua"
-- ============================================

local w, h = term.getSize()

local function centerText(y, text, color)
  local x = math.floor((w - #text) / 2) + 1
  term.setCursorPos(x, y)
  if term.isColor and term.isColor() and color then
    term.setTextColor(color)
  end
  term.write(text)
  term.setTextColor(colors.white)
end

local logo = {
  " _____ _____ _      _                  ",
  "|  ___/ ____| |    (_)                 ",
  "| |  | |     | |     _ _ __  _   ___  _",
  "| |  | |     | |    | | '_ \\| | | \\ \\/ ",
  "| |__| |____ | |____| | | | | |_| |>  <",
  "|_____\\_____||______|_|_| |_|\\__,_/_/\\_\\",
}

term.setBackgroundColor(colors.black)
term.clear()

local startY = math.max(1, math.floor(h / 2) - 5)
for i, line in ipairs(logo) do
  centerText(startY + i - 1, line, colors.lime)
end

centerText(startY + #logo + 1, "CCLinux 1.0 - Booting...", colors.white)

local barY = startY + #logo + 3
local barWidth = math.min(w - 10, 40)
local barX = math.floor((w - barWidth) / 2) + 1

local steps = {
  "Loading kernel modules",
  "Mounting filesystem",
  "Starting cclinux shell",
  "Initializing peripherals",
  "Ready",
}

for i, step in ipairs(steps) do
  local filled = math.floor((i / #steps) * (barWidth - 2))
  term.setCursorPos(barX, barY)
  term.write("[" .. string.rep("=", filled) .. string.rep(" ", barWidth - 2 - filled) .. "]")

  term.setCursorPos(barX, barY + 2)
  term.clearLine()
  term.write(step .. "...")

  sleep(0.4)
end

sleep(0.3)
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1, 1)

-- Inicia o shell principal do CCLinux
local ok, err = pcall(function()
  if fs.exists("cclinux.lua") then
    dofile("cclinux.lua")
  else
    error("cclinux.lua nao encontrado. Coloque-o na raiz do computador.")
  end
end)

if not ok then
  term.setCursorPos(1, 1)
  print("CCLinux travou durante a execucao:")
  print(err)
end
