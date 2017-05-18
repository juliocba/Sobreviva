
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Initialize variables
local soundHighscore

local finalScore

local function gotoGame()
    fireSound = audio.loadSound( "audio/pistol-shot.wav" )
    audio.play(fireSound)
    composer.removeScene("game")
    composer.gotoScene( "game", { time=500, effect="crossFade" } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Insert the saved score from the last game into the variable, then reset it
    finalScore =  composer.getVariable( "finalScore" )
    --composer.setVariable( "finalScore", 0 )
 
    local background = display.newImageRect( sceneGroup, "img/telaCompleta.png", 1359, 824 )    
    background.x = display.contentCenterX
    background.y = display.contentCenterY-30
    background.fill.effect = "filter.grayscale"
    
    local lapide = display.newImageRect( sceneGroup, "img/lapide.png", 130, 150 )
    lapide.x = display.contentCenterX
    lapide.y = display.contentCenterY+250
    lapide.fill.effect = "filter.grayscale"

    local gradient = {
        type="gradient",
        color1={ 1, 0, 0 }, color2={ 0.8, 0.8, 0.8 }, direction="up"
    }

    local highScoresHeader = display.newText( sceneGroup, "MORREU!", display.contentCenterX, 200, "SomethingStrange.ttf", 72 )
    highScoresHeader:setFillColor(gradient)

    local pontuacao = display.newText( sceneGroup, "Pontuação: "..finalScore, display.contentCenterX, 350, native.systemFontBold, 44 )
    pontuacao:setFillColor(gradient)
 
    local menuButton = display.newText( sceneGroup, "Jogar novamente", display.contentCenterX, 500, native.systemFontBold, 50 )
    menuButton:setFillColor(gradient)
    menuButton:addEventListener( "tap", gotoGame )

    soundHighscore = audio.loadStream( "audio/slow-atmosphere.wav")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( soundHighscore, { channel=3, loops=-1 } )
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
		audio.stop( 3 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( soundHighscore )
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
