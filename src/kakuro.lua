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
  local print_r_cache = {}
  local function sub_print_r(t, indent)
    if print_r_cache[tostring(t)] then
      print(indent .. "*" .. tostring(t))
    else
      print_r_cache[tostring(t)] = true
      if type(t) == "table" then
        for pos,val in pairs(t) do
          if type(val) == "table" then
            print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
            sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
            print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
          elseif type(val) == "string" then
            print(indent .. "[" .. pos .. '] => "' .. val .. '"')
          else
            print(indent .. "[" .. pos .. "] => " .. tostring(val))
          end
        end
      else
        print(indent .. tostring(t))
      end
    end
  end
  if type(t) == "table" then
    print(tostring(t) .. " {")
    sub_print_r(t, "  ")
    print("}")
  else
    sub_print_r(t, "  ")
  end
  print()
end

-- http://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua

function equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
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

function allDifferent(nums)
  return #nums == #setAsList(toSet(nums))
end

function conj(first, second)
  local result = {unpack(first)} 
  table.insert(result, second)
  return result
end

function concatLists(first, second)
  local result = {unpack(first)}
  for k,v in pairs(second) do
    table.insert(result, v)
  end
  return result
end

function flatten1(listOfLists)
  local result = {}
  for k, v in pairs(listOfLists) do
    result = concatLists(result, v) 
  end
  return result
end

function take(n, array)
  local result = {}
  i = 1
  for k, v in pairs(array) do
    if i <= n then
      table.insert(result, v)
    end
    i = i + 1
  end
  return result
end

function drop(n, array)
  local result = {}
  i = 1
  for k, v in pairs(array) do
    if (i > n) then
      table.insert(result, v)
    end
    i = i + 1
  end
  return result
end

function takeWhile(f, array)
  local result = {}
  for k, v in pairs(array) do
    if f(v) then
      table.insert(result, v)
    else
      return result
    end
  end
  return result
end

function permute(vs, target, soFar)
  if (target >= 1) then
    if #soFar == (#vs - 1) then
      return {conj(soFar, target)}
    else
      local step1 = vs[#soFar + 1]
      local step2 = step1.values
      local step3 = map(function (n)
                          return permute(vs, (target - n), conj(soFar, n))
                        end, step2)
      return flatten1(step3)
    end
  else
    return {}
  end
end

function permuteAll(vs, total)
  return permute(vs, total, {})
end

function containsKey(list, value)
  local result = false
  for k, v in pairs(list) do
    if k == value then
      return true
    end
  end
  return result
end

function containsValue(list, value)
  local result = false
  for k, v in pairs(list) do
    if v == value then
      return true
    end
  end
  return result
end

function isPossible(cell, n) 
  return containsValue(cell.values, n)
end

function transpose(m)
  return mapn(function (...)
                  return {...}
                end, unpack(m))
end

function partitionBy(f, coll)
  if (nil == coll) or (0 == #coll) then
    return {}
  else
    local head = coll[1]
    local fx = f(head)
    local group = takeWhile(function (y)
                            return fx == f(y)
                          end, coll)
    return concatLists({group}, partitionBy(f, drop(#group, coll)))
  end
end

function partitionAll(n, step, coll)
  if (nil == coll) or (0 == #coll) then
    return {}
  else
    return concatLists({take(n, coll)}, partitionAll(n, step, drop(step, coll)))
  end
end

function partitionN(n, coll)
  return partitionAll(n, n, coll)
end

function solveStep(cells, total)
  local final = #cells
  local perms1 = permuteAll(cells, total)
  local perms2 = filter(function (v)
                          return isPossible(cells[final], v[final])
                        end,  perms1)
  local perms3 = filter(allDifferent, perms2)
  local perms4 = transpose(perms3)
  return map(function (v)
               return Value:new{values = v}
             end, perms4)
end

function solvePair(k, p)
  local nvs = p[1]
  local vs = p[2]
  if 0 == #vs then
    return nvs
  else 
    return concatLists(nvs,
                       solveStep(vs, nvs[#nvs][k]))
  end
end

function solveLine(line, pairSolver)
  print("solveLine ")
  print_r(line)
  local pairs = partitionAll(2,  partitionBy(function (v) return v.values end, line))
  local step1 = map(pairSolver, pairs)
  return flatten1(step1)
end

function solveRow(row)
  return solveLine(row, function (v) return solvePair(function (x) return x.across end, v) end)
end

function solveColumn(column)
  return solveLine(column, function (v) return solvePair(function (x) return x.down end, v) end)
end

function solveGrid(grid)
  local step1 = map(solveRow, grid)
  local step2 = transpose(step1)
  local step3 = map(solveColumn, step2)
  return transpose(step3)
end

function solver(grid)
  local g = solveGrid(grid)
    if equals(g, grid) then
      return g
    else
     print(drawGrid(g))
     return solver(g)
   end
 end

grid1 = {{e(), d(4), d(22), e(), d(16), d(3)},
         {a(3), v(), v(), da(16, 6), v(), v()},
         {a(18), v(),  v(), v(), v(), v()},
         {e(), da(17, 23),  v(), v(), v(), d(14)},
         {a(9), v(), v(), a(6), v(), v()},
         {a(15), v(), v(), a(12), v(), v()}}

print(drawGrid(grid1))

t1 = {1, 2, 3}
t2 = {4, 5, 6, 7}
diffs = {1, 3, 3, 5}

print("conj")
print_r(conj({}, 9))
print_r(conj(t1, 9))

print_r(toSet(diffs))
print_r(setAsList(toSet(diffs)))

print("diffs ", #diffs, " ", allDifferent(diffs))
table.remove(diffs, 2)
print("diffs ", #diffs, " ", allDifferent(diffs))

print("\nconcat")
print_r(concatLists(t1, t2))
print("\nflatten")
print_r(flatten1({t1, t2}))

print("permute")
print_r(permuteAll({v(), v()}, 11))
print_r(permuteAll({v(), v(), v()}, 11))
print_r(filter(allDifferent, permuteAll({v(), v(), v()}, 11)))

m = {{1, 1, 1}, {2, 2, 2}, {3, 3, 3}, {4, 4, 4}}
print("transpose")
print_r(m)
print_r(transpose(m))

print "partition"
print_r(partitionN(2, {1, 2, 3, 4, 5, 6}))
print_r(partitionBy(function (n) return 2 * n < 10 end, {1, 2, 3, 4, 5, 6}))

print(drawGrid(solver(grid1)))

