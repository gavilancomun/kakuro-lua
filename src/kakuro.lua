-- kakuro solver

Empty = {}

function Empty.draw ()
  return "   -----  "
end

Down = { down = 0 }

function Down.draw()
  return string.format("   %2d\\--  ", Down.down)
end

Across = { across = 0 }

function Across.draw()
  return string.format("   --\\%2d  ", Across.across)
end

DownAcross = { down = 0, across = 0 }

function DownAcross.draw()
  return string.format("   --\\%2d  ", DownAcross.down, DownAcross.across)
end

Value = {values = {}}

function Value.draw()
  if 1 == #Value.values then
    return "     " .. Value.values[1] .. "    "
  else
    result = ""
    for i = 1, 10 do
	  result = result .. (Value.values[i]) and i or "."
	end
	return result
  end
end
