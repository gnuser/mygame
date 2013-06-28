BattleAction = {}

-- 特效
BattleAction.effectFramesListById = {}
BattleAction.effectAnimationListById = {}

-- 击打抖动效果
function BattleAction.attackShake(targetObj, callback, ...)
	local function onComplete()
		if callback then
			callback(arg)
		end
        echo("SEQUENCE COMPLETED")
    end

    local action = transition.sequence({
        CCMoveBy:create(0.1, ccp(0, 5)),   -- moving right
        CCMoveBy:create(0.1, ccp(0, -10)),   -- moving up
        CCMoveBy:create(0.1, ccp(0, 5)),   -- moving up
        CCCallFunc:create(onComplete),          -- call function
    })

    targetObj:runAction(action)
end

-- 受击抖动效果
function BattleAction.attackedShake(targetObj, callback, ...)
	local function onComplete()
		if callback then
			callback(arg)
		end
        echo("SEQUENCE COMPLETED")
    end

    local action = transition.sequence({
        CCMoveBy:create(0.1, ccp(5, 0)),   -- moving right
        CCMoveBy:create(0.1, ccp(-10, 0)),   -- moving up
        CCMoveBy:create(0.1, ccp(5, 0)),   -- moving up
        CCCallFunc:create(onComplete),          -- call function
    })

    targetObj:runAction(action)
end

-- 播放技能特效
function BattleAction.playEffect(id, posx, posy, callback)
	-- test animation
	if not BattleAction.effectFramesListById[id] or not BattleAction.effectAnimationListById[id] then
		local resPath = id .. "00%02d.png"
		BattleAction.effectFramesListById[id] = display.newFrames(resPath, 1, 22)
       
	end
	BattleAction.effectAnimationListById[id] = display.newAnimation(BattleAction.effectFramesListById[id], 0.1 / 8)
	print("effect animation:" .. tostring(BattleAction.effectAnimationListById[id]))
    local effect = display.newSpriteWithFrame(BattleAction.effectFramesListById[id][1])
    effect:playAnimationOnce(BattleAction.effectAnimationListById[id], true, callback)
    effect:setPosition(posx, posy)
	return effect
end

-- 攻击打出的路线
function BattleAction.attackPath(id, srcPart, srcPosx, srcPosy, targetPosx, targetPosz, callback, ...)
	local particleSun = CCParticleSun:createWithTotalParticles(300)

    particleSun:setTexture( CCTextureCache:sharedTextureCache():addImage("particle/fire.png") )
	local startccColor = ccColor4F()
	startccColor.r = 224
	startccColor.g = 224
	startccColor.b = 224
	startccColor.a = 1
	particleSun:setStartColor(startccColor)
	local endccColor = ccColor4F()
	endccColor.r = 0
	endccColor.g = 0
	endccColor.b = 0
	endccColor.a = 1

	particleSun:setEndColor(endccColor)
	
	particleSun:setLife(0.2)
	particleSun:setLifeVar(0.1)
	if srcPart == 1 then
		particleSun:setPosition(srcPosx+30, srcPosy)
	else
		particleSun:setPosition(srcPosx-30, srcPosy)
	end
	
	particleSun:setPositionType(1)
	
	local function onComplete()
		if callback then
			callback(arg)
		end
        echo("BattleAction.attackPointTo SEQUENCE COMPLETED")
    end

    local action = transition.sequence({
        CCMoveTo:create(0.2, ccp(targetPosx, targetPosz)),   -- moving right
		CCDelayTime:create(0.1),
        CCCallFunc:create(onComplete),          -- call function
    })

    particleSun:runAction(action)
	return particleSun
end

function BattleAction.attackExplosion(x, y, callback, ...)
	print("BattleAction.attackExplosion enter")
	local particleSun = CCParticleExplosion:createWithTotalParticles(100)
	particleSun:setPosition(x, y)
    particleSun:setTexture( CCTextureCache:sharedTextureCache():addImage("particle/fire.png") )
	
	particleSun:setLife(0.3)
	particleSun:setLifeVar(0.1)
	local startccColor = ccColor4F()
	startccColor.r = 224
	startccColor.g = 224
	startccColor.b = 224
	startccColor.a = 1
	particleSun:setStartColor(startccColor)
	local endccColor = ccColor4F()
	endccColor.r = 224
	endccColor.g = 224
	endccColor.b = 224
	endccColor.a = 1

	particleSun:setEndColor(endccColor)
	
	local startccColorVar = ccColor4F()
	startccColorVar.r = 0
	startccColorVar.g = 0
	startccColorVar.b = 0
	startccColorVar.a = 0
	particleSun:setStartColorVar(startccColorVar)
	local endccColorVar = ccColor4F()
	endccColorVar.r = 0
	endccColorVar.g = 0
	endccColorVar.b = 0
	endccColorVar.a = 0
	
	particleSun:setEndColorVar(endccColorVar)
	local function onComplete()
		if callback then
			callback(arg)
		end
        echo("BattleAction.attackExplosion SEQUENCE COMPLETED")
    end

    local action = transition.sequence({
		CCDelayTime:create(0.1),
        CCCallFunc:create(onComplete),          -- call function
    })

    particleSun:runAction(action)
	return particleSun
end