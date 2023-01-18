local ProtocolModule = {}
ProtocolModule.__index = ProtocolModule

function ProtocolModule.load()
	local Protocol = {}
	setmetatable(Protocol,ProtocolModule)
	
	Protocol.CurrentCodes = {
		
	}
	Protocol.CurrentCode = ""
end

function ProtocolModule:Classification(Codes)
	
end

function ProtocolModule:Response(ARIs)

end

function ProtocolModule:Blackout(Sectors)

end

function ProtocolModule:Lockdown(Sectors)

end

function ProtocolModule:Evacuation()

end


return ProtocolModule
