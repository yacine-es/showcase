local TeamCheckerModule = {
	Client = {},
	TeamsService = game:GetService("Teams")
}


function TeamCheckerModule.Change(Client,Team)
	TeamCheckerModule.Client[Client] = Team
end


function TeamCheckerModule.GetTeam(Client)
	return TeamCheckerModule.Client[Client]
end


return TeamCheckerModule
