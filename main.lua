require 'actions'
require 'events'
require 'logic'
require 'variables'
require 'entities'
require 'art'
require 'utility'
require 'fileutility'
require 'strong'
anim8 = require 'anim8'
nk = require 'nuklear'
flux = require 'flux'
require 'ui'
require 'chats'
require 'buttons'

function love.load()
--  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end

	require("love.screen") -- load the love.module
	love.screen.init() -- Mandatory : it create the main screen.
    screen = love.screen.getScreen()
	OpenLogFile()    
	OpenScriptFile()   
	initLove2D()
	initDraw()
	initChat()
	initChats()
	testChatNodes()
	-- initLogic()
	--initEvents()
	initUIObject()	
	-- initVariables()
	initEntities()
	logFile:flush()	
	nk.init()
	loadScript()
	initActions()
	setupChat()
end


function loadScript ()

	repeat  
		line = scriptFile:read() 
		loadVariables() 
		loadEvents()
		loadEntities()
		loadButtons()
	until line == nil
end


function love.keypressed(key,scancode, isrepeat)
	nk.keypressed(key, scancode, isrepeat)
	UI.keypressed = key
        -- Pass event to the game
    
end


function love.keyreleased(key,scancode, isrepeat)
 nk.keyreleased(key, scancode)
    	UI.keyreleased = key
		checkEvents("keyreleased")
	if key == "f12" then love.system.openURL( "http://localhost:8000" ) end
    
end

function love.wheelmoved(x, y)
	nk.wheelmoved(x, y)
    end

function love.textinput(t)
nk.textinput(text)
end

function love.mousereleased(x, y, button, istouch)
nk.mousereleased(x, y, button, istouch)
	if button == 1 then
		absorbed = doButtonPress()
			if not absorbed then
				analyzemap()
				pathFinding(nil, "_" .. actorEntity.name .. "_", nil)	
			end
		showButtons(false)
	end
	if button == 2  then
	
		acteeName = getPointingAt("name")
		if acteeName ~= "" then
			showButtons(true)
		else
			showButtons(false)
		end
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
nk.mousemoved(x, y, dx, dy, istouch)
end
 
function love.mousepressed(x, y, button, istouch)
nk.mousepressed(x, y, button, istouch)

end

function love.update(dt)
	require("lovebird").update()
	nk.frameBegin()
	flux.update(dt)
	UI.mousex = love.mouse.getX()
	UI.mousey = love.mouse.getY()
	checkEvents("always")
	checkTimers()
	updateAnimate(dt)
	drawChat()
	updateXYtoFlux()
	nk.frameEnd()
end

function love.draw()
	nk.draw()
	drawUI()
	drawEntities()
	drawBubbles()
	drawInformation()
	
	
end