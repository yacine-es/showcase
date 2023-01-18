local MarkerModule = {
	Players = game:GetService("Players")
}

function MarkerModule.Assign(Client,MarkerName,Marker)
	if not Marker then
		Marker = workspace:WaitForChild("Markers"):FindFirstChild(MarkerName)
	end
	if Marker and Client.Character then
		Client.RespawnLocation = Marker
	end	
end

return MarkerModule