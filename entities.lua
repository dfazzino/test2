local Grid = require ("jumper.grid") -- The grid class
local Pathfinder = require ("jumper.pathfinder") -- The pathfinder lass			

function initEntities ()

	entities = {}
	collisionBoxes = {}
	actorEntity = {}
	actorEntityNote = false
	-- entity = {}
	-- entity.name = "square2"
	-- entity.boxes = {}
	-- box = {}
	-- box.xy = "280,140"
	-- box.box = "100,100"
	-- table.insert(entity.boxes, box)
	-- entity.xy = "200,200"
	-- entity.drawType = "anim8"
	-- entity.animate = anim8.newAnimation(g('2-7',2), 0.10)
	-- entity.zCalc = true
	-- entity.z = 160
	-- entity.visible = false
	-- table.insert(entities, entity)	
	
end


function loadEntities ()

	if  line == "ENTITIES SECTION." then
		local section = "entities"
		logFile:write("Starting to add entities!\n")
		repeat
			line = scriptFile:read() 
			if line ~= nil then

				if line:startsWith("END ENTITIES") then break end
				
				local words = line:split(" ")

				for i, word in ipairs(words) do
					--finding toplevel commands
					word = word:strip()
					if word == "new"  then
						--processing a new command until another toplevel command is found
						toplevel = "new"
					end
					
				end
				if toplevel == "new" then
					entityDone = loadEntity(line)
				end
				
					
			end
		until line == nil
		
		findActor()
		
	end
	
end


function findActor()

	for i, e in ipairs(entities)  do
		if e.actor == "true" then
			actorEntity = e
			break
		end
	end
end


function loadEntity(line)
	
	words = line:split(" ")
	
	for i, word in ipairs(words)  do
		--first word should be new
		--logFile:write(word .. "\n")
		word = word:strip()

		if word == "new" then
			setupNewEntity()
			word = nil
		end
		
		if word ~= nil then
			word = word:strip()
			--debug.debug()
			if word:startsWith("entity.") then
				word = word:gsub("%.", "|")
				entityWords = split(word, "|")
				-- print (entityWords[2])

				if entityWords[2] == "name" then
					entity.name = words[i + 2]
				end
				if entityWords[2] == "drawType" then
					entity.drawType = words[i + 2]
				end
				if entityWords[2] == "zCalc" then
					entity.zCalc = words[i + 2]
				end
				if entityWords[2] == "xy" then
					entity.xy = words[i + 2]
				end
				if entityWords[2] == "visible" then
					entity.visible = words[i + 2]
				end

				if entityWords[2] == "speed" then
					entity.speed = words[i + 2]
				end
				if entityWords[2] == "actor" then
					for i, e in ipairs(entities) do
						e.actor = nil
					end
					entity.actor = words[i + 2]
				end

				if entityWords[2] == "boxes" then

					boxWords = words[i + 2]:split(",")
					
					box = {}
					box.relativexy = boxWords[1] .. "," .. boxWords[2]

					local entityxy = split(entity.xy, ",")

					box.xy = boxWords[1] + entityxy[1] .. "," .. boxWords[2]+ entityxy[2] 

					box.box = boxWords[3] .. "," .. boxWords[4]
					if boxWords[5] == "collision" then
						box.collision = true
						box.entity = table.getn(entities) + 1
						table.insert(collisionBoxes, box)
					end
					table.insert(entity.boxes, box)
				end
				
			end
		end
		if word == "add" then
			addEntity()
			logFile:flush()
			return true
			
		end
		if word == "new" then
			return true
		end
	end
	return false

	
end


function addEntity()

	table.insert(entities, entity)
	logFile:write("~~~entity" .. table.getn(entities))
	if entity.name ~= nil then logFile:write("  " .. entity.name) end
	logFile:write("~~\n")
	logFile:write("\tat " .. entity.xy .. "\n")
	logFile:write("\tdraw type: " .. entity.drawType .. "\n")
	for i, box in ipairs(entity.boxes) do
		local bxy = box.xy:split(",")
		local bwh = box.box:split(",")
		logFile:write("\tbox " .. i .. ": " .. "x " .. bxy[1] .. " y ".. bxy[2]  .. " w ".. bwh[1]  .. " h ".. bwh[2] .. "\n")
	end	
	
	logFile:write("\n------------------------------------------------------------------\n")			

end


