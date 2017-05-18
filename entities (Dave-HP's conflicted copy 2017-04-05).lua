
function initEntities ()

	entities = {}


	entity = {}
	entity.name = "square2"
	entity.boxes = {}
	box = {}
	box.xy = "280,140"
	box.box = "100,100"
	table.insert(entity.boxes, box)
	entity.xy = "200,200"
	entity.drawType = "anim8"
	entity.animate = anim8.newAnimation(g('2-7',2), 0.10)
	entity.zCalc = true
	entity.z = 160
	entity.visible = false
	table.insert(entities, entity)	
	
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
		
	end
	
end


function loadEntity(line)
	
	words = line:split(",")
	
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

				if entityWords[2] == "name" then
					entity.name = words[i + 2]
				end
				if entityWords[2] == "drawType" then
					entity.drawType = words[i + 2]
				end
				if entityWords[2] == "zCalc" then
					entity.drawType = words[i + 2]
				end
				if entityWords[2] == "box" then
					box = {}
					box.xy = boxWords[1] .. "," .. boxWords[2]
					box.box = boxWords[3] .. "," .. boxWords[4]
					table.insert(entity.boxes, box)
				end
				
			end
		end
		if word == "add" then
			addentity()
			logFile:flush()
			return true
			
		end
		if word == "new" then
			return true
		end
	end
	return false

	
end


function setupNewEntity ()

	entity = {}
	
	entity.name = "none"
	entity.boxes = {}	
	entity.drawType = "lovedraw"
	entity.zCalc = false
	entity.z = 0
	entity.visible = false
	table.insert(entities, entity)

end

function checkPointingAt(entity)

	for i, box in ipairs(entity.boxes) do
		xy = split(box.xy, ",")
		boxx = tonumber(xy[1])
		boxy = tonumber(xy[2])
		boxbox = split(box.box, ",")
		width = tonumber(boxbox[1])
		height = tonumber(boxbox[2])
		boxEnd = boxx + width
		boxBottom = boxy + height

		if (UI.mousex > boxx) and (UI.mousex < boxEnd) and (UI.mousey > boxy) and (UI.mousey < boxBottom) then
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


function moveEntityTo(name, xy)
	entity = getEntity(name)
	--local box = split(entity.boxes[1].box, ",")
	--local xy = split(entity.boxes[1].xy, ",")
	--entity.boxes[1].xy = (tonumber(xy[1])- tonumber(box[1] / 2)) .. (tonumber(xy[2]) - tonumber(box[2] / 2))
	entity.boxes[1].xy = xy
end


function moveEntity(name, xy1)
	entity = getEntity(name)
	--local box = split(entity.boxes[1].box, ",")
	local xy2 = split(entity.boxes[1].xy, ",")
	local xy3 = split(xy1, ",")

	x = xy2[1] + xy3[1]
	y = xy2[2] + xy3[2] 
	--entity.boxes[1].xy = (tonumber(xy[1])- tonumber(box[1] / 2)) .. (tonumber(xy[2]) - tonumber(box[2] / 2))
	entity.boxes[1].xy = x .. "," .. y
end


function getPointingAt(value)

	retValue = ""
	
	for i, entity in ipairs(entities) do
		for i, box in ipairs(entity.boxes) do
			xy = split(box.xy, ",")
			boxx = tonumber(xy[1])
			boxbox = split(box.box, ",")
			boxy = tonumber(xy[2])
			width = tonumber(boxbox[1])
			height = tonumber(boxbox[2])
			boxEnd = boxx + width
			boxBottom = boxy + height
	
			if (UI.mousex > boxx) and (UI.mousex < boxEnd) and (UI.mousey > boxy) and (UI.mousey < boxBottom) then
				
				if value == "name" then
					retValue = entity.name

				end

			end
		end
	end	
	return retValue	
end
	