local hyper = { "cmd", "alt", "ctrl", "shift" }



hs.hotkey.bind(hyper, "0", function()
  hs.reload()
end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()



local applicationHotkeys = {
    b = 'Google Chrome',
    t = 'iTerm',
    m = 'Mail',
    c = 'Calendar',
    v = 'Visual Studio Code',
    s = 'Slack'
  }
  for key, app in pairs(applicationHotkeys) do
    hs.hotkey.bind(hyper, key, function()
      hs.application.launchOrFocus(app)
    end)
  end

hs.hotkey.bind(hyper, "W", function()
    hs.alert.show(
       "Hello World!",
       {
          textFont= "Comic Sans MS",
          textSize=72,
          fadeOutDuration=1
       }
    )
end)

hs.window.animationDuration = 0
hs.hotkey.bind(hyper, "Left", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)
hs.hotkey.bind(hyper, "Up", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)
hs.hotkey.bind(hyper, "k", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToScreen(win:screen():next())
end)
hs.hotkey.bind(hyper, "Right", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind(hyper, "L", function()
  hs.caffeinate.lockScreen()
end)