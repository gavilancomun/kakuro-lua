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
  if 1 == table.getn(self.values) then
    return "     " .. self.values[1] .. "    "
  else
    result = ""
    for i = 1, 9 do
	  result = result .. ((self.values[i]) and i or ".")
	end
	return result
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

print(e():draw())

print(d(1):draw())

print(a(2):draw())

print(da(3, 4):draw())

print(v():draw())
