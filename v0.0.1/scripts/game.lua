
require("config")
require("framework.init")
require("framework.client.init")

require("battle.BattlePosition")
require("battle.BattleAction")
require("battle.Action")
require("battle.QueueUtil")
require("battle.BattleLogic")
require("battle.BattleUnit")

-- define global module
game = {}

function game.startup()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")

	--display.addSpriteFramesWithFile(GAME_TEXTURE_GODPET_DATA_FILENAME, GAME_TEXTURE_GODPET_IMAGE_FILENAME)
	display.addSpriteFramesWithFile(GAME_TEXTURE_EFFECT_55_DATA_FILENAME, GAME_TEXTURE_EFFECT_55_IMAGE_FILENAME)
	
    game.enterMainScene()
end

function game.exit()
    CCDirector:sharedDirector():endToLua()
end

function game.enterMainScene()
    display.replaceScene(require("scenes.MainScene").new(), "fade", 0.6, display.COLOR_WHITE)
end
