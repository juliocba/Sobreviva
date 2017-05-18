local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Iniciar e ligar física
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

-- Inicialização das variáveis
local lado = "esquerdo" 
local contadorPontos = 0
local textoContador
local morreu = false
local velocidade = 100
local gameLoopTimer
local municao = 16
local textoMunicao
local pauseButtonImage
local municaoImage
local tempoLoop = 1000

local retomarButton
local myRoundedRect
local menuButton
local pauseClicado = 0

local somZumbi1
local somZumbi2
local somMorte2
local fireSound
local musicTrack
local fireSoundEmpty
local reload

-- Set up display groups
local backGroup
local mainGroup
local uiGroup
local uiModal

local zes
local mask

local zumbi

local tabelaZumbis = {}
local tabelaZumbisFortes = {}

local invisiblebuttonDireita
local invisiblebuttonDireita

local function gotoMenu()
	composer.removeScene("menu")
    composer.gotoScene( "menu", { time=500, effect="crossFade" } )
end

local function criarZumbis()
    local origem = math.random(2)
    
    zumbi = display.newImageRect(backGroup, "img/zumbi.png", 200, 200 )
    table.insert(tabelaZumbis, zumbi)
	physics.addBody(zumbi, "dynamic", {radius=17, isSensor=true})
	zumbi.myName = "zumbi"
    
    if(origem == 1) then
		zumbi:scale(-1, 1)
        zumbi.x = display.contentWidth + 150
	    zumbi.y = display.contentHeight-180
	    zumbi:setLinearVelocity(-velocidade)
	elseif (origem == 2) then
	  	zumbi.x = -200
	    zumbi.y = -200
	end
	print("VELOCIDADE: "..velocidade)
end

local function criarZumbisD()
    local origem = math.random(2)
    
    zumbi = display.newImageRect(backGroup, "img/zumbi.png", 200, 200 )
    table.insert(tabelaZumbis, zumbi)
	physics.addBody(zumbi, "dynamic", {radius=17, isSensor=true})
	zumbi.myName = "zumbi"
    
    if(origem == 1) then
		zumbi.x = - 150
		zumbi.y = display.contentHeight-180	
		zumbi:setLinearVelocity(velocidade)
	elseif (origem == 2) then
	    zumbi.x = -200
	    zumbi.y = -200
	end
	print("VELOCIDADED: "..velocidade)
end 

local function tiroDireita()
    if( municao > 0 and municao <= 16) then
        audio.play( fireSound )
        local newLaser = display.newImageRect(mainGroup, "img/laser.png", 14, 40)
        newLaser.rotation=newLaser.rotation-270
        physics.addBody(newLaser, "dynamic", {isSensor = true})
        newLaser.isBullet = true
        newLaser.myName = "laser"
        newLaser.x = zes.x+70
        newLaser.y = zes.y-23
        newLaser:toBack()
        transition.to(newLaser, {x=1300, time=400, 
            onComplete = function() display.remove(newLaser) end})
        municao = municao - 1
        textoMunicao.text = "X"..municao
    end
    if( municao == 0) then
    	audio.play(fireSoundEmpty)
    end
end

local function tiroEsquerda()
    if( municao > 0 and municao <= 16) then
        audio.play( fireSound )
        local newLaser = display.newImageRect(mainGroup, "img/laser.png", 14, 40)
        newLaser.rotation=newLaser.rotation-90
        physics.addBody(newLaser, "dynamic", {isSensor = true})
        newLaser.isBullet = true
        newLaser.myName = "laser"
        newLaser.x = zes.x-70
        newLaser.y = zes.y-23
        newLaser:toBack()
        transition.to(newLaser, {x=-200, time=400, 
            onComplete = function() display.remove(newLaser) end})
        municao = municao - 1
        textoMunicao.text = "X"..municao
    end
    if( municao == 0) then
    	audio.play(fireSoundEmpty)
    end
end

local function virarDireita()
	if(lado == "esquerdo") then
		zes:scale(-1, 1)
		backGroup.maskScaleX = -1
		lado = "direito"
    elseif (lado == "direito") then
	   tiroDireita()
    end
end

local function virarEsquerda()
	if(lado == "direito") then
		zes:scale(-1, 1)
		backGroup.maskScaleX = 1
		lado = "esquerdo"
    elseif (lado == "esquerdo") then
	   tiroEsquerda()
    end
end

