local BadgeModule = {
	BadgeService = game:GetService("BadgeService"),
	Badges = {},
}

function BadgeModule.Award(Client,Id)
	if BadgeModule.Badges[Id] then
		if BadgeModule.Badges[Id].Enabled == nil then
			local SuccessToo, BadgeAvailable = pcall(function()
				BadgeModule.Badges[Id].Enabled = BadgeModule.BadgeService:GetBadgeInfoAsync(BadgeModule.Badges[Id].Id).IsEnabled
			end)
		end
		local Success, BadgeStatus = pcall(function()
			return BadgeModule.BadgeService:UserHasBadgeAsync(Client.UserId,BadgeModule.Badges[Id].Id)
		end)
		if Success and BadgeStatus and BadgeModule.Badges[Id].Enabled then
			BadgeModule.BadgeService:AwardBadge(Client.UserId,BadgeModule.Badges[Id].Id)
		end
	end
end

function BadgeModule.Load(Badges)
	BadgeModule.Badges = Badges
end

return BadgeModule