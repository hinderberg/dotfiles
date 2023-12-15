local hyper = { "cmd", "alt", "ctrl", "shift" }


hs.window.animationDuration = 0

function reloadConfig(files)
  local doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
    hs.alert.show('Config Reloaded')
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

function bindKey(key, fn)
  hs.hotkey.bind(hyper, key, fn)
end

local applicationHotkeys = {
    g = 'Google Chrome',
    r = 'Reminders',
    m = 'Mail',
    c = 'Cursor',
    s = 'Slack'
}

applicationHotkeys['1'] = '1Password';

for key, app in pairs(applicationHotkeys) do
  bindKey(key, function()
    hs.application.launchOrFocus(app)
  end)
end

local positions = {
  maximized = hs.layout.maximized,
  centered = {x=0.15, y=0.15, w=0.7, h=0.7},

  left34 = {x=0, y=0, w=0.34, h=1},
  left50 = hs.layout.left50,
  left66 = {x=0, y=0, w=0.66, h=1},
  left70 = hs.layout.left70,

  right30 = hs.layout.right30,
  right34 = {x=0.66, y=0, w=0.34, h=1},
  right50 = hs.layout.right50,
  right66 = {x=0.34, y=0, w=0.66, h=1},

  upper50 = {x=0, y=0, w=1, h=0.5},
  upper50Left50 = {x=0, y=0, w=0.5, h=0.5},
  upper50Right15 = {x=0.85, y=0, w=0.15, h=0.5},
  upper50Right30 = {x=0.7, y=0, w=0.3, h=0.5},
  upper50Right50 = {x=0.5, y=0, w=0.5, h=0.5},

  lower50 = {x=0, y=0.5, w=1, h=0.5},
  lower50Left50 = {x=0, y=0.5, w=0.5, h=0.5},
  lower50Right50 = {x=0.5, y=0.5, w=0.5, h=0.5},

  chat = {x=0.5, y=0, w=0.35, h=0.5}
}

local grid = {
  {key="9", units={positions.upper50Left50}},
  {key="0", units={positions.upper50}},
  {key="+", units={positions.upper50Right50}},

  {key="o", units={positions.left50, positions.left66, positions.left34}},
  {key="p", units={positions.centered, positions.maximized}},
  {key="å", units={positions.right50, positions.right66, positions.right34}},

  {key="l", units={positions.lower50Left50}},
  {key="ø", units={positions.lower50}},
  {key="æ", units={positions.lower50Right50}}
}
hs.fnutils.each(grid, function(entry)
  bindKey(entry.key, function()
    local units = entry.units
    local screen = hs.screen.mainScreen()
    local window = hs.window.focusedWindow()
    local windowGeo = window:frame()

    local index = 0
    hs.fnutils.find(units, function(unit)
      index = index + 1

      local geo = hs.geometry.new(unit):fromUnitRect(screen:frame()):floor()
      return windowGeo:equals(geo)
    end)
    if index == #units then index = 0 end

    currentLayout = null
    window:moveToUnit(units[index + 1])
  end)
end)

bindKey("q", function()
  hs.caffeinate.lockScreen()
end)

function pingResult(object, message, seqnum, error)
  if message == "didFinish" then
      avg = tonumber(string.match(object:summary(), '/(%d+.%d+)/'))
      if avg == 0.0 then
          hs.alert.show("No network")
      elseif avg < 200.0 then
          hs.alert.show("Network good (" .. avg .. "ms)")
      elseif avg < 500.0 then
          hs.alert.show("Network poor(" .. avg .. "ms)")
      else
          hs.alert.show("Network bad(" .. avg .. "ms)")
      end
  end
end
bindKey("n", function()
  hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult)
end)