function setupNewEntity ()

	entity = {}
	
	entity.name = "none"
	entity.boxes = {}	
	entity.drawType = "lovedraw"
	entity.zCalc = false
	entity.z = 0
	entity.xy = "0,0"
	entity.visible = false
	entity.inventory = "_"

end

function checkPointingAt(entity, x ,y)

	for i, box in ipairs(entity.boxes) do
		xy = split(box.xy, ",")
		boxx = tonumber(xy[1])
		boxy = tonumber(xy[2])
		boxbox = split(box.box, ",")
		width = tonumber(boxbox[1])
		height = tonumber(boxbox[2])
		boxEnd = boxx + width
		boxBottom = boxy + height
		x = x or UI.mousex
		y = y or UI.mousey
		if (x > boxx) and (x < boxEnd) and (y > boxy) and (y < boxBottom) then
			return true

		end
	end
	return false	
end

function getEntity(name)

	for i, entity  in ipairs (entities) do
	
		if entity.name == name then
			return entity
		end
	end
	
	return "none"

end

function analyzemap (ignore)
	ignore = ignore or "_"
	--topmost = 9999
	--leftmost = 9999
	-- bottommost = -9999

	-- for i, e in ipairs(entities) do
		-- for i , b in ipairs(e.boxes) do
			-- xy = b.box:split(",")
			-- exy = e.xy:split(",")
			-- box = b.box:split(",")
			-- if tonumber(xy[1])  < leftmost then leftmost = (exy[1] + xy[1]) end
			-- if tonumber(xy[1])  > rightmost then rightmost = (exy[1] + xy[1]) + box[1] end
			-- if tonumber(xy[2])  > bottommost then botv  ���J;�  �EWDINO ZIP j-��J�J  3��J      �TILITY LUA qB��J�J  C��J      ttommost = (xy[2] + exy[2]) + box[2] end
			-- if tonumber(event[2])  < topmost then topmost = (xy[2] + exy[2]) end
			-- if b.collision == true then
				
			-- end
		-- end
	-- end
	
	right = love.graphics.getWidth()
	bottom = love.graphics.getHeight()
	
	columnCount = math.floor(right / 30)
	rowCount = math.floor(bottom / 30) 
	map = {}
	for i = 0, rowCount, 1 do
		map[i] = {}
		for j = 0, columnCount, 1 do
			map[i][j] = 1
		end
	end
	print("ignoring " .. ignore)
	for i, e in ipairs(entities) do
		if not ignore:includes("guy") then
		-- if 1 == 0 then
			for j, b in ipairs(e.boxes) do
				if b.collision == true then
					x, y, right, bottom = splitBoxData(e, b)
					x = math.floor(x / 30)
					y = math.floor(y / 30)
					right = math.floor(right / 30)
					bottom = math.floor(bottom / 30)
					
					for k = x, right, 1 do
						for l = y, bottom, 1 do
							map[l][k] = 0
						end
					end
				end
			end
		end
	end
	
end


function splitBoxData(entity, box)
	local exy = entity.xy:split(",")
	local xy = box.relativexy:split(",")
	local thisbox = box.box:split(",")
	return xy[1] + exy[1], xy[2] + exy[2], xy[1] + exy[1] + thisbox[1], xy[2] + exy[2] + thisbox[2]

end


function moveToEntity(entity, toEntity)
	local xy  = toEntity.xy:split(",")
	entity.walkingToEntity = toEntity
	return	pathFinding("move" .. " " .. entity.name .. " " .. math.floor(xy[1] / 30) .. "," .. math.floor(xy[2] / 30 ), "_" .. entity.name .. "_" .. toEntity.name ..  "_", true)	

end


