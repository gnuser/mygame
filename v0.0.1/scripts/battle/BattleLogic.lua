BattleLogic = {}


BattleLogic.actionList = QueueUtil.new()
BattleLogic.isRunning = false

function BattleLogic.setActionList(actionList)
	BattleLogic.actionList = actionList
end

function BattleLogic.start()
	print("BattleLogic.start enter")	
	-- ����������в�Ϊ��
	if not QueueUtil.isEmpty(BattleLogic.actionList) then
		-- �����ǰ�Ѿ��ж�������������, ȡ���ȴ�ŵĶ���
		local action = QueueUtil.popright(BattleLogic.actionList)
		BattleLogic.runAction(action)
	else
		BattleLogic.isRunning = false
	end
end

function BattleLogic.pause()
end

function BattleLogic.resume()

end

function BattleLogic.stop()
end

function BattleLogic.reset()
end

function BattleLogic.addAction(info, handle, instance, arg)

	local action = Action:new(info, BattleLogic.start, handle, instance, arg)
	
	QueueUtil.pushright(BattleLogic.actionList, action)
	
	if not BattleLogic.isRunning then
		BattleLogic.start()
	end
end

function BattleLogic.runAction(action)
	print("BattleLogic.runAction," .. action.info)
	action:run()
	BattleLogic.isRunning = true
end

-- test
--BattleLogic.addAction()
--BattleLogic.start()
