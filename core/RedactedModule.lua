local RedactedModule = {}
local PermissionModule = require(script.Parent:WaitForChild("PermissionModule"))
local CollectionService = game:GetService("CollectionService")
local RedactScript = script:WaitForChild("RedactScript")
RedactScript.Parent = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
RedactScript.Disabled = false
RedactedModule.__index = RedactedModule

function RedactedModule.new(Client,Username)
--	if PermissionModule.CheckPemission(Client,{["intel"]=0,["ia"]=0},"RedactedModule") then
	if true then
		local Redacted = {}
		setmetatable(Redacted,RedactedModule)
		
		Redacted.GUI = Instance.new("BillboardGui",Client.Character.Head)
		Redacted.GUI.Size = UDim2.new(2,0,2,0)
		Redacted.GUI.AlwaysOnTop = true
		Redacted.GUI.PlayerToHideFrom = Client
		Redacted.Transparency = Client.Character.Head.Transparency
		Redacted.Client = Client
		Client.Character.Head.Transparency = 1
		Redacted.Frames = {
			[1] = Instance.new("Frame",Redacted.GUI),
		}
		Redacted.Frames[2] = Instance.new("Frame",Redacted.Frames[1])
		Redacted.Frames[2].ZIndex = 2
		Redacted.X = {
			[1] = Instance.new("Frame",Redacted.GUI),
			[2] = Instance.new("Frame",Redacted.GUI)
		}
		for i, v in pairs(Redacted.Frames) do
			v.BackgroundColor = BrickColor.new("Black")
			v.BorderColor3 = Color3.fromRGB(255, 255, 255)
			v.BorderSizePixel = 2
			v.AnchorPoint = Vector2.new(0.5,0.5)
			v.Position = UDim2.new(0.5,0,0.5,0)
		end
		for i, v in pairs(Redacted.X) do
			v.Name = "Icon"
			v.BackgroundTransparency = 1
			v.Size = UDim2.new(0.2,0,0.2,0)
			local X1 = Instance.new("Frame",v)
			local X2 = Instance.new("Frame",v)
			X1.AnchorPoint = Vector2.new(0.5,0.5)
			X1.Position = UDim2.new(0.5,0,0.5,0)
			X1.Size = UDim2.new(0.1,0,1,0)
			X1.Rotation = 45
			X1.ZIndex = 3 
			X2.AnchorPoint = Vector2.new(0.5,0.5)
			X2.Position = UDim2.new(0.5,0,0.5,0)
			X2.Size = UDim2.new(0.1,0,1,0)
			X2.Rotation = -45
			X2.ZIndex = 3
		end
		CollectionService:AddTag(Redacted.GUI,"RedactedModule")
		return Redacted
	end
end

function RedactedModule:Destroy()
	CollectionService:RemoveTag(self.GUI,"RedactedModule")
	self.GUI:Destroy()
	self.Client.Character.Head.Transparency = self.Transparency
	self = nil
	return nil
end

return RedactedModule
