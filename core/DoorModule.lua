local DoorModule = {}
local Data = {}
local PermissionModule = require(script.Parent:WaitForChild("PermissionModule"))
DoorModule.__index = DoorModule

function DoorModule.AutoCloseDoor(Door,Proximity)
	task.spawn(function()
		local id = math.random(0,1000)
		Door.MustClose = id
		wait(10)
		if Door.MustClose == id then
			Door.Status = "Wait"
			for i, v in pairs(Door.Proximities) do
				v.Enabled = false
			end
			Door:Close(Door.Type,Proximity)
			Door.Status = "Locked"
			Door.MustClose = false
			for i, v in pairs(Door.Proximities) do
				v.Enabled = true
				v.ObjectText = "Sector - "..Door.Sector.." | "..Door.Status
			end
		end
	end)
end


function DoorModule.DoorConnection(Door,Proximity,Client)
	if Door.LastClient == Client then
		Door:Invalid()
		Door.LastClient = false
	elseif PermissionModule.CheckPemission(Client,Door.Permissions,"DoorModule",Door.Sector) and Door.Status ~= "Wait" then
		if Door.Status == "Locked" then
			Door.Status = "Wait"
			for i, v in pairs(Door.Proximities) do
				v.Enabled = false
			end
			Door:Open(Door.Type,Proximity)
			if Door.AutoClose then
				DoorModule.AutoCloseDoor(Door,Proximity)
			end
			Door.Status = "Open"
		elseif Door.Status == "Open" then
			Door.Status = "Wait"
			for i, v in pairs(Door.Proximities) do
				v.Enabled = false
			end
			Door:Close(Door.Type,Proximity)
			Door.Status = "Locked"
			Door.MustClose = false
		end
		for i, v in pairs(Door.Proximities) do
			v.Enabled = true
			v.ObjectText = "Sector - "..Door.Sector.." | "..Door.Status
		end
	else
		Door.LastClient = Client
		Door:Invalid()
	end
end


function DoorModule.new(DoorModel,Permission,AutoClose)
	local Door = {}
	setmetatable(Door,DoorModule)
	
	Door.Model = DoorModel
	Door.Door = DoorModel:FindFirstChild("Door")
	Door.Permissions = Permission
	Door.Status = "Locked"
	Door.Sector = DoorModel.Name
	Door.LastClient = nil
	Door.AutoClose = AutoClose
	Door.MustClose = false
	Door.Proximities = {}
	
	if not Data[Door.Sector] then
		Data[Door.Sector] = {}
	end
	table.insert(Data[Door.Sector],Door)
	if Door.Door then
		if Door.Door:FindFirstChild("Right") then
			Door.Type = "Armoured"
		elseif Door.Door:FindFirstChild("Hinge") then
			Door.Type = "Hinge"
			Door:Swing()
		elseif Door.Door:FindFirstChild("Gate") then
			Door.Type = "Gate"
		end
	end
	
	for i, v in pairs(DoorModel:GetChildren()) do
		if v.Name == "Reader" and v:FindFirstChild("Union") then
			local Proximity = Instance.new("ProximityPrompt",v.Union)
			if Door.Type == "Hinge" then
				Proximity.ActionText = "Interact Handle"
			else
				Proximity.ActionText = "Push Button"
			end
			Proximity.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
			Proximity.HoldDuration = 0.5
			Proximity.MaxActivationDistance = 8
			Proximity.ObjectText = "Sector - "..Door.Sector.." | "..Door.Status
			Proximity.Triggered:Connect(function(Client)
				DoorModule.DoorConnection(Door,Proximity,Client)
			end)
			table.insert(Door.Proximities,Proximity)
		end
	end
end

function DoorModule:Swing()
	local function Weld(a,b)
		local W = Instance.new("Weld",b)
		W.Part0,W.Part1 = b,a
		W.C0 = a.CFrame:toObjectSpace(b.CFrame):inverse()
	end
	local Hinge = self.Door.Hinge
	local Anchored = self.Door.Frame.Hinge
	local M = Instance.new("Motor",Hinge)
	M.Part0 = Hinge
	M.Part1 = Anchored
	M.MaxVelocity = 0.05
	for i, v in pairs(self.Model:GetChildren()) do
		for ii, vv in pairs(v:GetChildren()) do
			if vv:IsA("BasePart") and vv ~= Hinge then
				Weld(vv,Hinge)
			end
		end
	end
	for i, v in pairs(self.Model:GetChildren()) do
		for ii, vv in pairs(v:GetChildren()) do
			if vv:IsA("BasePart") and vv ~= Hinge then
				vv.Anchored = false
			end
		end
	end
	Hinge.Anchored = false
	
	self.Motor = M
end

function DoorModule:Open(Type,Proximity)
	if not self.Door then return end
	if Type == "Armoured" then
		for i=0,30 do
			wait()
			self.Door.Right.CFrame = self.Door.Right.CFrame * CFrame.new(-(self.Door.Right.Size.X-0.4)/30,0,0)
			self.Door.Left.CFrame = self.Door.Left.CFrame * CFrame.new(-(self.Door.Left.Size.X-0.4)/30,0,0)
		end
	elseif Type == "Gate" then
		for i=0,200 do
			wait(0)
			self.Door.Gate.CFrame = self.Door.Gate.CFrame * CFrame.new(0,(self.Door.Gate.Size.Y-0.4)/200,0)
		end
	elseif Type == "Hinge" then
		self.Motor.DesiredAngle = math.rad(100) * Proximity.Parent.Parent.Value.Value
	end
end

function DoorModule:Close(Type,Proximity)
	if not self.Door then return end
	if Type == "Armoured" then
		for i=0,30 do
			wait()
			self.Door.Right.CFrame = self.Door.Right.CFrame * CFrame.new((self.Door.Right.Size.X-0.4)/30,0,0)
			self.Door.Left.CFrame = self.Door.Left.CFrame * CFrame.new((self.Door.Left.Size.X-0.4)/30,0,0)
		end
	elseif Type == "Gate" then
		for i=0,200 do
			wait(0)
			self.Door.Gate.CFrame = self.Door.Gate.CFrame * CFrame.new(0,-(self.Door.Gate.Size.Y-0.4)/200,0)
		end
	elseif Type == "Hinge" then
		self.Motor.DesiredAngle = 0
	end
end

function DoorModule:Invalid()
	
end


return DoorModule
