local SoundModule = {
	SoundService = game:GetService("SoundService"),
	Sounds = {},
}
SoundModule.__index = SoundModule


function SoundModule.new(Id,Origin,Looped)
	if SoundModule.Sounds[Id] then
		local Data = {}
		setmetatable(Data,SoundModule)
		
		Data.Id = Id
		Data.Origin = Origin
		Data.Sound = Instance.new("Sound",Origin)
		Data.Sound.Name = Id
		Data.Sound.Looped = Looped
		Data.Sound.SoundGroup = SoundModule.Sounds[Id].Group
		Data.Sound.SoundId = "rbxassetid://"..SoundModule.Sounds[Id].Id
		Data.Sound.MaxDistance = SoundModule.Sounds[Id].Max
		Data.Sound.MinDistance = SoundModule.Sounds[Id].Min
		if SoundModule.Sounds[Id].Volume then
			Data.Sound.Volume = SoundModule.Sounds[Id].Volume
		end
		return Data
	end
end

function SoundModule:Play()
	self.Sound.Loaded:Wait()
	self.Sound:Play()
end

function SoundModule:Stop()
	self.Sound:Stop()
end

function SoundModule:Destroy(Later)
	if Later then
		self.Sound.Ended:Connect(function()
			self.Sound:Destroy()
			self = nil
		end)
	else
		self.Sound:Destroy()
		self = nil
	end
	return nil
end


function SoundModule.Load(Sounds)
	for i, v in pairs(Sounds) do
		if i == "Others" then
			for ii, vv in pairs(v) do
				SoundModule.Sounds[ii] = {Id = vv.Id,Volume = v.Volume, Max = vv.Max, Min = vv.Min}
			end
		else
			local SGroup = Instance.new("SoundGroup",SoundModule.SoundService)
			SGroup.Name = i
			SGroup.Volume = v.Volume
			for ii, vv in pairs(v.Sounds) do
				SoundModule.Sounds[ii] = {Id = vv,Group = SGroup, Max = v.Max, Min = v.Min}
			end
		end
	end
end



return SoundModule