function pathFinding (command, ignore, retPlease)

	local pathEntity = {}
	if command == nil then
		if  actorEntity.name ~= nil then
			pathEntity = actorEntity
			endx = math.floor(UI.mousex / 30)
			endy = math.floor(UI.mousey / 30)
		else
			if actorEntityNote == false then
				logFile:write("\nNo actor entity selected; proceeding to use left click as action menu since this game doesn't seem to have an actor in it")
				actorEntityNote = true
				checkEvents("click")
			else
				checkEvents("click")
			end
		end
	else
		commandWords = command:split(" ")
		actor = commandWords[2]
		tempxy = commandWords[3]
		tempxy = tempxy:split(",")
		endx = tonumber(tempxy[1])
		endy = tonumber(tempxy[2])
		pathEntity = getEntity(actor)
		
	end
	if pathEntity.name ~= nil then
		analyzemap(ignore)	

	-- Value for walkable tiles
		local walkable = 1

	-- Library setup

	-- Creates a grid object
		local grid = Grid(map)
	-- Creates a pathfinder object using Jump Point Search
		local myFinder = Pathfinder(grid, 'JPS', 1)

	-- Define start and goal locations coordinates
		-- entity =  getEntity("guy2") or 0
		xy =  pathEntity.xy:split(",")
		startx =  math.floor(xy[1]/30)
		starty =  math.floor(xy[2]/30)	
		print(xy[1], xy[2], endx, endy)
	-- Calculates the path, and its length
		local path, length = myFinder:getPath(startx, starty, endx, endy)
		entityPath = ""
		checkActionQueue({"moveTo", pathEntity.name}, true)
		if path then

		  -- print(('Path found! Length: %.2f'):format(length))
			for node, count in path:iter() do
				print(('Step: %d - x: %d - y: %d'):format(count, node.x, node.y))
				entityPath = entityPath .. "moveTo " .. pathEntity.name .. " " ..  math.floor(node.x * 30) .. "," .. math.floor(node.y * 30) .. "/"
			end
			
			if retPlease == true then
				return entityPath
			else
				local event = {}
			
				event.id = 1
				event.onClick = false
				event.onKeyPress = false
				event.always = true
				event.time = nil
				event.logic = nil
				event.trueactions = string.sub(entityPath, 1, -2)
				event.delete = true
				table.insert(events, event)
			end
		end
	end
end


function moveEntityTo(name, xy, actionWords)
	local entity = getEntity(name)
	local stop = nil
	if entity ~= "none" then
	-- local box = split(entity.boxes[1].box, ",")
	-- local xy = split(entity.boxes[1].xy, ",")
	-- entity.boxes[1].xy = (tonumber(xy[1])- tonumber(box[1] / 2)) .. (tonumber(xy[2]) - tonumber(box[2] / 2))
		entity.currAction = actionWords
		local newxy = split(xy, ",")
		local entityxy = split(entity.xy, ",")
			--first let's see if we're close enough to target entity
			entity.x = tonumber(entityxy[1])
			entity.y = tonumber(entityxy[2])
			
				dist = distanceFrom(entity.x, entity.y, newxy[1], newxy[2])
				dist = dist / (entity.speed or 200)
				if entity.flux ~= nil then
					entity.flux:stop()
				end
				entity.flux = flux.to(entity,dist, {x = tonumber(newxy[1]), y = tonumber(newxy[2])})
				:ease("linear")
				:oncomplete(function() 
					entity.flux:stop() 
					checkActionQueue(entity.currAction)
				end)
	end
end


function distanceFrom(x1,y1,x2,y2) 
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end


function moveEntityDirect(name, entity, xy)

	entity = entity or getEntity(name)
	entity.xy = xy
	for i, b in ipairs(entity.boxes) do
		local xy1 = split(xy, ",") 
		local xy2 = split(b.relativexy, ",")
		b.xy = xy1[1] + xy2[1] .. "," .. xy1[2] + xy2[2]
	
	end


end

function moveEntity(name, xy1, entity, xy2)
	--local box = split(entity.boxes[1].box, ",")
	if name ~= nil then 
		entity = getEntity(name)
	end

	if entity ~= "none" then
		--entity.boxes[1].xy = (tonumber(xy[1])- tonumber(box[1] / 2)) .. (tonumber(xy[2]) - tonumber(box[2] / 2))

		local entityxy = split(entity.xy, ",")
		local xyIn = split(xy1, ",")
		for i, box in ipairs(entity.boxes) do
			if box.collision == true then
				--if any of the collision boxes collide, don't move! 
				cantMove = false
				cantMove = collisionCheck(box,xyIn[1], xyIn[2])
				if cantMove == true then break end
			end
		end
		if cantMove ~= true then 
			y = entityxy[2] + xyIn[2] 
			x = entityxy[1] + xyIn[1]		
			entity.xy = x .. "," .. y
			for i, box in ipairs(entity.boxes) do
	
				local xy2 = split(box.relativexy, ",")
				box.xy = xy2[1] + x .."," ..  xy2[2] + y
			end
		end	
	end
end


