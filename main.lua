-- Copyright (c) 2017 Corona Labs Inc.
-- Code is MIT licensed and can be re-used; see https://www.coronalabs.com/links/code/license
-- Other assets are licensed by their creators:
--    Art assets by Kenney: http://kenney.nl/assets
--    Music and sound effect assets by Eric Matyas: http://www.soundimage.org

local composer = require( "composer" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=1 } )

-- Reserve channel 1 for background music
audio.reserveChannels( 2 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=2 } )

-- Reserve channel 1 for background music
audio.reserveChannels( 3 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=3 } )

-- this will eventually go to the menu scene.
composer.gotoScene( "splash" )
