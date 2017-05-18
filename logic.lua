logic = {}


function initLogic()

	local aLogic = {}
	aLogic.id = 1
	aLogic.ifString = "pointing at *"
	table.insert(logic, aLogic)

	local aLogic = {}
	aLogic.id = 2
	aLogic.ifString = "pointing at nothing"
	table.insert(logic, aLogic)
	
	local aLogic = {}
	aLogic.id = 3
	aLogic.ifString = "keydown right"
	table.insert(logic, aLogic)
	
	local aLogic = {}
	aLogic.id = 4
	aLogic.ifString = "keydown left"
	table.insert(logic, aLogic)	

	local aLogic = {}
	aLogic.id = 5
	aLogic.ifString = "keydown up"
	table.insert(logic, aLogic)	
	
	local aLogic = {}
	aLogic.id = 6
	aLogic.ifString = "keydown down"
	table.insert(logic, aLogic)	
	end


function loadLogic(line)

	local aLogic = {}
	local thisLogic  = ""

	logicLines = line:split("=")
	line = logicLines[2]:strip()
	logicLines = line:split("and")
	for i, logicLine in ipairs(logicLines) do
		foundLogic = false
		logicLine = logicLine:strip()
		for j, aLogic in ipairs(logic) do
			if aLogic.ifString == logicLine then
				if thisLogic == "" then
					thisLogic = aLogic.id
				else
					thisLogic = thisLogic .. "," .. aLogic.id
				end
				foundLogic = true
				break
			end
		end
		if foundLogic ~= true then
			local aLogic = {}
			
			aLogic.id =  table.getn(logic) + 1
			aLogic.ifString = logicLine
			table.insert(logic, aLogic)
			if thisLogic == "" then
				thisLogic = aLogic.id
			else
				thisLogic = thisLogic .. "," .. aLogic.id
			end

		end
	end
	
	return thisLogic
	
end




function checkLogic(ids, trueactions, falseactions, delete)

	if type(ids) == "string" then
		idList = split(ids, ",")
	else
		idList = {}
		table.insert(idList, ids)
	end
	
	ifWords = {}
	
	for i, logicID in ipairs(idList) do
		
		local aLogic = logic[tonumber(logicID)]
		ifWords = split(aLogic.ifString, " ")
		
		operand1 = trim(ifWords[1])
		operation = trim(ifWords[2])
		if ifWords[3] ~= nil then operand2 = trim(ifWords[3]) end
		operand1 = SystemValues(operand1)
		operand2 = SystemValues(operand2)
		operation = SystemValues(operation)
		operand1 = UserValues2(operand1)
		operand2 = UserValues2(operand2)
		local response
		if operation == "=" or operation == ">" or operation == "<" then
			response = mathLogic(operation, operand1, operand2)
		end	
		if operation == "at" then
			response = entityLogic(aLogic.ifString)
		end		
		if operation == "has" then
			response = inventoryLogic(operand1, operand2)
		end
		if operand1 == "keydown" then
			response = keyDownLogic(operation)
		end
		
		if response == false  then
			if i == #idList then
				if falseactions ~= nil then
					doAction(falseactions)
					if delete == "true" then table.remove(events, i) end

				end 
			end
		return false
		end
	end

	doAction(trueactions)
	
end

function mathLogic(operation, operand1, operand2)

	nOperand1 = tonumber(operand1)
	nOperand2 = tonumber(operand2)
	nOperand1 = operand1
	nOperand2 = operand2
	-- if type(nOperand1) == "number" and type (nOperand2) == "number" then
		if operation == "=" then
			if nOperand1 == nOperand2 then
				return true
			else
				return false
			end
		elseif operation == "<" then
			if nOperand1 < nOperand2 then
				return true
			else
				return false
			end
		elseif operation == ">" then 
			if nOperand1 > nOperand2 then
				return true
			else
				return false
			end
			
		end
		
	-- end

end


function keyDownLogic(key)

    -- if not imgui.GetWantCaptureKeyboard() then
		return keyboard.isDown(key)
	-- end
end


function entityLogic(ifString)

	logicWords = {}
	logicWords = split(ifString, " ")
	
	verb = logicWords[1]
	clarifier = logicWords[2]
	entityname = logicWords[3]
	local splitEntities = {}
	if entityname  == "*" or entityname == "nothing" then
		for i, entity in ipairs(entities) do
			table.insert(splitEntities, entity.name)

		end
	else
		splitEntities = split(entityname,",")
	end
	
	for i, entity in ipairs(splitEntities) do
		local entity = getEntity(entity)
		
		if entity ~= "none" then
			if verb == "pointing" then
				if clarifier == "at" then
					pointingAt = checkPointingAt(entity)
					if pointingAt == true then break end
				end
			end
		end	
	end 
	--print (pointingAt)
	if entityname == "nothing" then
		return not pointingAt
	else
		return pointingAt
	end
end


function inventoryLogic (name, itemID)

	local thisEntity = getEntity(name)	
	if thisEntity.inventory:includes("_" .. itemID .. "_") then

		return true
	end
	
	return false

end