function updateXYtoFlux()

	for i, e in ipairs(entities) do

		if e.flux ~= nil then
			e.xy = e.x .. "," .. e.y 
			
			for i, box in ipairs(e.boxes) do
				
				local xy2 = split(box.relativexy, ",")
				box.xy = e.x + xy2[1] .."," ..  e.y + xy2[2]
				
			end

			if e.walkingToEntity ~= nil then
				local tempxy = e.walkingToEntity.xy
				dist = distanceFrom(e.x, e.y, tonumber(tempxy[1]), tonumber(tempxy[2]))
				if dist < 350 then 
					e.flux:stop()
					checkActionQueue(e.currAction)
				end
				
				--TO DO-
				--Check all corners and maybe midpoints to make sure
				--moving entities doesn't merge into target.
			end	

		end

	end

end

function getPointingAt(value)

	retValue = ""
	local e
	for i, entity in ipairs(entities) do
		if entity.visible ~= false then
			for i, box in ipairs(entity.boxes) do
				entityxy = entity.xy:split(",")
				xy = split(box.relativexy, ",")
				
				boxx = tonumber(xy[1]) + entityxy[1]
				boxbox = split(box.box, ",")
				boxy = tonumber(xy[2])+ entityxy[2]
				width = tonumber(boxbox[1])
				height = tonumber(boxbox[2])
				boxEnd = boxx + width
				boxBottom = boxy + height
		
				if (UI.mousex > boxx) and (UI.mousex < boxEnd) and (UI.mousey > boxy) and (UI.mousey < boxBottom) then
					
					if value == "name" then
						retValue = entity.name
						e = entity
						break
					end
				if value == "action" then
						retValue = entity.action
						e = entity
						break
					end

				end
			end
		end
	end	
	return retValue, e
end
	
	
function collisionCheck(box1, x, y, box2 )

	x = x or 0
	y = y or 0
	if box2 == nil then
		for i, box3 in ipairs(collisionBoxes) do
			if box3.entity ~= box1.entity then
				test = collisionMath(box1, box3, x, y)
				if test == true then return true end
			end
		end
	else
		collisionMath(box1, box2, x, y)
	end
end


function collisionMath (box1, box2, x, y)

	--parse box data
	local entity = entities[box1.entity]
	local entityxy = entity.xy:split(",")
	local xy = split(box1.relativexy, ",")
	local boxbox = split(box1.box, ",")
	local boxwidth = tonumber(boxbox[1])
	local boxheight = tonumber(boxbox[2])
	
	local b1x = tonumber(xy[1]) + entityxy[1] + x
	local b1y = tonumber(xy[2])+ entityxy[2] + y
	local b1End = b1x + boxwidth
	local b1Bot = b1y + boxheight

	entity = entities[box2.entity]
	entityxy = entity.xy:split(",")
	xy = split(box2.relativexy, ",")
	boxbox = split(box2.box, ",")
	boxwidth = tonumber(boxbox[1])
	boxheight = tonumber(boxbox[2])		
		
	b2x = tonumber(xy[1]) + entityxy[1]
	b2y = tonumber(xy[2])+ entityxy[2]
	b2End = b2x + boxwidth
	b2Bot = b2y + boxheight
	
	if 
	((b1x > b2x) and (b1x < b2End) or 
	((b1End > b2x) and b1End < b2End)) and
	((b1y > b2y) and (b1y < b2Bot) or 
	((b1Bot > b2y) and b1Bot < b2Bot))
	or
	((b2x > b1x) and (b2x < b1End) or 
	((b2End > b1x) and b2End < b1End)) and
	((b2y > b1y) and (b2y < b1Bot) or 
	((b2Bot > b1y) and b2Bot < b1Bot))
	then
		return true

	end


end


function removeInventory(itemID, name)
	
	local haveItem = false
	local thisEntity = getEntity(name)	
	if thisEntity.inventory:includes("_" .. itemID .. "_") then
		thisEntity.inventory = thisEntity.inventory:gsub(itemID .. "_", "")				
	end	
end


function addInventory(itemID, name)
	
	local haveItem = false
	local thisEntity = getEntity(name)	
	if thisEntity.inventory:includes("_" .. itemID .. "_") then
		haveItem = true
	end
	
	if haveItem == false then
		for i, entity in ipairs(entities) do
			if entity.inventory:includes("_" .. itemID .. "_") then
				entity.inventory = entity.inventory:gsub(itemID .. "_", "")				
			end

		end
		
		thisEntity.inventory = thisEntity.inventory .. itemID .. "_"
	end
	
	
end
