actions = {}
actionQueue = {}


function initActions()

	local action = {}

	action.command = "start chat hi" 
	addAction(action) 
	 
end
	


function addActionToQueue(actions, waitAction) 

	tempAction = {}
	tempAction.actions = actions
	tempAction.waitaction = waitAction
	table.insert(actionQueue, tempAction)
	print("TESTTEST")
	
end	
	

function checkActionQueue(actionWords, cancelActions)
	for i, a in ipairs(actionQueue) do
			
	print(actionWords[1], actionWords[2], a.waitaction[1], a.waitaction[2])
		if a.waitaction == actionWords or (a.waitaction[1] == actionWords[1] and a.waitaction[2] == actionWords[2] and cancelActions == true) then
			if cancelActions ~= true then doAction(a.actions,nil, dt) else  print("CANCEL") end
			a.remove = true
			if cancelActions ~= true then break end
		end
	end
	i = 1
	while i <= #actionQueue do
		if actionQueue[i].remove == true then
			table.remove(actionQueue, i)
		else
			i=i+1
		end
	end

end	
	
	
function loadActions(line)

	thisActions = ""
	actionLines = line:split("=")
	line = actionLines[2]:strip()
	
	if line:includes("/") then
		barList = line:split("/")
	else
		barList = {}
		table.insert(barList, line)
	end
	for h, barLine in ipairs(barList) do 
		actionLines = barLine:split("then")
		for i, actionLine in ipairs(actionLines) do
			localLine = ""
			foundAction = false
			actionLine = actionLine:strip()
			for j, action in ipairs(actions) do
				if action.command == actionLine then
					if localLine == "" then
						localLine = action.id
					else
						localLine = localLine .. "," .. action.id
					end
					foundAction = true
					break
				end
			end
			if foundAction ~= true then
				local action = {}
				
				action.id = table.getn(actions) + 1
				action.command = actionLine
				table.insert(actions, action)
				if localLine == "" then
					localLine = action.id
				else
					localLine = localLine .. "," .. action.id
				end

			end
		end
		thisActions = thisActions .. localLine .. "|"
	end
	return string.sub(thisActions, 1, -2)
	
end


function addAction(action)
	table.insert(actions, action)
	--logFile:write("action " .. table.getn(actions) .." " .. action.command .. "\n")
	
end	
	
function doAction(strActions, barSplit, dt)

	actionList = strActions:split("then")
	for i, action in ipairs(actionList) do
		queueActions = {}
		if action:includes("/") then
			splitActions = action:split("/")
			tempActions = ""
			for i, sA in ipairs(splitActions) do
				if i ~= 1 then	
					tempActions = tempActions .. sA .. "/"
				end
			end
			
			action = trim(splitActions[1])

			queueActions.actions = tempActions
			
		end
		action = trim(action)
		if action ~= nil then
			local actionWords = action:split(" ") 
			verb = trim(actionWords[1])
			varName =  UserValues2(trim(actionWords[2]))
			value = trim(actionWords[3])
			if queueActions.actions ~= nil then 
				addActionToQueue(string.sub(queueActions.actions, 1, -2), actionWords)
			end
			
			if verb == "start" and varName == "chat" then
				if (currChatNode == nil ) then
					initChat(value)
					setupChat()
				end
			end
			if string.match(value, "pointingAt") == "pointingAt" then
				value = split(value, '|')
				value = getPointingAt(value[2])
			else
				value = SystemValues(value)
				value = UserValues2	(value)
			end
			if verb == "append" or verb == "set" or verb == "delete" then
				doCommand(verb, varName, value, actionWords)
			end
			if (verb == "move" or verb == "moveTo") and (varName ~= "" and varName ~= nil) then
				entityCommand(verb, varName, value, actionWords, dt)
			end
			if (verb == "create") then
				eventCreate(varName, value, actionWords)
			end	
			if (verb:includes("Inv")) then
				inventoryCommand(verb,varName,value, actionWords)
			end			
			
		end
		
	end
end


function doCommand(verb, varName, value, actionWords)

	for i, variable in ipairs(variables) do
		if variable.name == varName then
			if verb == "set" then variable.value = ""  end
			variable.value = variable.value .. value
			break
		end
	end	
	if verb == "delete" then

		if varName == "event" then
			for i, event in ipairs(events) do
				if event.name == value then
					table.remove(events, i)
					break
				end
			end
		end
	end	
	
	
end

function entityCommand(verb, varName, value, actionWords, dt)

	if  verb == "moveTo" then
		moveEntityTo(varName, value, actionWords)
	else if  verb == "move" then
		--local xy = split(entity.boxes[1].xy, ",")
		moveEntity(varName, value, actionWords, dt)
		end
	end

end


function inventoryCommand(verb,itemID,entity, actionWords)

	if verb == "addInv" then
		addInventory(itemID, entity)
	end
	if verb == "removeInv" then
		removeInventory(itemID, entity)
	end
	
end


function eventCreate(varName, value, actionWords)

	-- [1] time on the timer.
	-- [2] logic
	-- [3] true actions
	-- [4] false actions
	-- [5] delete/reset

	if varName == "timer" then
	
		local event = {}
			
		values = split(value, "|")
		event.id = 1
		event.onClick = false
		event.onKeyPress = false
		event.always = false
		event.time = values[1]
		event.timeStart = timer.getTime()
		if values[5] == "D" then event.delete = "true" end
		if values[5] == "R" then event.reset = "true" end
		event.logic = values[2]
		event.inventoryClick = false
		event.trueactions = values[3]
		event.falseactions = values[4]
		event.name = "testTimer"
		addEvent(event)
	end

end
