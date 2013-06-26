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
        CCMoveBy:create(0.1, ccp(5, 0)),   -- moving right
        CCMoveBy:create(0.1, ccp(-10, 0)),   -- moving up
        CCMoveBy:create(0.1, ccp(5, 0)),   -- moving up
        CCCallFunc:create(onComplete),          -- call function
    })

    targetObj:runAction(action)
end

-- 播放技能特效
function BattleAction.playEffect(id, posx, posy)
	-- test animation
	if not BattleAction.effectFramesListById[id] or not BattleAction.effectAnimationListById[id] then
		local resPath = id .. "00%02d.png"
		BattleAction.effectFramesListById[id] = display.newFrames(resPath, 1, 22)
       
	end
	BattleAction.effectAnimationListById[id] = display.newAnimation(BattleAction.effectFramesListById[id], 0.4 / 8)
	print("effect animation:" .. tostring(BattleAction.effectAnimationListById[id]))
    local effect = display.newSpriteWithFrame(BattleAction.effectFramesListById[id][1])
    effect:playAnimationOnce(BattleAction.effectAnimationListById[id], true)
    effect:setPosition(posx, posy)
	return effect
end

function BattleAction.attackPointTo(id, srcPosx, srcPosy, targetPosx, targetPosz, callback, ...)
	local particleSun = CCParticleSun:createWithTotalParticles(200)

    particleSun:setTexture( CCTextureCache:sharedTextureCache():addImage("particle/fire.png") )


	particleSun:setPosition(srcPosx, srcPosy)
	
	local function onComplete()
		if callback then
			callback(arg)
		end
        echo("BattleAction.attackPointTo SEQUENCE COMPLETED")
    end

    local action = transition.sequence({
        CCMoveTo:create(0.5, ccp(targetPosx, targetPosz)),   -- moving right
        CCCallFunc:create(onComplete),          -- call function
    })

    particleSun:runAction(action)
	return particleSun
end