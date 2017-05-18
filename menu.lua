
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local menuSound

local fireSound = audio.loadSound( "audio/pistol-shot.wav" )

local function gotoGame()
	audio.play(fireSound)
    composer.removeScene("game")
    composer.gotoScene("game", {time=500, effect="crossFade"})
end
 
local function gotoHighScores()
	audio.play(fireSound)
    composer.removeScene("highscores")
    composer.gotoScene("highscores", {time=500, effect="crossFade"})
end

local function gotoInstrucoes()
	audio.play(fireSound)
	composer.removeScene("instrucoes")
	composer.gotoScene("instrucoes", {time=500, effect="crossFade"})
end

local function gotoSobre()
	audio.play(fireSound)
	composer.removeScene("sobre")
	composer.gotoScene("sobre", {time=500, effect="crossFade"})
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
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

    local title = display.newText(sceneGroup, "SOBREVIVA", display.contentCenterX, 200, "SomethingStrange.ttf", 100)
    title:setFillColor(gradient)
	

	local playButton = display.newText( sceneGroup, "Jogar", display.contentCenterX, 400, native.systemFontBold, 44 )
	playButton:setFillColor( gradient )
 
	local highScoresButton = display.newText( sceneGroup, "Pontuações", display.contentCenterX, 500, native.systemFontBold, 44 )
	highScoresButton:setFillColor( gradient )

	local instrucoesButton = display.newText( sceneGroup, "Instruções", display.contentCenterX, 600, native.systemFontBold, 44 )
	instrucoesButton:setFillColor( gradient )

	local sobreButton = display.newText( sceneGroup, "Sobre", display.contentCenterX, 700, native.systemFontBold, 44 )
	sobreButton:setFillColor( gradient )

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )
	instrucoesButton:addEventListener("tap", gotoInstrucoes)
	sobreButton:addEventListener( "tap", gotoSobre)

	menuSound = audio.loadStream("audio/horror-theme.wav")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( menuSound, { channel=2, loops=-1 } )
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

		-- Stop the music!
        --audio.stop( 2 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( menuSound )
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
