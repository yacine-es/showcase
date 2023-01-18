local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local StaterGui = game:GetService("StarterGui")
local DisableControlScript = script:WaitForChild("DisableControl")
local EnableControlScript = script:WaitForChild("EnableControl")
local SurfaceGui = script:WaitForChild("SurfaceGui")
local AnimationBaggage = script:WaitForChild("Baggage")
local ActualBaggage = script:WaitForChild("ActualBaggage")
local Event = Instance.new("RemoteEvent")
Event.Name = "SecurityBagDropSystem"
Event.Parent = game:GetService("ReplicatedStorage")
local allsecurities = {}
local allsets = {}
local ScannerModule = {}
ScannerModule.__index = ScannerModule

local SetModule = {}
SetModule.__index = SetModule


Event.OnServerEvent:Connect(function(client,id,action)
	local self = allsets[tonumber(id)]
	if client:GetRankInGroup(1156950) >= 190 and self then
		if action == "start" then
			self.Online = true
			self.Markers:WaitForChild("Scanner").Reflectance = 1
			self:UpdateQueue()
			self.surfaceguilastaction.Value = "open"
			Event:FireAllClients(id,"open")
		elseif action == "close" then
			self.Online = false
			self.Markers:WaitForChild("Scanner").Reflectance = 0
			self:UpdateQueue()
			self.surfaceguilastaction.Value = "close"
			Event:FireAllClients(id,"close")
		elseif action == "search" then
			self.MustCheck = true
			Event:FireAllClients(id,"bagsearch")
		elseif action == "bagsearch" then
			self
		elseif action == "bagready" then
			
		end
	end
end)


function ScannerModule.new(ScannerModel,UpdateWait,SetUpdateWait)
	local self = {}
	setmetatable(self, ScannerModule)

	self.Model = ScannerModel
	self.UpdateWait = tonumber(UpdateWait)
	self.Line = ScannerModel:WaitForChild("Line")
	self.LinePosition = {}
	self.Updating = false
	self.Exit = self.Line:WaitForChild("Exit")
	self.sets = {}
	for i, v in pairs(ScannerModel:GetChildren()) do
		if v.Name == "Sets" then
			table.insert(self.sets,SetModule.new(v,SetUpdateWait,self))
		end
	end
	local positions = {}
	for i, v in pairs(self.Line:GetChildren()) do
		if tonumber(v.Name) then
			table.insert(positions,{v,tonumber(v.Name)})
		end
	end
	table.sort(positions, function(a,b)
		return a[2] < b[2]
	end)
	
	for i, v in pairs(positions) do
		self.LinePosition[i] = {
			["part"] = v[1],
			["occupied"] = nil
		}
	end
	
	local debounce = true
	self.Line:WaitForChild("Entrance").Touched:Connect(function(p)
		if debounce then
			debounce = false
			if p.Parent:FindFirstChildOfClass("Humanoid") then
				local client = Players:GetPlayerFromCharacter(p.Parent)
				if client then
					self:JoinQueue(client,p.Parent)
				end
			end
			debounce = true
		end
	end)
	return self
end


