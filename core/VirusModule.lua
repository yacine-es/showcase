local CollectionService = game:GetService("CollectionService")
local VirusModule = {
	SoundModule = require(script.Parent:WaitForChild("SoundModule")),
	SpawnWithVirus = true,
	VirusSystem = true,
}
local Viruses = {}
local VirusData = {}
VirusModule.__index = VirusModule

function VirusModule.SpreadingFunction(client,v,heal)
	if VirusData[client] then
		if heal then
			VirusData[client]:Heal(v)
		elseif not VirusData[client].Immune then
			VirusData[client]:Give(v)
		end
	end
end

VirusModule.SpreadingEvent = Instance.new("BindableEvent",script)
VirusModule.SpreadingEvent.Event:Connect(VirusModule.SpreadingFunction)


function VirusModule.new(Client,Immune,TotalImmune)
	local self = {}
	setmetatable(self,VirusModule)
	
	if Immune then Immune = true else Immune = false end
	if TotalImmune then TotalImmune = true else TotalImmune = false end
	
	self.Client = Client
	self.Virus = {}
	self.Phase = {}
	self.Sickness = {}
	self.Automatic = {}
	self.Spreading = {}
	self.Healed = {}
	self.Immune = Immune
	self.TotalImmune = TotalImmune
	self.Temperature = math.random(370,380)/10
	self.Tumor = false
	self.Heartbeat = math.random(60,100)
	self.Systelic = math.random(110,120)
	self.Diastolic = math.random(70,80)
	self.MuscleMass = math.random(700,850)/10
	VirusData[Client] = self
	return self
end

function VirusModule:LoadVirus()
	if not self.TotalImmune and VirusModule.VirusSystem and VirusModule.SpawnWithVirus then
		for i, v in pairs(VirusModule.Virus) do
			local rate = math.random(0,100)
			if self.Immune then rate = rate * 1.5 end
			if rate <= v.Rate then
				self:Give(v.Name)
			end
		end
	end
	return self
end

function VirusModule:Give(v,worsen)
	if Viruses[v] then
		print("GIVING VIRUS ("..v..") TO "..self.Client.Name)
		if not self.Virus[v] then
			self.Virus[v] = v
			self.Phase[v] = 1
			self.Healed[v] = false
			self:Setup(v)
			self:Automation(v)
		elseif worsen then
			self.Phase[v] = self.Phase[v] + 1
		end
	end
	return self
end

function VirusModule:Heal(v)
	if self.Virus[v] then
		self.Healed[v] = true
		self.Virus[v] = nil
		self.Phase[v] = nil
		self.Automatic[v] = nil
		self.Sickness[v] = nil
	end
	return self
end

function VirusModule:Setup(v)
	if Viruses[v] then
		if not self.Sickness[v] then
			self.Sickness[v] = Viruses[v].Setup(self)
			coroutine.resume(self.Sickness[v])
		end
		if not self.Spreading[v] then
			self.Spreading[v] = Viruses[v].Spreading(self)
			coroutine.resume(self.Spreading[v])
		end
	end
end

function VirusModule:Automation(v)
	if self.Sickness[v] and not self.Automatic[v] then
		self.Automatic[v] = Viruses[v].Automatic(self)
		coroutine.resume(self.Automatic[v])
	end
end

function VirusModule:Destroy()
	for i, v in pairs(self.Virus) do
		self:Heal(v.Name)
		if self.Spreading[v] then
			coroutine.close(self.Spreading[v])
		end
		if self.Automatic[v] then
			coroutine.close(self.Automatic[v])
		end
		if self.Sickness[v] then
			coroutine.close(self.Sickness[v])
		end
	end
	VirusData[self.Client] = nil
	self = nil
	return nil
end

function VirusModule.Load(Virus,Event)
	VirusModule.Virus = Virus
	VirusModule.Event = Event
	for i, v in pairs(VirusModule.Virus) do
		local virusmodule = script:FindFirstChild(v.Name)
		if virusmodule then
			Viruses[v.Name] = require(virusmodule)
			Viruses[v.Name].Load(VirusModule.SpreadingEvent)
		else
			VirusModule.Virus[i] = nil
		end
	end
end

return VirusModule