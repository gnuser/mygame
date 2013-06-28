Action = {}

function Action:new( info, callback, handle, instance, arg )
	o = {}
	o.info = info
	o.handle = handle
	o.instance = instance
	o.callback = callback
	o.handleArg = arg
	print("arg:" .. tostring(arg))
	
	setmetatable(o,self)
	self.__index = self
	return o
end

function Action:run()
	if self.handle then
		if not self.handleArg then
			return
		end
		local argnum = table.getn(self.handleArg)
		print("arg number:" .. argnum)
		if argnum == 1 then
			self.handle(self.instance, self.handleArg[1], self.callback)
		elseif argnum == 2 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.callback)
		elseif argnum == 3 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.callback)
		elseif argnum == 4 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.callback)
		elseif argnum == 5 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.handleArg[5], self.callback)
		elseif argnum == 6 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.handleArg[5], self.handleArg[6],self.callback)
		elseif argnum == 7 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.handleArg[5], self.handleArg[6], self.handleArg[7], self.callback)
		elseif argnum == 8 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.handleArg[5], self.handleArg[6], self.handleArg[7], self.handleArg[8], self.callback)
		elseif argnum == 9 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.handleArg[5], self.handleArg[6], self.handleArg[7], self.handleArg[8], self.handleArg[9], self.callback)			
		elseif argnum == 10 then
			self.handle(self.instance, self.handleArg[1], self.handleArg[2], self.handleArg[3], self.handleArg[4], self.handleArg[5], self.handleArg[6], self.handleArg[7], self.handleArg[8], self.handleArg[9], self.handleArg[10], self.callback)		
		end
	end
end
