

function initDraw()

	animateload()

end

function animateload()
	image30 = love.graphics.newImage('SNES - Super Mario World - Mario.png')
	g = anim8.newGrid(27,27, image30:getWidth(), image30:getHeight())
	testdraw = anim8.newAnimation(g('2-7',4), 0.10)
end


function updateAnimate(dt)
	for i, entity in ipairs(entities) do
		if entity.animate ~= nil then
			entity.animate:update(dt)
		end
	end

end

function drawEntities()
	
	
	-- do we need to sort for z?
	local currentZ = 0
	for i, entity in ipairs(entities) do
		entity.drawn = false
	end
	
	repeat
		local lowestNextZ = 99999
		for i, entity in ipairs(entities) do
			if entity.drawn == false and #entity.boxes > 0 and entity.visible ~= false then
				xy = split(entity.boxes[1].xy, ",")
				x = tonumber(xy[2])
				if entity.zCalc == true then entity.z = x  end
				if entity.z == currentZ  or entity.z == nil then

					if entity.drawType == "lovedraw" then drawASquare(entity) end
					if entity.drawType == "anim8" then drawAnimation(entity) end	
					entity.drawn = true
				else
					if entity.z < lowestNextZ then
						lowestNextZ = entity.z

					end
				end
			end
		end
		if lowestNextZ == currentZ then break else currentZ = lowestNextZ 	end
	until true ==	 false	

end

function drawASquare(thisEntity)

	for i, box in ipairs(thisEntity.boxes) do
		if box.color ~= nil then 
			rgb = box.color:split(",")
			love.graphics.setColor(rgb[1] or 255,rgb[2] or 255 ,rgb[3] or 255,rgb[4] or 255 )			
		end

		xy = {}
		size = {}
		local xy = split(box.xy, ",")
		box = split(box.box, ",")
		if getPointingAt("action") == thisEntity.action and thisEntity.action ~= nil then 
			love.graphics.setColor(255,0, 0, 255)
		end
		draw.rectangle("fill", tonumber(xy[1]), tonumber(xy[2]), tonumber(box[1]), tonumber(box[2]))
		love.graphics.setColor(0,0, 0, 255 )
		draw.rectangle("line", tonumber(xy[1]), tonumber(xy[2]), tonumber(box[1]), tonumber(box[2]))
		love.graphics.setColor(255,255, 255, 255 )
		if thisEntity.text ~= nil then
			love.graphics.setColor(0,0, 0, 255 )
			love.graphics.print(thisEntity.text, xy[1] + 5, xy[2] + 5)
			love.graphics.setColor(255,255, 255, 255)
		end

	end
end


function drawAnimation (entity)

	xy = split(entity.boxes[1].xy, ",")
	entity.animate:draw(image30, tonumber(xy[1]), tonumber(xy[2]), nil, 1,1)
	
end