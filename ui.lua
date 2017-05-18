local showTestWindow = false
local showAnotherWindow = false
local floatValue = 0;
local sliderFloat = { 0.1, 0.5 }
local clearColor = { 0.2, 0.2, 0.2 }
--local comboSelection = 1
local textValue = "text"

local combo = {value = 2, items = {'A', 'B', 'C'}}
function drawUI ()
	open = nk.windowBegin("test", 100,100, 100,100)
	--open = nk.treePush('tab', "test")
	--nk.treePop()
	nk.windowEnd()
end
