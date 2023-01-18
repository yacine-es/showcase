local Settings = {
	
	--Divisions--
	Division = {
		["Special Containment Procedure Foundation"] = {
			Nickname = {"scpf","foundation personnel","special containment procedure foundation"},
			GroupId = 11437668,
			RankClearanceLevels = {
				[0] = 0, --Everyone
				[1] = 23, --Class E
				[2] = 25, --Level 1
				[3] = 248, --Level 2
				[4] = 249, --Level 3
				[5] = 250, --Level 4
				[6] = 251, --Facility Director
				[7] = 253, --O5
				[8] = 255, --The Administrator
			},
			Team = {
				{Name = "Foundation Personnel",TeamColor = Color3.fromRGB(163, 162, 165),Permission = 2,Setup = 1},
			},
			Exceptions = {},
			Subs = {},
		},
		
		["Class D"] = {
			Nickname = {"cd","class d"},
			GroupId = 0,
			RankClearanceLevels = {
				[0] = -1, --Everyone
			},
			Team = {
				{Name = "Class D",TeamColor = Color3.fromRGB(197, 139, 31),Permission = 0,Setup = 4,Default = true},
			},
			Exceptions = {},
			Subs = {},
		},
		["Raiders"] = {
			Nickname = {"raider","raiders"},
			GroupId = 0,
			RankClearanceLevels = {
				[0] = -1, --Everyone
			},
			Team = {
				{Name = "Raiders",TeamColor = Color3.fromRGB(58, 0, 0),Permission = 0,Setup = 3},
			},
			Exceptions = {},
			Subs = {},
		},
		["Intelligence Agency"] = {
			Nickname = {"intel","intelligence","intelligence agency","redacted"},
			GroupId = 11444697,
			RankClearanceLevels = {
				[0] = 1, --Trial
				[1] = 5, --Low Rank
				[2] = 10, --Middle Rank
				[3] = 15, --High Rank
			},
			Team = {
				{Name = "REDACTED",TeamColor = Color3.fromRGB(0, 0, 0),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {},
		},
		["Internal Affairs"] = { 
			Nickname = {"ia","internal affairs"},
			GroupId = 14560556,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Internal Affairs",TeamColor = "Class D",Permission = 0,Setup = 2},
			},
			Exceptions = {
				[91230318] = 3, -- AceGotThis
				[3494625994] = 2, -- BigLovableBear
				[205478632] = 0, -- MichaelCole83
			},
			Subs = {},
		},
		["Department of External Affairs"] = { 
			Nickname = {"ea","dea","doea","external affairs","department of external affairs"},
			GroupId = 14683211,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "External Affairs",TeamColor = Color3.fromRGB(75, 182, 123),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {},
		},
		["Ethics Committee"] = { 
			Nickname = {"ec","ethics","ethics committee"},
			GroupId = 11444680,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Ethics Committee",TeamColor = Color3.fromRGB(46, 151, 72),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {},
		},
		["Medical Department"] = {
			Nickname = {"md","medic","medical","medical department"},
			GroupId = 14565090,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Medical",TeamColor = Color3.fromRGB(52, 152, 219),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {},
		},
		["Research Department"] = { 
			Nickname = {"rd","research","scientific","scientist","research department"},
			GroupId = 11444418,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Research",TeamColor = Color3.fromRGB(245, 255, 252),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {},
		},
		["Administrative Department"] = { 
			Nickname = {"ad","admin","administrative","administration","administrative department"},
			GroupId = 14564994,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Administration",TeamColor = Color3.fromRGB(231, 76, 60),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {
				["Manufacturing Department"] = {
					Nickname = {"mad","manufacturing","developers","manufacturing department"},
					GroupId = 14597125,
					Team = {
						{Name = "Manufactering Department",TeamColor = "Administration",Permission = 0,Setup = 2},
					},
				},
				["Office of the Administrator"] = {
					Nickname = {"oota","office","office of the administrator"},
					GroupId = 14597125,
					Team = {
						{Name = "Office of the Administrator",TeamColor = "Administration",Permission = 0,Setup = 2},
					},
				},
			},
		},
		["Mobile Task Force"] = { 
			Nickname = {"mtf","mobile task force"},
			GroupId = 11444440,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Mobile Task Force",TeamColor = Color3.fromRGB(32, 102, 148),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {
				["MTF Alpha-1"] = {
					Nickname = {"a1","alpha-1","alpha","mtf alpha-1"},
					GroupId = 11450526,
					Team = {
						{Name = "Alpha-1",TeamColor = "Mobile Task Force",Permission = 0,Setup = 2},
					},
				},
				["MTF Sparta-9"] = {
					Nickname = {"s9","sparta-9","sparta","mtf sparta-9"},
					GroupId = 14644737,
					Team = {
						{Name = "Sparta-9",TeamColor = "Mobile Task Force",Permission = 0,Setup = 2},
					},
				},
				["MTF NYX-7"] = {
					Nickname = {"n7","nyx-7","nyx","mtf nyx-7"},
					GroupId = 14645301,
					Team = {
						{Name = "Nyx-7",TeamColor = "Mobile Task Force",Permission = 0,Setup = 2},
					},
				},
			},
		},
		["Security Department"] = { 
			Nickname = {"sd","security","security department"},
			GroupId = 11444393,
			RankClearanceLevels = {
				[0] = 1,
				[1] = 5,
				[2] = 10,
				[3] = 15,
			},
			Team = {
				{Name = "Security",TeamColor = Color3.fromRGB(190, 183, 183),Permission = 0,Setup = 1},
			},
			Exceptions = {},
			Subs = {
				["Specialized Control Unit"] = {
					Nickname = {"scu","control unit","specialized control unit"},
					GroupId = 14707667,
					Team = {
						{Name = "Specialized Control Unit",TeamColor = "Security",Permission = 0,Setup = 2},
					},
				},
			},
		},
	},
	
	--Sectors Default Permission--
	Sectors = {
		Gate = {
			["scpf"] = 3,
			["mtf"] = 0,
			["n7"] = -1,
			["ia"] = 0,
			["intel"] = 0,
			["sd"] = 0,
		},
		Redacted = {
			["scpf"] = 0,
			["intel"] = 0,
			["ia"] = 0,
			["sd"] = 0,
		},
		
	},
	
	--Protocol Permission---
	AutomatedResponse = {
		AR1 = {
			Sectors = {
				
			},
			Alarm = true,
			Light = true,
			Doors = false,
			LethalGaz = false,
			Raiders = false,
			Description = "",
		},
		
	},
	
	--Loadout--
	Loadout = {
		Weapon = {
			
		},
		Card = {
			Level0 = {
				["scpf"] = 0,
			},
			Level1 = {
				["scpf"] = 2,
			},
			Level2 = {
				["scpf"] = 3,
			},
			Level3 = {
				["scpf"] = 3,
			},
			Level4 = {
				["scpf"] = 5,
			},
			Level5 = {
				["scpf"] = 6,
			},
			LevelOmni = {
				["scpf"] = 7,
			},
			LevelD = {
				["scpf"] = 0,
			},
			LevelRedacted = {
				["intel"] = 0,
			},
		},
		Others = {
			
		},
	},
	
	--Virus--
	Virus = { --(VIRUS CODE)-(INFECTION RATE 2 FIRST DIGITS)(A-F HIGH-LOW INFECTION SPREADING)-(1-9 HIGH-LOW PROTOCOL SEVERITY)
		[1] = {
			Rate = 100,
			Name = "FH-04A-9", -- Fisherman's Hands - 04 (40 -> 040 -> 04) - A (HIGH INFECTION SPREADING) - 9 (LOW PROTOCOL SEVERITY)
		},
	},
	
	--Sounds--
	SoundGroups = {
		["Virus"] = {
			Volume = 0.5,
			Max = 30,
			Min = 10,
			Sounds = {
				["Coughing"] = 9493432251,
				["Heartbeat"] = 9493967440,
			},
		},
		["Others"] = {
			["rr"] = {Id = 9483161408, Volume = 1, Max = 0, Min = 0},
			["rrrr"] = {Id = 9483125209, Volume = 1, Max = 0, Min = 0},
		},
	},
	
	Animations = {
		["Cought"] = "",
	},
	
	--Badges--
	Badges = {
		["Welcome"] = {Id = 0},
	},
	
	--Gamepasses--
	Gamepasses = {
		["Gun"] = {Id = 0},
	},
	
	--NameRoles--
	NameRoles = {
		[507468108] = {Name = "He Who Waits", Number = "O5-2"},
		[9668645] = {Name = "The Hermit", Number = "O5-3"},
		[1780527126] = {Name = "The Veteran", Number = "O5-4"},
		[91230318] = {Name = "The Black Cat", Number = "O5-5"},
		[390171803] = {Name = "The Administrator", Number = "The Administrator"},
	},
	
	--Server--
	Server = {
		ServerMode = "Public",
	},
	
}

if game.PrivateServerOwnerId ~= 0 and game.PrivateServerId ~= "" then
	Settings.Server.ServerMode = "Private"
	Settings.Server.OwnerId = game.PrivateServerOwnerId
	Settings.Server.ServerId = game.PrivateServerId
elseif game.PrivateServerId ~= "" then
	Settings.Server.ServerMode = "Reserved"
	Settings.Server.ServerId = game.PrivateServerId
end

--local Core = require(9470301279)
local Core = require(script:WaitForChild("MainModule"))
Core.Load(Settings)

script:Destroy()