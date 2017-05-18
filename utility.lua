function initLove2D ()

	draw = love.graphics
	keyboard = love.keyboard
	mouse = love.mouse
	timer = love.timer

end


function split(str, pat)
   str = str or ''
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function trim(s)
  return s:match "^%s*(.-)%s*$"
end


function drawInformation()


	love.graphics.print(math.floor(UI.mousex  / 30) .. "," .. math.floor(UI.mousey / 30), 500, 500)
	value, entity = getPointingAt("name")
	if value ~= "" then 
		h = 1
		for i, ev in pairs(entity) do
			love.graphics.print(i .. ", " .. tostring(ev), 590 , 400 + (h * 10))
			h = h +  1
		end
	end
end

-- a simplified http.get function
-- function http.get(u)
  -- local t = {}
  -- local respt = http.request{
    -- url = u,
    -- sink = ltn12.sink.table(t)
  -- }
  -- -- print (respt)
  -- return table.concat(t)
-- end