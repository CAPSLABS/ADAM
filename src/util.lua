function Shallowcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function Read_file(path)
  local file = love.filesystem.newFile(path)
  file:open("r")
  local data = file:read()
  file:close()
  return data
end

function Split(s, sep)
  local tab = {}
  for chunk in string.gmatch(s, "[^" .. sep .. "]+") do
    table.insert(tab, chunk)
  end
  return tab
end

function DrawPerformance()
  love.graphics.setFont(WORLD.media.defaultfont)
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
  local delta = love.timer.getAverageDelta()
  love.graphics.print(string.format("\t\t\tAverage DT: %.3f ms", 1000 * delta), 10, 10)
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function Set(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

-- damagableStati = Set({"walking"}),
-- if enemy.curAnim[damagebbleStati] then
--    do something

function Range(a, b, step)
  if not b then
    b = a
    a = 1
  end
  step = step or 1
  local f = step > 0 and function(_, lastvalue)
      local nextvalue = lastvalue + step
      if nextvalue <= b then
        return nextvalue
      end
    end or step < 0 and function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue >= b then
          return nextvalue
        end
      end or function(_, lastvalue)
      return lastvalue
    end
  return f, nil, a - step
end

function DisplayTime(time)
  local days = math.floor(time / 86400)
  local hours = math.floor((time % 86400) / 3600)
  local minutes = math.floor((time % 3600) / 60)
  local seconds = math.floor((time % 60))
  return string.format("%02d:%02d:%02d", hours, minutes, seconds)
  --return string.format("%d:%02d:%02d:%02d", days, hours, minutes, seconds)
end

function SetDebug()
  if DEBUG then
    WORLD.player.money = 10000
    WORLD.player:lvlUpBoom()
    WORLD.player:lvlUpFire()
    WORLD.player:lvlUpFire()
    WORLD.player:lvlUpFast()
    WORLD.player:lvlUpFast()
    WORLD.player:lvlUpBerserk()
    WORLD.player:lvlUpBerserk()
    WORLD.player:lvlUpBurst()
  end
end

function LoadMap()
  _G.map = LoadTiledMap("assets/tile/", WORLD.map)
end
