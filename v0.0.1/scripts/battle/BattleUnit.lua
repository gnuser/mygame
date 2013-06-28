BattleUnit = {}

BattleUnit = class("BattleUnit", CCNodeExtend)

function BattleUnit:new(bodyRes, bodyScale, shadowOffset)
	o = {}
	o.viewNode = display.newNode()
	o.shadow = display.newSprite("player/shadow.png")
	o.shadow:setPosition(0, shadowOffset)
	o.viewNode:addChild(o.shadow)
	o.body = display.newSprite(bodyRes)
	o.body:setScale(bodyScale)
	o.viewNode:addChild(o.body)

	--o.title = o.instance = instance
	setmetatable(o,self)
	self.__index = self
	return o
end

function BattleUnit:setPosition(posx, posy)
	self.viewNode:setPosition(posx, posy)
end

function BattleUnit:getPosition()
	return self.viewNode:getPosition()
end

function BattleUnit:setFlipX()
	self.body:setFlipX(true)
end

function BattleUnit:getViewNode()
	return self.viewNode
end

function BattleUnit:boundingBox()
	local x, y = self:getPosition()
	local size = self.body:getContentSize()
	return CCRect(x, y, size.width, size.height)
	--print("body position:" .. x .. "," .. y)
	--return self.body:boundingBox()
end