local function recarregar(event)
    if event.isShake then
        if( municao == 0) then
	    	audio.play(reload)
	    	municao = municao + 16
        	textoMunicao.text = "X"..municao
   		 end
    end
     
    --return true
end

local function retomar()
	physics.start()
	display.remove(myRoundedRect)
	display.remove(retomarButton)
	display.remove(menuButton)
	zes:play()
	invisiblebuttonEsquerda:addEventListener("tap", virarEsquerda)
	invisiblebuttonDireita:addEventListener("tap", virarDireita)
	timer.resume(gameLoopTimer)
	pauseClicado = 0

end

local function pauseButton()
	if(pauseClicado == 0) then
		local gradient = {
	        type="gradient",
	        color1={ 1, 0, 0 }, color2={ 0.8, 0.8, 0.8 }, direction="up"
    	}
		audio.play( fireSound )
		physics.pause()
		zes:pause()
		invisiblebuttonEsquerda:removeEventListener("tap", virarEsquerda)
		invisiblebuttonDireita:removeEventListener("tap", virarDireita)
		--pauseButtonImage:removeEventListener("tap", pauseButton)
		timer.pause(gameLoopTimer)
		myRoundedRect = display.newRoundedRect( uiModal, display.contentCenterX, display.contentCenterY, 500, 500, 12 )
		myRoundedRect.strokeWidth = 3
		myRoundedRect:setFillColor( 0.2 )
		myRoundedRect:setStrokeColor( 1, 0, 0 )
		retomarButton = display.newText(uiModal, "Retomar", display.contentCenterX , display.contentCenterY - 20, native.systemFontBold, 50 )
		retomarButton:setFillColor( gradient )
		retomarButton:addEventListener( "tap", retomar )
		menuButton = display.newText(uiModal, "Menu", display.contentCenterX , display.contentCenterY+80, native.systemFontBold, 50 )
		menuButton:setFillColor( gradient )
		menuButton:addEventListener( "tap", gotoMenu )
		pauseClicado = 1
	elseif(pauseClicado == 1) then
	end
end

local function gameLoop()
    -- Cria novo zumbi
    criarZumbis()
    criarZumbisD()
    -- Remove zumbis which have drifted off screen
    for i = #tabelaZumbis, 1, -1 do
        local thisZumbi = tabelaZumbis[i]
        if (thisZumbi.x < -200 or
             thisZumbi.x > display.contentWidth + 200 or
             thisZumbi.y < -200 or
             thisZumbi.y > display.contentHeight + 200)
        then
            display.remove(thisZumbi)
            table.remove(tabelaZumbis, i)
        end
    end
end

local function endGame()
	composer.setVariable("finalScore", contadorPontos)
	composer.removeScene("highscores")
	composer.removeScene("menu")
	composer.removeScene("morreu")
	composer.gotoScene("morreu", {time=500, effect="crossFade"})
end

