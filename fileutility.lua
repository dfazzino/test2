function OpenLogFile()    
	
	mydir = love.filesystem.getAppdataDirectory( )
	print(mydir .. "/adventureplusplus/logfile.txt")
    logFile = io.open("logfile.txt", "w")
    logFile:write("Opening LogFile\n")

end

function OpenScriptFile()    
	
    scriptFile = io.open("c:/users/dave/dropbox/scriptfile.txt", "r")
    logFile:write("Opening LogFile\n")	

	
end