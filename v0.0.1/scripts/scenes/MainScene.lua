local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
--[[
91,361,229,499
124,189,156,221
160,225,198,263
135,200,266,331
60,128,285,355
30,95,215,280
65,130,150,215
--]]
-- 阵营双方站位坐标
local party_position = BattlePosition.party_position

local random = math.random

function MainScene:ctor()
    -- add input layer
	self.layer = display.newLayer()
    self:addChild(self.layer)
	
	-- add bg
	self.bg = display.newBackgroundSprite("map/battle_bg_1.png")
    self:addChild(self.bg)
	
	-- init battle demo
	self:initBattle()
	
	-- test particle
	local emitter = CCParticleSystemQuad:create("particle/fire.plist")
    --emitter:initWithFile("particle/mygame.plist"
	local posx, posy = self.battleUnits[1][2]:getPosition()
	--local size = self.battleUnits[1][2]:getContentSize()
	--print (size.width .. "," .. size.height)
	emitter:setPosition(posx, posy -60)
	self:addChild(emitter);
	
	
	--emitter = CCParticleSystemQuad:create("particle/snow.plist")
	--emitter:setPosition(0, 480)
	--self:addChild(emitter)
	
	self.batch = display.newBatchNode(GAME_TEXTURE_EFFECT_55_IMAGE_FILENAME, 10)
    self:addChild(self.batch)
	
	
	self:initUI()
	
	
	-- particle list
	self.attackPathParticles = {}
	self.attackExplosionParticles = {}
	
end

function MainScene:onEdit(event)
	-- execute command
	print("execute command: " .. event.target:getText())
end

function MainScene:executeCommand()
	print("execute command: " .. self.commandEditBox:getText())
	local cmdStr = self.commandEditBox:getText()
	local commandList = string.split(cmdStr, ";")
	
	for i=1, table.getn(commandList) do
		self:executeSingleCommand(commandList[i])
	end
end

function MainScene:executeSingleCommand(singlecmd)
	local commandStr = string.split(singlecmd, " ")
	local commandArgs = string.split(commandStr[2], ",")
	
	if commandStr[1] == "a" then
		-- test action
		BattleLogic.addAction("attack", MainScene.attackBattleUnit, self, {tonumber(commandArgs[1]), tonumber(commandArgs[2]), 
								tonumber(commandArgs[3]), tonumber(commandArgs[4])})
	elseif commandStr[1] == "s" then
		local unit = self.battleUnits[tonumber(commandArgs[1])][tonumber(commandArgs[2])]
		if unit then
			self.selectedUnit = unit
		end
    -- 攻击多个目标			
	elseif commandStr[1] == "am" then
		-- test attack more targets
		local src = {part = tonumber(commandArgs[2]), index = tonumber(commandArgs[1])}
		print("src:" .. src.part .. "," .. src.index)
		local targets = {}
		local targetList = string.split(commandArgs[3], ":")
		for k, v in ipairs(targetList) do
			local target = {part=tonumber(commandArgs[4]), index=tonumber(v)}
			table.insert(targets, target)
			print("target:" .. target.part .. "," .. target.index)
		end
		BattleLogic.addAction("attack", MainScene.attackBattleUnits, self, {src, targets})
	end	
end
	
function MainScene:initBattle()
	self.battleUnits = { {}, {} } -- 两个阵营
	
	-- 获取战斗单元数据
	
	-- 创建战斗单元
	table.insert(self.battleUnits[1],  self:addBattleUnit(3, display.left+party_position[1][1][1], display.top - party_position[1][1][2], 1, true))
	table.insert(self.battleUnits[2], self:addBattleUnit(4, display.right-party_position[2][1][1], display.bottom + party_position[2][1][2], 2, true))

	for i=2, 7 do
		table.insert(self.battleUnits[1], self:addBattleUnit(8+i-1, 
					display.left + party_position[1][i][1], display.top - party_position[1][i][2], 1))
		--print(display.right-party_position[1][i][1] .. "," .. display.bottom + party_position[1][i][2])
		
		table.insert(self.battleUnits[2], self:addBattleUnit(8+i-1, 
					display.right-party_position[2][i][1], display.bottom + party_position[2][i][2], 2))
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
function MainScene:addBattleUnit(index, posx, posy, part, isPlayer)
	local resPath
	local battleUnit
	if isPlayer then
		resPath = "player/player_".. index .. ".png"
		battleUnit = BattleUnit:new(resPath, 1, -70)
	else
		resPath = "weapon/weapon_".. index .. ".png"
		battleUnit = BattleUnit:new(resPath, 0.7, -55)
	end
		
	battleUnit:setPosition(posx, posy)
	
	if part == 2 then
		battleUnit:setFlipX(true)
	end
	self:addChild(battleUnit:getViewNode())
	return battleUnit
end

function MainScene:attackBattleUnit(srcIndex, srcPart, targetIndex, targetPart, callback)
	print("MainScene:attackBattleUnit enter:" .. tostring(callback))
	local unit = self.battleUnits[srcPart][srcIndex]
	local targetUnit = self.battleUnits[targetPart][targetIndex]
	
	if not unit or not targetUnit then
		return
	end
	local targetPosx, targetPosy = targetUnit:getPosition()
	local srcPosx, srcPosy = unit:getPosition()
	
	local function attackEndCallback()
	end
	
	local function playEffectCallback()
		self.attackExplosionParticle:stopSystem()
		if callback then
			callback()
		end
	end
	
	local function onComplete()
		--[[
		local effect = BattleAction.playEffect(55, targetPosx, targetPosy, playEffectCallback)
		if self.currentEffect then
			self.batch:removeChild(self.currentEffect, false)
		end
		
		self.batch:addChild(effect)
		self.currentEffect = effect
		--]]
		self.attackPathParticle:stopSystem()
		-- add explosion
		if self.attackExplosionParticle then
			self:removeChild(self.attackExplosionParticle, false)
		end
		
		local particleExplosion = BattleAction.attackExplosion(targetPosx, targetPosy, playEffectCallback)
		self.attackExplosionParticle = particleExplosion
		self:addChild(particleExplosion)
		
		BattleAction.attackedShake(targetUnit:getViewNode())
    end
	
	local function onCompletePoint()
		if self.attackPathParticle then
			self:removeChild(self.attackPathParticle, false)
		end
		-- add particle skill path
		local particleSun = BattleAction.attackPath(1, srcPart, srcPosx, srcPosy, targetPosx, targetPosy, onComplete)
		self.attackPathParticle = particleSun
		self:addChild(particleSun)
	end
	
	BattleAction.attackShake(unit:getViewNode(), onCompletePoint)
	
end

-- src: 攻击单位 
-- targets: 被攻击单位， 可为多个
function MainScene:attackBattleUnits(src, targets, callback)
	print("MainScene:attackBattleUnits enter:" .. tostring(callback))
	local srcUnit = self.battleUnits[src.part][src.index]
	if not srcUnit then
		return
	end
	local srcPosx, srcPosy = srcUnit:getPosition()
	local targetNum = table.getn(targets)
	self.attackPathParticleCount = targetNum	-- 记录路径特效个数
	self.attackExplosionParticleCount = targetNum	-- 记录爆炸特效个数
	
	local function explosionCallback()
		self.attackExplosionParticleCount = self.attackExplosionParticleCount - 1
		print("attack explosion left count:" .. self.attackExplosionParticleCount )
		if self.attackExplosionParticleCount <= 0 then
			for k,v in ipairs(self.attackExplosionParticles) do
				v:stopSystem()
			end		
			if callback then
				callback()
			end			
		end
	end
	
	local function pathComplete()
		self.attackPathParticleCount = self.attackPathParticleCount - 1
		print("attack path left count:" .. self.attackPathParticleCount )
		if self.attackPathParticleCount <= 0 then
			for k,v in ipairs(self.attackPathParticles) do
				v:stopSystem()
			end				
				
			-- clear first
			if table.getn(self.attackExplosionParticles) > 0 then
				for k,v in ipairs(self.attackExplosionParticles) do
					self:removeChild(v, false)
				end			
			end
			for k,v in ipairs(targets) do
				local targetUnit = self.battleUnits[v.part][v.index]
				if not targetUnit then
					return
				end
				-- add explosion
				local targetPosx, targetPosy = targetUnit:getPosition()
				local particleExplosion = BattleAction.attackExplosion(targetPosx, targetPosy, explosionCallback)
				
				table.insert(self.attackExplosionParticles, particleExplosion)
				self:addChild(particleExplosion)
			
				-- attacked shake
				BattleAction.attackedShake(targetUnit:getViewNode())
			end
		end
	end
	
	local function onCompletePoint()
		if table.getn(self.attackPathParticles) > 0 then
			for k,v in ipairs(self.attackPathParticles) do
				self:removeChild(v, false)
			end			
		end
		-- add particle skill path
		for k,v in ipairs(targets) do
			local targetUnit = self.battleUnits[v.part][v.index]
			if not targetUnit then
				return
			end
			local targetPosx, targetPosy = targetUnit:getPosition()
			local particleSun = BattleAction.attackPath(1, src.part, srcPosx, srcPosy, targetPosx, targetPosy, pathComplete)
			table.insert(self.attackPathParticles, particleSun)
			self:addChild(particleSun)
		end
	end
	
	BattleAction.attackShake(srcUnit:getViewNode(), onCompletePoint)
end

function MainScene:isInRect(rect, point)
	if point.x >= rect:getMinX() and point.x <= rect:getMaxX() then
		if point.y >= rect:getMinY() and point.y <= rect:getMaxY() then
			return true
		end
	end
	
	return false
end

function MainScene:getUnitByPoint(point)
	local unit = nil
	for k, v in pairs(self.battleUnits[1]) do
		local bbox = v:boundingBox()
		--print (bbox:getMinX() .. "," .. bbox:getMaxX() .. "," .. bbox:getMinY() .. "," .. bbox:getMaxY())
		--if bbox:containsPoint(point) then
		if self:isInRect(bbox, point) then
			print("find unit:" .. k)
			unit = v
			return unit
		end
	end
	print("----")
	for k2, v2 in pairs(self.battleUnits[2]) do
		local bbox = v2:boundingBox()
		--print (bbox:getMinX() .. "," .. bbox:getMaxX() .. "," .. bbox:getMinY() .. "," .. bbox:getMaxY())
		if bbox:containsPoint(point) then
			print("find unit:" .. k2)
			unit = v2
			return unit
		end
	end
end

function MainScene:printPositions()
	for k, v in pairs(self.battleUnits[1]) do
		local bbox = v:boundingBox()
		print (bbox:getMinX() .. "," .. bbox:getMaxX() .. "," .. bbox:getMinY() .. "," .. bbox:getMaxY())
	end
	print("----")
	for k2, v2 in pairs(self.battleUnits[2]) do
		local bbox = v2:boundingBox()
		print (bbox:getMinX() .. "," .. bbox:getMaxX() .. "," .. bbox:getMinY() .. "," .. bbox:getMaxY())
	end
end
function MainScene:onTouch(event, x, y)
    if event == "began" then
        local p = ccp(x, y)
        print("touch p:" .. x .. "," .. y)
		local unit = self:getUnitByPoint(p)
		if unit then
			self.originPoint = ccp(x,y)
			
		end
		self.selectedUnit = unit
		
        return true
    elseif event ~= "moved" then
		
		if self.selectedUnit then
			local deltaX = x - self.originPoint.x
			local deltaY = y - self.originPoint.y
			self.originPoint = ccp(x,y)
			self:changeUnitPosition(self.selectedUnit, deltaX, deltaY)
		end
    end
end

function MainScene:onEnter()

    self.layer:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end)
    self.layer:setTouchEnabled(true)
	
	if device.platform ~= "android" then return end

    -- avoid unmeant back
    self:performWithDelay(function()
        -- keypad layer, for android
        self.layer:addKeypadEventListener(function(event)
            if event == "back" then game.exit() end
			self:onKey(event)
        end)

        self.layer:setKeypadEnabled(true)
    end, 0.5)
