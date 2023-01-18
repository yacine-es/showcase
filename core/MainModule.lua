local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local ServerScriptService = game:GetService("ServerScriptService")

local CoreModule = {
	LocalModules = script:WaitForChild("LocalModules"),
	BadgeModule = require(script:WaitForChild("BadgeModule")),
	DoorModule = require(script:WaitForChild("DoorModule")),
	HttpModule = require(script:WaitForChild("HttpModule")),
	MarketModule = require(script:WaitForChild("MarketModule")),
	MarkerModule = require(script:WaitForChild("MarkerModule")),
	NameModule = require(script:WaitForChild("NameModule")),
	PermissionModule = require(script:WaitForChild("PermissionModule")),
	RedactedModule = require(script:WaitForChild("RedactedModule")),
	SoundModule = require(script:WaitForChild("SoundModule")),
	TeamCheckerModule = require(script:WaitForChild("TeamCheckerModule")),
	TeamModule = require(script:WaitForChild("TeamModule")),
	VirusModule = require(script:WaitForChild("VirusModule")),
	PlayerData = {},
	TeamData = {},
	SoundDate = {},
	Loaded = false
}

script.Parent = ServerScriptService
CoreModule.Event = Instance.new("RemoteEvent",ReplicatedStorage)
CoreModule.Event.Name = "CoreEvent"
CoreModule.LocalModules.Parent = StarterPlayerScripts
CoreModule.LocalModules.Disabled = false

Players.PlayerAdded:Connect(function(Client)
	if not CoreModule.Loaded then repeat wait() until CoreModule.Loaded end
	local LocalSettings = {
		SoundGroups = CoreModule.Settings.SoundGroups,
		Animations = CoreModule.Settings.Animations
	}
	CoreModule.Event:FireClient(Client,"Load",LocalSettings)
	CoreModule.PermissionModule.FetchPermission(Client)
	CoreModule.PlayerData[Client] = {}
	CoreModule.PlayerData[Client]["VirusModule"] = CoreModule.VirusModule.new(Client)
	
	Client.CharacterAdded:Connect(function(Character)
		CoreModule.PlayerData[Client]["NameModule"] = CoreModule.NameModule.new(Client)
		CoreModule.PlayerData[Client]["RedactedModule"] = CoreModule.RedactedModule.new(Client)
		CoreModule.PlayerData[Client]["VirusModule"]:LoadVirus()
		CoreModule.Event:FireClient(Client,"CameraModule","new")
		--if CoreModule.TeamData["REDACTED"]:Allowed(Client) then
			CoreModule.TeamData["REDACTED"]:AddMember(Client)
			CoreModule.PlayerData[Client]["NameModule"]:Update(Client.Name,CoreModule.PermissionModule.GetRole(Client,CoreModule.TeamCheckerModule.GetTeam(Client)))
		--end
		--CoreModule.Event:FireClient(Client,"CameraModule","shake",5)
		--CoreModule.Event:FireClient(Client,"SoundModule","new","Coughing",Character.Head,true)
	end)
	Client.CharacterRemoving:Connect(function(Character)
		if CoreModule.PlayerData[Client]["NameModule"] then CoreModule.PlayerData[Client]["NameModule"]:Destroy() end
		if CoreModule.PlayerData[Client]["RedactedModule"] then CoreModule.PlayerData[Client]["RedactedModule"]:Destroy() end
		CoreModule.Event:FireClient(Client,"CameraModule","destroy")
	end)
	
	if Client.Character then
		Client:LoadCharacter()
	end
end)

Players.PlayerRemoving:Connect(function(Client)
	Client.CharacterRemoving:Connect(function(Character)
		for i, v in pairs(CoreModule.PlayerData[Client]) do
			CoreModule.PlayerData[Client][i]:Destroy()
		end
		local currentteam = CoreModule.TeamCheckerModule.GetTeam(Client)
		if currentteam then
			CoreModule.TeamData[currentteam]:RemoveMember(Client)
		end
		CoreModule.Event:FireClient(Client,"CameraModule","destroy")
	end)
end)

CoreModule.Event.OnServerEvent:Connect(function(Client, Module)
	print(Client,Module)
end)

function CoreModule.CreateTeams(Divisions)
	for i, v in pairs(Divisions) do
		for ii, vv in pairs(v.Team) do
			CoreModule.TeamData[vv.Name] = CoreModule.TeamModule.new(vv.Name,vv.TeamColor,vv.Permission,vv.Setup,vv.Default)
		end
		if next(v.Subs) then
			for ii, vv in pairs(v.Subs) do
				for iii, vvv in pairs(vv.Team) do
					CoreModule.TeamData[vvv.Name] = CoreModule.TeamModule.new(vvv.Name,vvv.TeamColor,vvv.Permission,vvv.Setup,vvv.Default)
				end
			end	
		end
	end
end

function CoreModule.Load(Settings)
	
	-- Prepare Data --
	CoreModule.Settings = Settings
	
	-- Load Module --
	CoreModule.PermissionModule.Load(Settings.Sectors,Settings.Division,Settings.NameRoles)
	CoreModule.CreateTeams(Settings.Division)
	CoreModule.BadgeModule.Load(Settings.Badges)
	CoreModule.HttpModule.Load()
	CoreModule.NameModule.Load(Settings.Division)
	CoreModule.VirusModule.Load(Settings.Virus,CoreModule.Event)
	CoreModule.SoundModule.Load(Settings.SoundGroups)
	
	-- Load Action -- 
	CoreModule.Spawns = workspace:FindFirstChild("Spawns")
	
	CoreModule.Loaded = true
end

return CoreModule
