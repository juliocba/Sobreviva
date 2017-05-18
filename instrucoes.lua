
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Initialize variables

local function gotoMenu()
	fireSound = audio.loadSound( "audio/pistol-shot.wav" )
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

    local criado = display.newText( sceneGroup, "Instruções", display.contentCenterX, 100, native.systemFontBold, 44 )
    criado:setFillColor(gradient)

    local nome = display.newText( sceneGroup, "Clique uma vez nos cantos da tela para mover Zé!", display.contentCenterX, 250, native.systemFontBold, 35 )
    --nome:setFillColor(gradient)

    local github = display.newText( sceneGroup, "Clicando mais de uma vez para o lado Zé atira!", display.contentCenterX, 300, native.systemFontBold, 35 )
   -- github:setFillColor(gradient)

    local email = display.newText( sceneGroup, "Acabou a munição?", display.contentCenterX, 350, native.systemFontBold, 35 )
    --email:setFillColor(gradient)

    local email = display.newText( sceneGroup, "Balance o celular para recarregar!", display.contentCenterX, 400, native.systemFontBold, 35 )

 
    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 725, native.systemFontBold, 44 )
    menuButton:setFillColor(gradient)
    menuButton:addEventListener( "tap", gotoMenu )

    --soundHighscore = audio.loadStream( "audio/slow-atmosphere.wav")
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
