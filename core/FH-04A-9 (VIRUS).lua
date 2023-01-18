local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local virus = {
	Name = "FH-04A-9",
	Disease = "Fisherman's Hands",
	Class = "Dangerous",
	Spreading = 100,
	StartMin = 5,
	StartMax = 10,
	AutomaticMin = 50,
	AutomaticMax = 60,
	SpreadingTime = 5,
	DeleteSpreadingTime = 1,
	SpreadingAfterHealTime = 10,
}

function virus.Setup(self)
	return coroutine.create(function()
		wait(math.random(virus.StartMin,virus.StartMax))
		while not self.Healed[virus.Name] do
			if self.Client.Character then
				if self.Phase[virus.Name] == 1 then
					self.Temperature = math.random(390,410)/10
					self.Heartbeat = math.random(80,120)
				elseif self.Phase[virus.Name] == 2 then
					self.Temperature = math.random(400,420)/10
					self.Heartbeat = math.random(100,120)
				elseif self.Phase[virus.Name] == 3 then
					self.Temperature = math.random(410,430)/10
					self.Heartbeat = math.random(110,120)
				elseif self.Phase[virus.Name] == 4 then
					self.Temperature = math.random(430,440)/10
					self.Heartbeat = math.random(150,180)
				else
					self.Temperature = math.random(370,380)/10
					self.Heartbeat = math.random(60,100)
					self.Client.Character:FindFirstChildOfClass("Humanoid").Health = self.Client.Character:FindFirstChildOfClass("Humanoid").Health - 40
					self:Heal(virus.Name)
					return self
				end
			end
			coroutine.yield(self)
		end
		return self
	end)
end

function virus.Automatic(self)
	return coroutine.create(function()
		wait(virus.StartMax)
		while not self.Healed[virus.Name] do
			wait(math.random(virus.AutomaticMin,virus.AutomaticMax))
			if not self.Healed[virus.Name] and self.Phase[virus.Name] < 5 then 
				self.Phase[virus.Name] = self.Phase[virus.Name] + 1
				coroutine.resume(self.Sickness[virus.Name])
			else
				return self
			end
		end
		return self
	end)
end

function virus.Spreading(self)
	return coroutine.create(function()
		self.SpreadingCooldown = virus.SpreadingAfterHealTime
		while wait(virus.SpreadingTime) do
			if self.Healed[virus.Name] then
				self.SpreadingCooldown = self.SpreadingCooldown - virus.SpreadingTime
				if self.SpreadingCooldown < 0 then
					return self
				end
			else
				self.SpreadingCooldown = virus.SpreadingAfterHealTime
			end
			if self.Client.Character then
				if not self.Client.Character:FindFirstChild("sealspreading") then
					local part = Instance.new("Part")
					local debounce = true
					local connection = false
					part.Anchored = true
					part.CanCollide = false
					part.Transparency = 1
					part.Size = Vector3.new(5,5,5)
					part.Position = self.Client.Character:WaitForChild("HumanoidRootPart").Position
					part.CanTouch = true
					part.Parent = workspace
					Debris:AddItem(part,virus.DeleteSpreadingTime)
					connection = part.Touched:Connect(function(touchedpart)
						if debounce then
							debounce = false
							if touchedpart.Parent:FindFirstChildOfClass("Humanoid") then
								local client = Players:GetPlayerFromCharacter(touchedpart.Parent)
								if client and client ~= self.Client then
									virus.SpreadingEvent:Fire(client,virus.Name)
									connection:Disconnect()
								end
							end
							debounce = true
						else return end
					end)
				end
			end
		end
	end)
end

function virus.Load(spreadingevent)
	virus.SpreadingEvent = spreadingevent
end

return virus
