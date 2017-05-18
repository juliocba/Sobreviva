-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Esconder o status bar
display.setStatusBar( display.HiddenStatusBar )

-- Iniciar e ligar física
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

-- Gera números random
math.randomseed(os.time())

-- Display groups
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score

-- Inicialização das variáveis
local lado = "esquerdo" 
local contadorPontos = 0
local morreu = false
local velocidade = 80

local tabelaZumbis = {}
local tabelaZumbisDireita = {}
local tabelaZumbisFortes = {}

-- Display backGroup
local background = display.newImageRect(backGroup, "img/telaCompleta.png", 1359, 824)
background.x = display.contentCenterX
background.y = display.contentCenterY-30

-- Display uiGroup
local gradient = {
    type="gradient",
    color1={ 1, 0.4, 0.1 }, color2={ 0.8, 0.8, 0.8 }, direction="up"
}

local textoContador = display.newText(uiGroup, contadorPontos, display.contentCenterX, 80, native.systemFontBold, 50)
textoContador:setFillColor(gradient)


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
local zes = display.newSprite( mainGroup, sheet_zes, sequences_zes )
zes.x = display.contentCenterX
zes.y = display.contentHeight-130
physics.addBody(zes,{radius=20, isSensor=true})
zes.myName = "ze"
zes:play()

local mask = graphics.newMask( "img/luz.png" )
backGroup:setMask( mask )
backGroup.maskX = background.x
backGroup.maskY = background.y

local function criarZumbis()
    local origem = math.random(2)
    
    local zumbi = display.newImageRect(backGroup, "img/zumbi.png", 200, 200 )
    table.insert(tabelaZumbis, zumbi)
	physics.addBody(zumbi, "dynamic", {radius=17, isSensor=true})
	zumbi.myName = "zumbi"
    
    if(origem == 1) then
		-- From the left
		zumbi.x = - 150
		zumbi.y = display.contentHeight-130	
		zumbi:setLinearVelocity(velocidade)
	elseif (origem == 2) then
	    -- From the right
	    zumbi:scale(-1, 1)
        zumbi.x = display.contentWidth + 150
	    zumbi.y = display.contentHeight-130
	    zumbi:setLinearVelocity(-velocidade)
        
	end
	print("VELOCIDADE: "..velocidade)
end 

local function fireLaserDireita()
	local newLaser = display.newImageRect(mainGroup, "img/laser.png", 13, 40)
	newLaser.rotation=newLaser.rotation-270
	physics.addBody(newLaser, "dynamic", {isSensor = true})
	newLaser.isBullet = true
	newLaser.myName = "laser"
	newLaser.x = zes.x+70
	newLaser.y = zes.y-23
	newLaser:toBack()
	transition.to(newLaser, {x=1300, time=600, 
		onComplete = function() display.remove(newLaser) end})
end
--zes:addEventListener("tap", fireLaser)   

local function fireLaserEsquerda()
	local newLaser = display.newImageRect(mainGroup, "img/laser.png", 14, 40)
	newLaser.rotation=newLaser.rotation-90
	physics.addBody(newLaser, "dynamic", {isSensor = true})
	newLaser.isBullet = true
	newLaser.myName = "laser"
	newLaser.x = zes.x-70
	newLaser.y = zes.y-23
	newLaser:toBack()
	transition.to(newLaser, {x=-200, time=600, 
		onComplete = function() display.remove(newLaser) end})
end

local function virarDireita()
	if(lado == "esquerdo") then
		zes:scale(-1, 1)
		backGroup.maskScaleX = -1
		lado = "direito"
    elseif (lado == "direito") then
	   fireLaserDireita()
    end
end

local function virarEsquerda()
	if(lado == "direito") then
		zes:scale(-1, 1)
		backGroup.maskScaleX = 1
		lado = "esquerdo"
    elseif (lado == "esquerdo") then
	   fireLaserEsquerda()
    end
end

local function gameLoop()
    -- Cria novo zumbi
    criarZumbis()
    -- Remove asteroids which have drifted off screen
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
gameLoopTimer = timer.performWithDelay(1000, gameLoop, 0)

local function onCollision(event)
	if (event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2
		if ((obj1.myName == "laser" and obj2.myName == "zumbi") or
			 (obj1.myName == "zumbi" and obj2.myName == "laser"))
		then
			-- Remove both the laser and asteroid
			display.remove(obj1)
			display.remove(obj2)
			for i = #tabelaZumbis, 1, -1 do
				if (tabelaZumbis[i] == obj1 or tabelaZumbis[i] == obj2) then
					table.remove(tabelaZumbis, i)
					velocidade = velocidade + 1
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
				display.remove(zes)
			end
		end
	end
end
Runtime:addEventListener("collision", onCollision)

-- invsible button Esquerda
local invisiblebuttonDireita = display.newRect( 0, 0, 250, 650 )
invisiblebuttonDireita:setFillColor( 255, 0, 0 )
invisiblebuttonDireita.x = -45
invisiblebuttonDireita.y = 425
--invsiblebuttonDireita.alpha = 0
invisiblebuttonDireita.isVisible = false
invisiblebuttonDireita.isHitTestable = true
invisiblebuttonDireita:addEventListener("tap", virarEsquerda)

-- invsible button Direita
local invisiblebuttonDireita = display.newRect( 0, 0, 250, 650 )
invisiblebuttonDireita:setFillColor( 255, 0, 0 )
invisiblebuttonDireita.x = 1069
invisiblebuttonDireita.y = 425
--invsiblebuttonDireita.alpha = 0
invisiblebuttonDireita.isVisible = false
invisiblebuttonDireita.isHitTestable = true
invisiblebuttonDireita:addEventListener("tap", virarDireita)



local botaoDireta = display.newText( "==>", 1000, 730, native.systemFont, 44 )
botaoDireta:setFillColor( 1, 0.4, 0.1 )
 
local botaoEsquerda = display.newText( "<==", 0, 730, native.systemFont, 44 )
botaoEsquerda:setFillColor( 1, 0.4, 0.1 )
