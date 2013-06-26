
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

-- 阵营双方站位坐标
local party_position = {
	{
		{100, 80}, -- 主角
		{40, 90},
		{60, 130},
		{100, 160},
		{150, 130},
		{160, 90},
		{150, 50},
		{100, 20},
		{60, 40}
	},
	{
		{95, 105}, -- 主角
		{40, 90},
		{60, 130},
		{100, 160},
		{150, 130},
		{160, 90},
		{150, 50},
		{100, 20},
		{60, 40}
	}
}

local random = math.random

function MainScene:ctor()
	-- add bg
	self.bg = display.newBackgroundSprite("map/battle_bg_0.jpg")
    self:addChild(self.bg)
	
	-- init battle demo
	self:initBattle()
	
	-- test particle
	local emitter = CCParticleSystemQuad:create("particle/fire.plist")
    --emitter:initWithFile("particle/mygame.plist"
	local posx, posy = self.battleUnits[1][2]:getPosition()
	--local size = self.battleUnits[1][2]:getContentSize()
	--print (size.width .. "," .. size.height)
	emitter:setPosition(posx, posy - 10)
	self:addChild(emitter);
	
	
	--emitter = CCParticleSystemQuad:create("particle/snow.plist")
	--emitter:setPosition(0, 480)
	--self:addChild(emitter)
	
	self.batch = display.newBatchNode(GAME_TEXTURE_EFFECT_55_IMAGE_FILENAME, 10)
    self:addChild(self.batch)
	
	-- add debug command text input
	local editBoxBg = CCScale9Sprite:create("ui/inputbox.png")
    local editBox = CCEditBox:create(CCSize(100, 20), editBoxBg)
    editBox:setPosition(CCPoint(display.cx/2, display.top - 300))
    self:addChild(editBox)
	self.commandEditBox = editBox
	
	-- add debug command button
	local commandButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 200,
        y = display.bottom + 20,
        listener = function()            
			self:executeCommand()
        end,
    })
	local menu = ui.newMenu({commandButton})
    self:addChild(menu)
	
end

function MainScene:onEdit(event)
	-- execute command
	print("execute command: " .. event.target:getText())
end

function MainScene:executeCommand()
	print("execute command: " .. self.commandEditBox:getText())
	local commandStr = string.split(self.commandEditBox:getText(), " ")
	--print(commandStr[1])
	local commandArgs = string.split(commandStr[2], ",")
	--print(commandArgs[1])
	if commandStr[1] == "a" then
		-- test action
		
		self:attackBattleUnit(tonumber(commandArgs[1]), tonumber(commandArgs[2]), 
								tonumber(commandArgs[3]), tonumber(commandArgs[4]))
	end
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



function MainScene:initBattle()
	self.battleUnits = { {}, {} } -- 两个阵营
	
	-- 获取战斗单元数据
	
	-- 创建战斗单元
	table.insert(self.battleUnits[1],  self:addBattleUnit(2, display.left+party_position[1][1][1], display.top - party_position[1][1][2], true))
	table.insert(self.battleUnits[2], self:addBattleUnit(1, display.right-party_position[2][1][1], display.bottom + party_position[2][1][2], true))

	for i=2, 9 do
		table.insert(self.battleUnits[1], self:addBattleUnit(i-1, 
					display.left + party_position[1][i][1], display.top - party_position[1][i][2]))
		--print(display.right-party_position[1][i][1] .. "," .. display.bottom + party_position[1][i][2])
		
		table.insert(self.battleUnits[2], self:addBattleUnit(i-1, 
					display.right-party_position[2][i][1], display.bottom + party_position[2][i][2]))
		--print(display.right-party_position[2][i][1] .. "," .. display.bottom + party_position[2][i][2])
	end
	--[[
	table.insert(self.battleUnits[2], self:addBattleUnit(1, display.right-40, display.bottom + 70))
	table.insert(self.battleUnits[2], self:addBattleUnit(2, display.right-60, display.bottom + 110))
	table.insert(self.battleUnits[2], self:addBattleUnit(3, display.right-100, display.bottom + 140))
	table.insert(self.battleUnits[2], self:addBattleUnit(4, display.right-150, display.bottom + 110))
	table.insert(self.battleUnits[2], self:addBattleUnit(5, display.right-160, display.bottom + 70))
	table.insert(self.battleUnits[2], self:addBattleUnit(6, display.right-150, display.bottom + 30))
	table.insert(self.battleUnits[2], self:addBattleUnit(7, display.right-100, display.bottom + 20))
	table.insert(self.battleUnits[2], self:addBattleUnit(8, display.right-60, display.bottom + 30))
	--]]
end

-- index 造型索引
function MainScene:addBattleUnit(index, posx, posy, isPlayer)
	local resPath
	if isPlayer then
		resPath = "player/player_".. index .. ".png"
	else
		resPath = "weapon/weapon_".. index .. ".png"
	end
	
	local battleUnit = display.newBackgroundSprite(resPath)
	battleUnit:setPosition(posx, posy)
	self:addChild(battleUnit)
	return battleUnit
end

function MainScene:attackBattleUnit(srcIndex, srcPart, targetIndex, targetPart)
	local unit = self.battleUnits[srcPart][srcIndex]
	local targetUnit = self.battleUnits[targetPart][targetIndex]
	
	local targetPosx, targetPosy = targetUnit:getPosition()
	local srcPosx, srcPosy = unit:getPosition()
	
	local function onComplete()

		BattleAction.attackShake(targetUnit)
		--self:playEffect(posx, posy)
		local effect = BattleAction.playEffect(55, targetPosx, targetPosy)
		if not self.currentEffect then
			self.batch:removeChild(self.currentEffect, false)
		end
		
		self.batch:addChild(effect)
		self.currentEffect = effect
		self.attackPathParticle:stopSystem()
    end
	
	local function onCompletePoint()
		if not self.attackPathParticle then
			self:removeChild(self.attackPathParticle, false)
		end
		-- add particle skill point
		local particleSun = BattleAction.attackPointTo(1, srcPosx, srcPosy, targetPosx, targetPosy, onComplete)
		self.attackPathParticle = particleSun
		self:addChild(particleSun)
	end
	
	BattleAction.attackShake(unit, onCompletePoint)
	
	--local action = CCMoveBy:create(0.2, ccp(100, 0))

    --local args = {
    --    delay = 3.0,                        -- before moving, delay 3.0 seconds
    --    easing = "CCEaseBackInOut",         -- use CCEaseBackInOut for easing
    --    onComplete = function()             -- call function after moving completed
    --        echo("MOVING COMPLETED")
    --    end,
    -- }
    --transition.execute(unit, action, args)
	
end



return MainScene
