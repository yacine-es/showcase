local NameModule = {
	PermissionModule = require(script.Parent:WaitForChild("PermissionModule")),
	TeamCheckerModule = require(script.Parent:WaitForChild("TeamCheckerModule")),
}
local Data = {}
local PermissionModule = require(script.Parent:WaitForChild("PermissionModule"))
NameModule.__index = NameModule

function NameModule.new(Client,Username)
	local Nametag = {}
	setmetatable(Nametag,NameModule)
	
	Nametag.Client = Client
	Nametag.Humanoid = Client.Character:WaitForChild("Humanoid")
	Nametag.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	Nametag.Humanoid.NameDisplayDistance = 0
	Nametag.GUI = Instance.new("BillboardGui",Client.Character:WaitForChild("Head"))
	Nametag.GUI.Size = UDim2.new(4,0,1,0)
	Nametag.GUI.StudsOffset = Vector3.new(0,1.5,0)
	Nametag.Top = Instance.new("TextLabel",Nametag.GUI)
	Nametag.Top.Size = UDim2.new(1,0,0.6,0)
	Nametag.Top.BackgroundTransparency = 1
	Nametag.Top.Font = Enum.Font.SourceSans
	Nametag.Top.TextScaled = true
	Nametag.Bottom = Instance.new("TextLabel",Nametag.GUI)
	Nametag.Bottom.Size = UDim2.new(1,0,0.4,0)
	Nametag.Bottom.Position = UDim2.new(0,0,0.6,0)
	Nametag.Bottom.BackgroundTransparency = 1
	Nametag.Bottom.Font = Enum.Font.SourceSansLight
	Nametag.Bottom.TextScaled = true
	
	Nametag:Update(Client.Name,PermissionModule.GetRole(Client,NameModule.TeamCheckerModule.GetTeam(Client)))
	return Nametag
end

function NameModule:Destroy()
	self.GUI:Destroy()
	self = nil
	return nil
end

function NameModule:Redact()
	self.Top.Text = ""
	self.Bottom.Text = ""
	self.GUI.Enabled = false
end

function NameModule:Update(Top,Bottom,Permission)
	self.Top.Text = Top
	self.Bottom.Text = Bottom
	self.Top.TextColor3 = self.Client.TeamColor.Color
	self.Bottom.TextColor3 = self.Client.TeamColor.Color
	self.GUI.Enabled = true
end

function NameModule.Load(Divisions)
	Data.Divisions = Divisions
end



return NameModule
