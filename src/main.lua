push = require 'libs.push'

local MOBILE_OS = (love._version_major > 0 or love._version_minor >= 9) and (love.system.getOS() == 'Android' or love.system.getOS() == 'OS X')
local WEB_OS = (love._version_major > 0 or love._version_minor >= 9) and love.system.getOS() == 'Web'
local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 720
local VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 512, 288
local VW_WIDTH_RATIO, VW_HEIGHT_RATIO = VIRTUAL_WIDTH / WINDOW_WIDTH, VIRTUAL_HEIGHT / WINDOW_HEIGHT
local GAME_TITLE = 'Hello touch LÖVE2D!!'
local FONT_SIZE = 16

local touches = {}

function love.load()
  if arg[#arg] == "-debug" then 
    require("mobdebug").start() 
  end
  
  -- Set up window
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = MOBILE_OS,
    resizable = not MOBILE_OS
  })
  love.window.setTitle(GAME_TITLE)
  
  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  font = love.graphics.newFont(FONT_SIZE)
  love.graphics.setFont(font)
  
  love.keyboard.keysPressed = {}
  input_enabled = true
end

function love.update(dt)
  -- exit if esc is pressed
  if love.keyboard.keysPressed['escape'] then
    love.event.quit()
  end
  
  touches = love.touch.getTouches()
  
  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end
  
-- Callback that processes key strokes just once
-- Does not account for keys being held down
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.draw()
  push:start()
  love.graphics.print(GAME_TITLE, 0, FONT_SIZE * 0)
  
  for i, touch in ipairs(touches) do
    local screen_x, screen_y = love.touch.getPosition(touch)
    local x, y = math.floor(screen_x * VW_WIDTH_RATIO + 0.5), math.floor(screen_y * VW_HEIGHT_RATIO + 0.5)
    love.graphics.print("touch " .. tostring(touch) .. " @ (" .. x .. "," .. y .. ")", 0, FONT_SIZE * i)
  end

  push:finish()
end