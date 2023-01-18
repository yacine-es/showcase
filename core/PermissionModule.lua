local PermissionModule = {
	TeamCheckerModule = require(script.Parent:WaitForChild("TeamCheckerModule")),
	Clients = {},
	Exempt = {},
	Raiders = true,
}

function PermissionModule.GetPermissionName(Name)
	if Name == "" or not Name then return nil end
	for i, v in pairs(PermissionModule.Divisions) do
		if table.find(v.Nickname,string.lower(Name)) then
			return v.Nickname[1]
		else
			for ii, vv in pairs(v.Subs) do
				if table.find(vv.Nickname,string.lower(Name)) then
					return vv.Nickname[1]
				end
			end
		end
	end
	return nil
end

function PermissionModule.GetAllPermission(Name)
	local AllPerms = {}
	for i, v in pairs(PermissionModule.Divisions) do
		local Main,Sub = false,false
		if table.find(v.Nickname,string.lower(Name)) then
			Main = true
			table.insert(AllPerms,v.Nickname[1])
		end
		for ii, vv in pairs(v.Subs) do
			if Main and not vv.Team[1] then
				table.insert(AllPerms,vv.Nickname[1])
			elseif table.find(vv.Nickname,string.lower(Name)) then
				Sub = true
				table.insert(AllPerms,vv.Nickname[1])
			end
		end
		if Sub then
			table.insert(AllPerms,v.Nickname[1])
		end
	end
	return AllPerms
end


function PermissionModule.FetchPermission(Client,Divisions)
	PermissionModule.Clients[Client] = {}
	if Divisions then
		PermissionModule.Divisions = Divisions
	elseif PermissionModule.Divisions then
		Divisions = PermissionModule.Divisions
	else return end
	for i, v in pairs(Divisions) do
		PermissionModule.Clients[Client][v.Nickname[1]] = -1
		local Rank = Client:GetRankInGroup(v.GroupId)
		for ii, vv in pairs(v.RankClearanceLevels) do
			if Rank >= vv then
				if ii > PermissionModule.Clients[Client][v.Nickname[1]] then
					PermissionModule.Clients[Client][v.Nickname[1]] = ii
				end
			end
		end
		for ii, vv in pairs(v.Subs) do
			PermissionModule.Clients[Client][v.Subs[ii].Nickname[1]] = -1
			if Client:IsInGroup(v.Subs[ii].GroupId) then
				PermissionModule.Clients[Client][v.Subs[ii].Nickname[1]] = 0
			end
		end
		if next(v.Exceptions) then
			for ii, vv in pairs(v.Exceptions) do
				if ii == Client.UserId then
					PermissionModule.Clients[Client][v.Nickname[1]] = vv
				end
			end	
		end
	end
end

function PermissionModule.GetRole(Client,Perm)
	if not PermissionModule.Clients[Client] then PermissionModule.FetchPermission(Client) end
	if PermissionModule.NameRoles then
		for i, v in pairs(PermissionModule.NameRoles) do
			if i == Client.UserId then
				return(v.Name)
			end
		end
	end
	if PermissionModule.Divisions then
		local NamePerm = PermissionModule.GetPermissionName(Perm)
		for i, v in pairs(PermissionModule.Divisions) do
			if v.Nickname[1] == NamePerm then
				return(Client:GetRoleInGroup(v.GroupId))
			end
			for ii, vv in pairs(v.Subs) do
				if vv.Nickname[1] == NamePerm then
					return(Client:GetRoleInGroup(vv.GroupId))
				end
			end
		end
	end
	return ""
end

function PermissionModule.CheckPemission(Client,Permission,Id,Sector)
	local Required = {}
	if not PermissionModule.Clients[Client] then PermissionModule.FetchPermission(Client) end
	if PermissionModule.Sectors[Sector] then Required = PermissionModule.Sectors[Sector] end
	if Permission then
		for i, v in pairs(Permission) do
			local id = PermissionModule.GetPermissionName(i)
			if Required[id] then
				if v > Required[id] then
					Required[id] = v
				end
			else
				Required[id] = v
			end
		end
	end
	local TeamPermission = PermissionModule.GetPermissionName(PermissionModule.TeamCheckerModule.GetTeam(Client))
	if TeamPermission then
		for i, v in pairs(PermissionModule.GetAllPermission(PermissionModule.GetPermissionName(PermissionModule.TeamCheckerModule.GetTeam(Client)))) do
			if PermissionModule.Clients[Client][v] and Required[v] then
				if PermissionModule.Clients[Client][v] >= Required[v] then
					return true
				end	
			end	
		end
	end
	return false
end

function PermissionModule.NotPersonnel(Client)
	if not PermissionModule.Clients[Client] then PermissionModule.FetchPermission(Client) end
	if PermissionModule.Clients[Client]["scpf"] >= 7 then
		return true
	end
	for i, v in pairs(PermissionModule.Divisions) do
		if Client:IsInGroup(v.GroupId) then
			return false
		end
		for ii, vv in pairs(v.Subs) do
			if Client:IsInGroup(vv.GroupId) then
				return false
			end
		end
	end
	return true
end

function PermissionModule.UpdateSectors(Sectors)
	for i, v in pairs(Sectors) do
		for ii, vv in pairs(v) do
			local id = PermissionModule.GetPermissionName(ii)
			Sectors[i][ii] = nil
			if Sectors[i][id] then
				if vv > Sectors[i][id] then
					Sectors[i][id] = vv
				end
			else
				Sectors[i][id] = vv
			end
		end
	end
	PermissionModule.Sectors = Sectors
end

function PermissionModule.Load(Sectors,Divisions,NameRoles)
	PermissionModule.Divisions = Divisions
	PermissionModule.NameRoles = NameRoles
	PermissionModule.UpdateSectors(Sectors)
end

return PermissionModule
