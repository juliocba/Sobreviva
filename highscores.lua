
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Initialize variables
--local soundHighscore

local fireSound

local json = require("json")
 
local scoresTable = {}
 
local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores()
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
 
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 500, 250, 150, 100, 85, 70, 55, 40, 25, 10 }
    end
end

local function saveScores()
 
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end

local function gotoMenu()
	
	audio.play(fireSound)
    composer.gotoScene( "menu", { time=500, effect="crossFade" } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    -- Load the previous scores
    loadScores()
 
    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )
 
    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )
 
    -- Save the scores
    saveScores()
 
    local background = display.newImageRect( sceneGroup, "img/telaCompleta.png", 1359, 824 )    
    background.x = display.contentCenterX
    background.y = display.contentCenterY-30
    background.fill.effect = "filter.grayscale"
    --background.fill.effect = "filter.pixelate"
    --background.fill.effect.numPixels = 4
 
    local gradient = {
        type="gradient",
        color1={ 1, 0, 0 }, color2={ 0.8, 0.8, 0.8 }, direction="up"
    }

    local highScoresHeader = display.newText( sceneGroup, "Pontuação", display.contentCenterX, 50, native.systemFontBold, 44 )
    highScoresHeader:setFillColor(gradient)
 
    for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 90 + ( i * 56 )
 
            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 36 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1
  
            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 36 )
            thisScore.anchorX = 0
        end
    end
 
    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 725, native.systemFontBold, 44 )
    menuButton:setFillColor(gradient)
    menuButton:addEventListener( "tap", gotoMenu )

    --soundHighscore = audio.loadStream( "audio/slow-atmosphere.wav")
    fireSound = audio.loadSound( "audio/pistol-shot.wav" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--audio.play( soundHighscore, { channel=3, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		--audio.stop( 3 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	--audio.dispose( soundHighscore )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