end

function MainScene:onKey(event)
	print("key event ")
end

function MainScene:setUnitPosition(unit, x, y)
	unit:setPosition(x, y)
end

function MainScene:changeUnitPosition(unit, deltax, deltay)
	local posx, posy = unit:getPosition()
	
	unit:setPosition(posx+deltax, posy+deltay)
end

function MainScene:initUI()
	-- add debug command text input
	local editBoxBg = CCScale9Sprite:create("ui/inputbox.png")
    local editBox = CCEditBox:create(CCSize(100, 20), editBoxBg)
    editBox:setPosition(CCPoint(display.cx/2, display.top - 300))
    self:addChild(editBox)
	self.commandEditBox = editBox
	
	-- add debug command button
	local upButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 200,
        y = display.bottom + 100,
        listener = function()            
			--self:executeCommand()
			if self.selectedUnit then
				local posx, posy = self.selectedUnit:getPosition()
				self:setUnitPosition(self.selectedUnit, posx, posy+1)
			end
        end,
    })
	
	local rightButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 250,
        y = display.bottom + 80,
        listener = function()            
			--self:executeCommand()
			if self.selectedUnit then
				local posx, posy = self.selectedUnit:getPosition()
				self:setUnitPosition(self.selectedUnit, posx+1, posy)
			end
        end,
    })
	
	local downButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 200,
        y = display.bottom + 50,
        listener = function()            
			--self:executeCommand()
			if self.selectedUnit then
				local posx, posy = self.selectedUnit:getPosition()
				self:setUnitPosition(self.selectedUnit, posx, posy-1)
			end
        end,
    })
	
	local leftButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 150,
        y = display.bottom + 80,
        listener = function()
			if self.selectedUnit then
				local posx, posy = self.selectedUnit:getPosition()
				self:setUnitPosition(self.selectedUnit, posx-1, posy)
			end
			--self:executeCommand()
        end,
    })
	
	
	local commandButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 200,
        y = display.bottom + 20,
        listener = function()            
			self:executeCommand()
        end,
    })
	
	local printPosButton = ui.newImageMenuItem({
        image = "ui/yellow_button_normal.png",
        imageSelected = "ui/yellow_button_selected.png",
        x = display.left + 50,
        y = display.bottom + 50,
        listener = function()            
			self:printPositions()
        end,
    })
	local menu = ui.newMenu({commandButton, upButton, rightButton, downButton, leftButton, printPosButton})
    self:addChild(menu)
end
return MainScene
