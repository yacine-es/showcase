local TeamModule = {
	TeamService = game:GetService("Teams"),
	PermissionModule = require(script.Parent:WaitForChild("PermissionModule")),
	TeamCheckerModule = require(script.Parent:WaitForChild("TeamCheckerModule")),
	Teams = {}
}
TeamModule.__index = TeamModule

function TeamModule.new(Name,Color,Permission,Setup,Default)
	local Team = {}
	setmetatable(Team,TeamModule)
	
	Team.Setup = Setup
	if Setup == 1 or Setup == 3 or Setup == 4 then
		Team.T = Instance.new("Team",TeamModule.TeamService)
		Team.T.Name = Name
		Team.T.TeamColor = BrickColor.new(Color)
		Team.T.AutoAssignable = Default
		Team.Permission = Permission
		Team.Nickname = TeamModule.PermissionModule.GetPermissionName(Name)
		Team.Activated = {}
		if Team.Nickname then
			local Module = script:FindFirstChild(Team.Nickname)
			if Module then
				Team.Module = require(Module)	
			end
		end
	elseif Setup == 2 then
		Team.T = TeamModule.TeamService:FindFirstChild(Color)
		Team.Permission = Permission
		Team.Nickname = TeamModule.PermissionModule.GetPermissionName(Name)
		Team.Activated = {}
		if Team.Nickname then
			local Module = script:FindFirstChild(Team.Nickname)
			if Module then
				Team.Module = require(Module)	
			end
		end
	end
	TeamModule.Teams[Name] = Team
	return Team
end

function TeamModule:AddMember(Client)
	if not (TeamModule.TeamCheckerModule.GetTeam(Client) == self.Nickname) then
		TeamModule.TeamCheckerModule.Change(Client,self.Nickname)
		Client.Team = self.T
		if self.Module then
			self.Activated[Client] = self.Module.new(Client)	
		end	
	end
end

function TeamModule:RemoveMember(Client)
	if not (TeamModule.TeamCheckerModule.GetTeam(Client) == self.Nickname) then
		TeamModule.TeamCheckerModule.Change(Client,nil)
		if self.Activated[Client] then
			self.Activated[Client] = self.Activated[Client]:Destroy()
		end
	end
end

function TeamModule:Allowed(Client)
	if self.Setup == 1 or self.Setup == 2 then
		if not TeamModule.PermissionModule.Clients[Client] then TeamModule.PermissionModule.FetchPermission(Client) end
		for i, v in pairs(TeamModule.PermissionModule.GetAllPermission(TeamModule.PermissionModule.GetPermissionName(self.Nickname))) do
			if TeamModule.PermissionModule.Clients[Client][v] then
				if TeamModule.PermissionModule.Clients[Client][v] >= self.Permission then
					return true
				end	
			end	
		end
	elseif self.Setup == 3 and TeamModule.PermissionModule.Raiders and TeamModule.PermissionModule.NotPersonnel(Client) then
		return true
	elseif self.Setup == 4 and TeamModule.PermissionModule.NotPersonnel(Client) then
		return true
	else
		return false
	end
end


function TeamModule:List()
	local Members = {}
	for i, v in pairs(TeamModule.TeamCheckerModule.Clients) do
		if v == self.Nickname then
			table.insert(Members,i)
		end
	end
	return Members
end

return TeamModule