local function onCollision(event)
	local som1 = math.random(2)
	local som2 = math.random(2)
	if (event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2
		if ((obj1.myName == "laser" and obj2.myName == "zumbi") or
			 (obj1.myName == "zumbi" and obj2.myName == "laser"))
		then
			-- Remove both the laser and asteroid
			display.remove(obj1)
			display.remove(obj2)
            --Play explosion sound!
            if (som1 == 1) then
            	audio.play(somZumbi1)
            elseif (som1 == 2) then
            	audio.play(somZumbi2)
            end

			for i = #tabelaZumbis, 1, -1 do
				if (tabelaZumbis[i] == obj1 or tabelaZumbis[i] == obj2) then
					table.remove(tabelaZumbis, i)
					velocidade = velocidade + 2
					break
				end
			end
			-- Increase score
			contadorPontos = contadorPontos + 1
			textoContador.text = contadorPontos
		elseif ((obj1.myName == "ze" and obj2.myName == "zumbi") or
				 (obj1.myName == "zumbi" and obj2.myName == "ze"))
		then
			if (morreu == false) then
				morreu = true
                -- Play explosion sound!
				audio.play(somZumbi2)
				audio.play(somMorte2)
                display.remove(invisiblebuttonEsquerda)
                display.remove(invisiblebuttonDireita)
				display.remove(zes)
                timer.performWithDelay(1000, endGame)
			end
		end
	end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert(backGroup)  -- Insert into the scene's view group
	 
	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert(mainGroup)  -- Insert into the scene's view group
	 
	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert(uiGroup)    -- Insert into the scene's view group

	uiModal = display.newGroup()
	sceneGroup:insert(uiModal)

	-- Display backGroup
	local background = display.newImageRect(backGroup, "img/telaCompletaTeste2.png", 1360, 825)
	background.x = display.contentCenterX
	background.y = display.contentCenterY-30

	-- Display mainGroup
	local sheetData = {
	    width = 192,
	    height = 192,
	    numFrames = 6
	}

	local sheet_zes = graphics.newImageSheet("img/zes.png", sheetData)

	-- sequences table
	local sequences_zes = {
	    -- consecutive frames sequence
	    {
	        name = "normalRun",
	        start = 1,
	        count = 6,
	        time = 1000,
	        loopCount = 0,
	        loopDirection = "forward"
	    }
	}

	--Sprite do Ze
	zes = display.newSprite( mainGroup, sheet_zes, sequences_zes )
	zes.x = display.contentCenterX
	zes.y = display.contentHeight-155
	physics.addBody(zes,{radius=20, isSensor=true})
	zes.myName = "ze"
	zes:play()

	mask = graphics.newMask( "img/luz-teste.png" )
	backGroup:setMask( mask )
	backGroup.maskX = background.x
	backGroup.maskY = background.y

	-- Display uiGroup
	local gradient = {
	    type="gradient",
	    color1={ 1, 0, 0 }, color2={ 0.8, 0.8, 0.8 }, direction="up"
	}

	textoContador = display.newText(uiGroup, contadorPontos, display.contentCenterX, 200, native.systemFontBold, 100)
	textoContador:setFillColor(gradient)

	municaoImage = display.newImageRect(uiGroup, "img/municao.png", 160, 160)
	municaoImage.x = display.contentCenterX -560
	municaoImage.y = 200
    
    textoMunicao = display.newText(uiGroup, "X"..municao, display.contentCenterX - 500, 200, native.systemFontBold, 50 )
	 
	-- invsible button Esquerda
    invisiblebuttonEsquerda = display.newRect( 0, 0, 380, 650 )
	invisiblebuttonEsquerda:setFillColor( 255, 0, 0 )
	invisiblebuttonEsquerda.x = 20
	invisiblebuttonEsquerda.y = 444
	invisiblebuttonEsquerda.isVisible = false
	invisiblebuttonEsquerda.isHitTestable = true
	invisiblebuttonEsquerda:addEventListener("tap", virarEsquerda)

	-- invsible button Direita
	invisiblebuttonDireita = display.newRect( 0, 0, 380, 650 )
	invisiblebuttonDireita:setFillColor( 255, 0, 0 )
	invisiblebuttonDireita.x = 1004
	invisiblebuttonDireita.y = 444
	invisiblebuttonDireita.isVisible = false
	invisiblebuttonDireita.isHitTestable = true
	invisiblebuttonDireita:addEventListener("tap", virarDireita)

	pauseButtonImage = display.newImageRect(uiGroup, "img/pause-button.png", 160, 160)
	pauseButtonImage.x = display.contentCenterX + 600
	pauseButtonImage.y = display.contentCenterY-330
	pauseButtonImage:addEventListener("tap", pauseButton)

	somZumbi1 = audio.loadSound( "audio/zumbi1.wav" )
 	somZumbi2 = audio.loadSound( "audio/zumbi2.wav" )
 	somMorte2 = audio.loadSound( "audio/morte2.wav" )
	fireSound = audio.loadSound( "audio/pistol-shot.wav" )
	musicTrack = audio.loadStream( "audio/dark-ambient.wav" )
	fireSoundEmpty = audio.loadSound( "audio/empty-shot.wav" )
	reload = audio.loadSound( "audio/reload.wav" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		 -- Code here runs when the scene is entirely on screen
       	physics.start()
        Runtime:addEventListener("collision", onCollision)
        Runtime:addEventListener( "accelerometer", recarregar )
        gameLoopTimer = timer.performWithDelay(1000-(2*velocidade), gameLoop, 0)
         -- Start the music!
        audio.stop( 2 )
        audio.play( musicTrack, { channel=1, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(gameLoopTimer)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("collision", onCollision)
		Runtime:removeEventListener("accelerometer", recarregar)
        physics.pause()
        -- Stop the music!
        audio.stop( 1 )
       -- composer.removeScene("game")
        
	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	audio.dispose( somZumbi1 )
	audio.dispose( somZumbi2 )
	audio.dispose( somMorte2 )
    audio.dispose( fireSound )
    audio.dispose( musicTrack )

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