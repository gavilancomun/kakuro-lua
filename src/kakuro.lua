-- utility functions

function map(func, t)
  local result = {}
  for _,v in ipairs(t) do
    table.insert(result, func(v))
  end
  return result
end

function mapn(func, ...)
  local result = {}
  local i = 1
  local arg_length = table.getn(arg)
  while true do
    local arg_list = map(function(a) return a[i] end, arg)
    if table.getn(arg_list) < arg_length then return result end
    table.insert(result, func(unpack(arg_list)))
    i = i + 1
  end
end

function filter(func, t)
  local result = {}
  for _,v in ipairs(t) do
    if func(v) then table.insert(result, v) end
  end
  return result
end

function concat(t1, t2)
  local result = {unpack(t1)}
  for _,v in ipairs(t2) do
    table.insert(result, v)
  end
  return result
end

-- kakuro solver

Cell = {}

function Cell:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

Empty = Cell:new()

function Empty:draw()
  return "   -----  "
end

Down = Cell:new()

function Down:draw()
  return string.format("   %2d\\--  ", self.down)
end

Across = Cell:new()

function Across:draw()
  return string.format("   --\\%2d  ", self.across)
end

DownAcross = Cell:new()

function DownAcross:draw()
  return string.format("   --\\%2d  ", self.down, self.across)
end

Value = Cell:new()

function Value:draw()
  if 1 == #self.values then
    return "     " .. self.values[1] .. "    "
  else
    local result = {}
    for k,v in ipairs(self.values) do
	  table.insert(result, (v and k or "."))
	end
	return table.concat(result, "")
  end
end

function v()
  return Value:new{values = {1, 2, 3, 4, 5, 6, 7, 8, 9}}
end

function e()
  return Empty:new()
end

function d(n)
  return Down:new{down = n}
end

function a(n)
  return Across:new{across = n}
end

function da(d, a)
  return DownAcross:new{down = d, across = a}
end

function drawRow(row)
  local result = map(function (v) return v:draw() end, row)
  return table.concat(result, "") .. "\n"
end

function drawGrid(grid)
  return table.concat(map(drawRow, grid), "")
end

grid1 = {{e(), d(4), d(22), e(), d(16), d(3)},
         {a(3), v(), v(), da(16, 6), v(), v()},
         {a(18), v(),  v(), v(), v(), v()},
         {e(), da(17, 23),  v(), v(), v(), d(14)},
         {a(9), v(), v(), a(6), v(), v()},
         {a(15), v(), v(), a(12), v(), v()}}

print(drawGrid(grid1))

