currChatNode = nil
count = 	0
lines = {}

local theselines = {}

function initChat(id)
	chatBubble = 0

	chatTimer = timer.getTime()
	currChatNode = id
end

function countUnderscores(text)

local currcount = 0

for i in string.gfind(text, "_") do
	currcount = currcount + 1
end
return currcount

end

function initChats()

theselines.items = {}


chatnodes = {}

chatnode = {}
chatnode.id = "noItem"
chatnode.text = "guy:"
chatnode.response = "guy2: You don't have the item!!!"
chatnode.count = countUnderscores(chatnode.id)
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hasItem"
chatnode.text = "guy:"
chatnode.response = "guy2: You do have the item!!!"
chatnode.count = countUnderscores(chatnode.id)
table.insert(chatnodes, chatnode)


chatnode = {}
chatnode.id = "hi"
chatnode.text = "guy2: hi how are you"
chatnode.response = "guy: what do you want?|guy:do you want a punch in the nose?|guy2: um, no, no thanks."
chatnode.count = countUnderscores(chatnode.id)
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly"
chatnode.text = "guy2: ugly day isn't it?"
chatnode.response = "guy: i mean yeah i guess"
chatnode.count = countUnderscores(chatnode.id)
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy"
chatnode.text = "guy2: i mean i could punch a guy"
chatnode.response = "guy: yeah we should punch a guy"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy_doyouknow"
chatnode.text = "guy2: do you know a guy we can punch?"
chatnode.response = "guy: how about that guy over there?|guy: I bet we could punch him.|guy: does that sound good?"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy_dictator"
chatnode.text = "guy2: do you know a dictator we can punch?"
chatnode.response = "guy: heil hitler!"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy_cat"
chatnode.text = "guy2: do you know a cat we can punch?"
chatnode.response = "guy: um, mo!!!"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)


chatnode = {}
chatnode.id = "hi_ugly_punchguy_cat_mo"
chatnode.text = "guy2: dude that's my cat.."
chatnode.response = "guy: oh.  we shouldn't hit him!!!"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)


chatnode = {}
chatnode.id = "hi_ugly_punchguy_cat_mo_deserves"
chatnode.text = "guy2: he totally deserves it.."
chatnode.response = "guy: oh.  that's great!"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy_dictator_hitler"
chatnode.text = "guy2: i kinda think we should punch hitler."
chatnode.response = "guy: heil hitler!?"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy_dictator_hitler_heart"
chatnode.text = "guy2: do you <3 <3 <3 hitler?"
chatnode.response = "guy: you might be confused"
chatnode.count = countUnderscores(chatnode.id)

table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchguy_doyouknow_greatidea"
chatnode.text = "guy2: that's a great idea, you first?"
chatnode.response = "guy: ok sure why not?"

chatnode.count = countUnderscores(chatnode.id)
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_ugly_punchgirl"
chatnode.text = "guy2: i mean i could punch a girl"
chatnode.response = "guy: I don't think I'm that mad.  wow, relax."
chatnode.count = countUnderscores(chatnode.id)
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_nice"
chatnode.text = "guy2: nice day isn't it?"
chatnode.response = "guy: never!!! never a nice day!!!"
chatnode.count = countUnderscores(chatnode.id)
chatnode.events = 3
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_nice_sunny"
chatnode.text = "guy2: what do you mean?  it's so sunny!"
chatnode.response = "guy: wtf man wtf i hate the sun so burny"
chatnode.count = countUnderscores(chatnode.id)
chatnode.events = 3
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_nice_shining"
chatnode.text = "guy2: what do you mean the sun is so shiny?"
chatnode.response = "guy: it isn't the sun, that's actually hell moon"
chatnode.count = countUnderscores(chatnode.id)
chatnode.events = 3
table.insert(chatnodes, chatnode)