function ScannerModule:JoinQueue(client,character)
	if self.LinePosition[#self.LinePosition].occupied == nil then
		self.LinePosition[#self.LinePosition].occupied = client
		local disablecopy = DisableControlScript:Clone()
		disablecopy.Parent = client.PlayerGui
		Debris:AddItem(disablecopy,1)
		character:FindFirstChildOfClass("Humanoid"):MoveTo(self.LinePosition[#self.LinePosition].part.Position)
		self:UpdateQueue()
	elseif self.LinePosition[#self.LinePosition].occupied ~= client then
		character:FindFirstChild("HumanoidRootPart").Position = self.Exit.Position
	end
end

function ScannerModule:Request(id)
	print("REQUESTING")
	local set = allsets[tonumber(id)]
	if self.LinePosition[1].occupied and not set.Clients.Baggage.Client then
		if self.LinePosition[1].occupied.Character then
			print("SOMEONE CAN GO")
			set.Clients.Baggage.Client = self.LinePosition[1].occupied
			set.Clients.Baggage.Status = "PrepareDrop"
			self.LinePosition[1].occupied = nil
			print(set)
			set:UpdateQueue()
			self:UpdateQueue()
		end
	end
end

function ScannerModule:UpdateQueue()
	if self.Updating then return end
	task.spawn(function()
		self.Updating = true
		local updated = true
		while updated do
			print("UPDATING LINE")
			updated = false
			for i, v in pairs(self.LinePosition) do
				if i > 1 then
					if self.LinePosition[i-1].occupied == nil and self.LinePosition[i].occupied ~= nil then
						updated = true
						if self.LinePosition[i].occupied.Character then
							if table.find(workspace:GetPartsInPart(self.LinePosition[i].part),self.LinePosition[i].occupied.Character:WaitForChild("HumanoidRootPart")) then
								self.LinePosition[i-1].occupied = self.LinePosition[i].occupied
								self.LinePosition[i].occupied = nil
								self.LinePosition[i-1].occupied.Character:FindFirstChildOfClass("Humanoid"):MoveTo(self.LinePosition[i-1].part.Position)
							else
								self.LinePosition[i].occupied.Character:FindFirstChildOfClass("Humanoid"):MoveTo(self.LinePosition[i].part.Position)
							end
						else
							self.LinePosition[i].occupied = nil
						end
					end
				elseif i == 1 then
					if self.LinePosition[i].occupied then
						updated = true
						if self.LinePosition[i].occupied.Character then
							if table.find(workspace:GetPartsInPart(self.LinePosition[i].part),self.LinePosition[i].occupied.Character:WaitForChild("HumanoidRootPart")) then
								for i, v in pairs(self.sets) do
									if v.Online and not v.Clients.Baggage.Client then
										v:UpdateQueue()
										break
									end
								end
							else
								self.LinePosition[i].occupied.Character:FindFirstChildOfClass("Humanoid"):MoveTo(self.LinePosition[i].part.Position)
							end
						else
							self.LinePosition[i].occupied = nil
						end
					end
				end
			end
			if not updated then
				self.Updating = false
			else
				wait(self.UpdateWait)
			end
		end
	end)
end

function SetModule.new(Set,UpdateWait,Line)
	local self = {}
	setmetatable(self,SetModule)
	local id = math.random(0,10000)
	while allsets[id] do
		id = math.random(0,10000)
	end
	self.id = tostring(id)
	allsets[id] = self
	self.Online = false
	self.Line = Line
	self.UpdateWait = UpdateWait
	self.Clients = {
		["Baggage"] = {
			["Client"] = nil,
			["Status"] = nil
		},
		["Scanner"] = {
			["Client"] = nil,
			["Status"] = nil
		}
	}
	self.TemporaryStop = false
	self.CurrentBag = nil
	self.GoodBag = nil
	self.Markers = Set:WaitForChild("Markers")
	local debouces = true
	self.Markers:WaitForChild("DropBaggage").Touched:Connect(function(p)
		if debouces then
			debouces = false
			if self.Online and not self.TemporaryStop and p.Parent:FindFirstChild("Humanoid") and not p.Parent:FindFirstChild("DropBaggage") and not self.CurrentBag then--if p.Parent == self.Clients.Baggage.Client.Character then
				local animation = Instance.new("Animation",p.Parent)
				task.spawn(function()
					animation.Name = "DropBaggage"
					animation.AnimationId = "rbxassetid://11821691060"
					p.Parent.Humanoid.WalkSpeed = 0
					p.Parent:WaitForChild("HumanoidRootPart").Anchored = true
					local bagtool = p.Parent
					wait()
					p.Parent.HumanoidRootPart.Anchored = false
					wait()
					p.Parent.HumanoidRootPart.Anchored = true
					p.Parent.HumanoidRootPart.CFrame = self.Markers.DropBaggage.CFrame
					p.Parent.Humanoid.WalkSpeed = 16
					local tempbaggage = AnimationBaggage:Clone()
					self.CurrentBag = ActualBaggage:Clone()
					self.CurrentBag.PrimaryPart.ProximityPrompt.ObjectText = "Baggage - "..p.Parent.Name
					self.CurrentBag.PrimaryPart.ProximityPrompt.Triggered:Connect(function(player)
						if player:GetRankInGroup(1156950) >= 90 then
							Event:FireAllClients(self.id,"bagcleared")
							self.CurrentBag.PrimaryPart.ProximityPrompt.Enabled = false
							self.CurrentBag = nil
						end
					end)
					for i, v in pairs(tempbaggage:GetChildren()) do
						v.Parent = p.Parent
						if v.Name == "BodyAttach" then
							v.CFrame = self.Markers.BaggageSpawn.CFrame
						end
						Debris:AddItem(v,4)
					end
					tempbaggage:Destroy()
					--local track = self.Clients.Baggage.Client.Character:FindFirstChildOfClass("Humanoid"):WaitForChild("Animator"):LoadAnimation(animation)
					local track = p.Parent:FindFirstChild("Humanoid"):WaitForChild("Animator"):LoadAnimation(animation)
					track:Play()
					wait(4)
					p.Parent.HumanoidRootPart.Anchored = false
					self.CurrentBag.Parent = self.BagScanner
					self.CurrentBag.BodyAttach.CFrame = self.Markers.BaggageStart.CFrame
					self.MustCheck = false
					Event:FireAllClients(self.id,"bag")
					wait(4)
					animation:Destroy()
					if math.random(0,20) <= 1 then
						Event:FireAllClients(self.id,"bad")
					else
						Event:FireAllClients(self.id,"good")
					end
					wait(7)
					if self.MustCheck then
						self.CurrentBag.PrimaryPart.ProximityPrompt.Enabled = true
					else
						self.GoodBag = self.CurrentBag
						self.CurrentBag = nil
					end
				end)
			end
			debouces = true
		end
	end)
	self.BagScanner = Set:WaitForChild("BagScanner")
	self.Scanner = Set:WaitForChild("Scanner")
	self.surfacegui = SurfaceGui:Clone()
	self.surfaceguilastaction = self.surfacegui:WaitForChild("Value")
	self.surfacegui.Parent = StaterGui
	self.surfacegui.Name = id
	self.surfacegui.Adornee = self.BagScanner:WaitForChild("Screen")
	self.surfaceguilastaction.Value = "close"
	self.surfacegui:WaitForChild("LocalScript").Enabled = true
	return self
end

function SetModule:UpdateQueue()
	print("REQUESTED SET",self.Updating)
	if self.Updating then return end
	local function touching(part,client)
		if table.find(workspace:GetPartsInPart(part),client.Character:WaitForChild("HumanoidRootPart")) then
			return true
		else
			return false
		end
	end
	self.Updating = true
	task.spawn(function()
		local updated = true
		while updated do
			updated = false
			print("UPDATING SET")
			if not self.Online then self.Updating = false return end
			if self.Clients.Baggage.Client then
				if self.Clients.Baggage.Client.Character then
					updated = true
					if self.Clients.Baggage.Status == "PrepareDrop" then
						if touching(self.Markers.PrepareDrop,self.Clients.Baggage.Client) then
							self.Clients.Baggage.Status = "DropBaggage"
						else
							self.Clients.Baggage.Client.Character.Humanoid:MoveTo(self.Markers.PrepareDrop.Position)
						end
					elseif self.Clients.Baggage.Status == "DropBaggage" then
						if touching(self.Markers.DropBaggage,self.Clients.Baggage.Client) then
							self.Clients.Baggage.Status = "DropBaggageWait"
						else
							self.Clients.Baggage.Client.Character.Humanoid:MoveTo(self.Markers.DropBaggage.Position)
						end
					elseif self.Clients.Baggage.Status == "DropBaggageWait" then
						if touching(self.Markers.DropBaggage,self.Clients.Baggage.Client) and not self.Clients.Scanner.Client then
							self.Clients.Scanner.Client = self.Clients.Baggage.Client
							self.Clients.Scanner.Status = "PrepareScanner"
							self.Clients.Baggage.Client = nil
							self.ClientCheck = false
						else
							self.Clients.Baggage.Client.Character.Humanoid:MoveTo(self.Markers.DropBaggage.Position)
						end
					end
				else
					self.Clients.Baggage.Client = nil
				end
			else
				self.Clients.Baggage.Client = nil
			end
			if not self.Clients.Baggage.Client then
				if self.Line.LinePosition[1].occupied then
					updated = true
					self.Line:Request(self.id)
				end
			end
			if self.Clients.Scanner.Client then
				updated = true
				if self.Clients.Scanner.Client.Character then
					if self.Clients.Scanner.Status == "PrepareScanner" then
						if touching(self.Markers.PrepareScanner,self.Clients.Scanner.Client) then
							self.Clients.Scanner.Status = "Scanner"
						else
							self.Clients.Scanner.Client.Character.Humanoid:MoveTo(self.Markers.PrepareScanner.Position)
						end
					elseif self.Clients.Scanner.Status == "Scanner" then
						if touching(self.Markers.Scanner,self.Clients.Scanner.Client) then
							if math.random(0,30) <= 1 then
								self.Markers.Scanner:WaitForChild("Bad"):Play()
								task.spawn(function() wait(1) self.Markers.Scanner.Bad:Stop() end)
								self.Clients.Scanner.Status = "ProcessSearch"
							else
								self.Markers.Scanner:WaitForChild("Good"):Play()
								self.Clients.Scanner.Status = "ProcessClear"
							end
						else
							self.Clients.Scanner.Client.Character.Humanoid:MoveTo(self.Markers.Scanner.Position)
						end
					elseif string.find(self.Clients.Scanner.Status,"Process") then
						if touching(self.Markers.Process,self.Clients.Scanner.Client) then
							self.Clients.Scanner.Status = string.sub(self.Clients.Scanner.Status,8)
						else
							self.Clients.Scanner.Client.Character.Humanoid:MoveTo(self.Markers.Process.Position)
						end
					elseif self.Clients.Scanner.Status == "Search" then
						if touching(self.Markers.Search,self.Clients.Scanner.Client) then
							self.Clients.Scanner.Client.Character:WaitForChild("Humanoid").WalkSpeed = 0
							self.Clients.Scanner.Client.Character:WaitForChild("HumanoidRootPart").Anchored = true
							wait()
							self.Clients.Scanner.Client.Character.HumanoidRootPart.Anchored = false
							wait()
							self.Clients.Scanner.Client.Character.HumanoidRootPart.Anchored = true
							self.Clients.Scanner.Client.Character.HumanoidRootPart.CFrame = self.Markers.Search.CFrame
							self.Clients.Scanner.Client.Character.Humanoid.WalkSpeed = 16
							local proximity = Instance.new("ProximityPrompt",self.Clients.Scanner.Client.Character.HumanoidRootPart)
							proximity.ActionText = "Search"
							proximity.HoldDuration = 2
							proximity.ObjectText = self.Clients.Scanner.Client.Name
							proximity.RequiresLineOfSight = false
							proximity.PromptButtonHoldBegan:Connect(function()
								
							end)
							proximity.PromptButtonHoldEnded:Connect(function()

							end)
							proximity.Triggered:Connect(function(player)
								if player:GetRankInGroup(1156950) >= 90 then
									proximity:Destroy()
									self.Clients.Scanner.Status = "Clear"
									self:UpdateQueue()
								end
							end)
						else
							self.Clients.Scanner.Client.Character.Humanoid:MoveTo(self.Markers.Search.Position)
						end
					elseif self.Clients.Scanner.Status == "Clear" then
						if touching(self.Markers.Clear,self.Clients.Scanner.Client) then
							local enablecopy = EnableControlScript:Clone()
							enablecopy.Parent = self.Clients.Scanner.Client.PlayerGui
							Debris:AddItem(enablecopy,1)
							self.Clients.Scanner.Client = nil
						else
							self.Clients.Scanner.Client.Character.Humanoid:MoveTo(self.Markers.Clear.Position)
						end
					end
				else
					self.Clients.Scanner.Client = nil
				end
			else
				self.Clients.Scanner.Client = nil
			end
			if not updated then
				print("UPDATING SET END")
				self.Updating = false
			else
				wait(self.UpdateWait)
			end
		end
	end)
end

return ScannerModule
