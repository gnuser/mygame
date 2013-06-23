
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	-- add bg
	self.bg = display.newBackgroundSprite("map/battle_bg_0.jpg")
    self:addChild(self.bg)
	
	-- init battle demo
	self:initBattle()
end

function MainScene:onEnter()
    if device.platform ~= "android" then return end

    -- avoid unmeant back
    self:performWithDelay(function()
        -- keypad layer, for android
        local layer = display.newLayer()
        layer:addKeypadEventListener(function(event)
            if event == "back" then game.exit() end
        end)
        self:addChild(layer)

        layer:setKeypadEnabled(true)
    end, 0.5)
end

-- 阵营双方站位坐标
local party_position = {
	{
		
	},
	{
	}
}

function MainScene:initBattle()
	self.battleUnits = { {}, {} } -- 两个阵营
	
	-- 获取战斗单元数据
	
	-- 创建战斗单元
	self:addBattleUnit(1, display.left+100, display.top - 90)
	self:addBattleUnit(0, display.right-100, display.bottom + 90)
end

-- index 造型索引
function MainScene:addBattleUnit(index, posx, posy, isPlayer)
	local resPath
	if isPlayer then
		resPath = "player/player_".. role .. ".png"
	else
		resPath = "weapon/weapon_".. role .. ".png"
	end
	
	local battleUnit = display.newBackgroundSprite(resPath)
	battleUnit:setPosition(posx, posy)
	self:addChild(battleUnit)
	return battleUnit
end

return MainScene
