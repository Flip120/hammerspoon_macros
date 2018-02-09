
-- [[ Load Configuration  ]]
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
-- [[ Window Management ]]

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local max = screen:frame()

  local x = max.x
  splitVertical(window, x)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local max = screen:frame()
  local x = max.x + (max.w / 2)
  
  splitVertical(win, x)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  local win = hs.window.focusedWindow()
  
  maximize(win)
end)

function splitVertical(win, x)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function maximize(win)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local max = screen:frame()
  local x = max.x + (max.w / 2)
  
  splitVertical(win, x)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)

-- [[ Multi Layout windows ]]
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function()
  local laptopScreen = hs.screen.mainScreen():name()
  local windowLayout = {
    {"iTerm2",  nil, laptopScreen, hs.layout.left50,    nil, nil},
    {"Google Chrome",    nil, laptopScreen, hs.layout.right50,   nil, nil}
  }
  hs.layout.apply(windowLayout)
end)

function appWatcherCb()
  local focusedWindow = hs.window.focusedWindow()

  if(focusedWindow ~= nil) then
    local focusedApp = focusedWindow:application()
  end
end

appWatcher = hs.application.watcher.new(appWatcherCb)
appWatcher:start()

-- [[ Wifi ]]

wifiWatcher = nil
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback(watcher, message, interface)
  local currentNetwork = hs.wifi.currentNetwork()
  print(currentNetwork)
  if currentNetwork ~= nil then
    lastSSID = currentNetwork
    hs.alert.show("Connected to " .. lastSSID)
  elseif lastSSID then
    hs.alert.show("Diconnected from " .. lastSSID)
  end
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-- [[ Battery ]]
batteryWatcher = nil
lastBatteryLevel = nil

function batteryListener()
  local currentBatteryLevel = hs.battery.percentage()
  if currentBatteryLevel ~= lastBatteryLevel and currentBatteryLevel < 30 then
    lastBatteryLevel = currentBatteryLevel
    hs.alert.show('Low battery level ' .. currentBatteryLevel)
  end
end

batteryWatcher = hs.battery.watcher.new(batteryListener)
batteryWatcher:start()

hs.alert.show("Hammerspoon config loaded :)")