chatnode = {}
chatnode.id = "hi_nice_shining_hellmoon"
chatnode.text = "guy2: hell moon?  you're making stuff up now."
chatnode.response = "guy: no seriously, I read it  in american scientist.  hell mean is totes real."
chatnode.count = countUnderscores(chatnode.id)
chatnode.events = 3
table.insert(chatnodes, chatnode)

end

function testChatNodes()
	
	--startChatNode("hi", 0)
end


function setupChat()

	if currChatNode ~= nil then
		lines = {}
		thisChatIDs = {}
		optionsCount =  0
		theselines.value = 1
		for i, cn in ipairs(chatnodes) do
			if (cn.id:startsWith(currChatNode) and cn.count <= count + 1) then
				if cn.id == currChatNode then
					line = {}
					line.text = cn.text
					line.response = cn.response
					if cn.events ~= nil then
						checkChatEvent(cn.events)
					end 
					table.insert(lines, line)
				else
					segs = cn.id:split("_")
					line = {}
					line.text = cn.text
					line.id = segs[cn.count + 1]
					optionsCount = optionsCount + 1
					line.optionNum = optionsCount
					table.insert(lines, line) 
				end
			end
		end
			chatBubble = 1
			if lines[1].response ~= nil then
				if lines[1].response:includes("|", true) then
					chatResponses = lines[1].response:split("|")
				else
					chatResponses = {}
					table.insert(chatResponses, lines[1].response)
				end
			end
			chatTimer = timer.getTime()
		 if #lines <= 1 then
		 currChatNode = nil
		 end
	end
	
end

function drawChat ()
	if currChatNode ~= nil then
		theselines.items = {}
		theselines.text = {}
		theselines.value = 1

		local labelWords = ""
		table.insert(theselines.items, "Select One")
		for i, line in ipairs(lines) do
			if i > 1 then
				table.insert(theselines.items, line.id)
				labelWords = labelWords .. line.text .. "\n"
			end
		end
		if nk.windowBegin('Chat window', 300, 100, 300, 200,
				'border', 'title', 'movable') then
			nk.layoutRow('dynamic', 100, 1)
			nk.label(labelWords, "top left")
			nk.layoutRow('dynamic', 30, 2)
			if nk.combobox(theselines, theselines.items,40,200) then
				currChatNode = currChatNode .. "_" .. theselines.items[theselines.value]
				count = count + 1
				setupChat()
			end

		end
		nk.windowEnd()
	end
	bubbleTimer()
end


function drawBubbles()

	-- chatBubble 1 = the line the player picked (line.text)
	-- 2 - x = split line.response on ".", each sentence is a bubble,
	-- on each sentence, split on ":" and the entity will be index 1 and
	-- the sentence will be index 2.
	
	if lines[1] ~= nil then
		if chatBubble == 1 then
			local line = lines[1]
			local words = line.text:split(":")
			entity = getEntity(words[1])
			local thisXY = entity.xy:split(",")
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle("fill", thisXY[1],thisXY[2], 200, 30,10,10,20)
			love.graphics.setColor(0,0,0,255)
			love.graphics.printf(line.text, thisXY[1], thisXY[2],200, "center")
			love.graphics.setColor(255,255,255,255)
		end 
		if chatBubble >= 2 and chatResponses [chatBubble - 1] ~= nil then 
			local line = chatResponses[chatBubble - 1]
			if line ~= nil then
				local words = line:split(":")
				entity = getEntity(words[1])
				local thisXY = entity.xy:split(",")
				love.graphics.setColor(255,0,0,255)
				love.graphics.rectangle("fill", thisXY[1],thisXY[2], 200, 30,10,10,20)
				love.graphics.setColor(0,0,0,255)
				love.graphics.printf(line, thisXY[1], thisXY[2],200, "center")
				love.graphics.setColor(255,255,255,255)
				end		
		end
	end
end

function bubbleTimer()
	if chatTimer < timer.getTime() - 2 then
		chatBubble = chatBubble + 1
		chatTimer = timer.getTime()
	end
end