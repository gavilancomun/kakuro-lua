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

-- https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/

function print_r (t)  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

--

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

function toSet(list)
  local set = {}
  for k,v in pairs(list) do
    set[v] = true
  end
  return set
end

function setAsList(set)
  local result = {}
  for k, v in pairs(set) do
    table.insert(result, k)
  end
  return result
end

function uniqueCount(list)
  return #setAsList(toSet(list))
end

function allDifferent(nums)
  return #nums == uniqueCount(nums)
end

function conj(first, second)
  local result = {unpack(first)}
  for k,v in pairs(second) do
    table.insert(result, v)
  end
  return result
end

function permute(vs, target, soFar)
  if (target >= 1) then
    if #soFar == (#vs - 1) then
      return {conj(soFar, target)}
    else
    end
  else
    return {}
  end
end

grid1 = {{e(), d(4), d(22), e(), d(16), d(3)},
         {a(3), v(), v(), da(16, 6), v(), v()},
         {a(18), v(),  v(), v(), v(), v()},
         {e(), da(17, 23),  v(), v(), v(), d(14)},
         {a(9), v(), v(), a(6), v(), v()},
         {a(15), v(), v(), a(12), v(), v()}}

print(drawGrid(grid1))

diffs = {1, 3, 3, 5}
print_r(toSet(diffs))
print_r(setAsList(toSet(diffs)))

print("diffs ", #diffs, " ", uniqueCount(diffs), " ", allDifferent(diffs))
table.remove(diffs, 2)
print("diffs ", #diffs, " ", uniqueCount(diffs), " ", allDifferent(diffs))

print("\nconj")
t1 = {1, 2, 3}
t2 = {4, 5, 6, 7}
print_r(conj(t1, t2))

