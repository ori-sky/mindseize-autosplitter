state("MindSeize", "1.1.6") {}
state("MindSeize"< "1.1.7") {}

startup {
	vars.target = new SigScanTarget(0, "37 13 37 13 37 13 37 13 00 00 00 00 00 00 00 00");

	settings.Add("Abilities",          true,  "All Abilities");
	settings.Add("DashAbility",        true,  "Dash",             "Abilities");
	settings.Add("WallJumpAbility",    true,  "Wall Jump",        "Abilities");
	settings.Add("ShadowAbility",      true,  "Shadow Dash",      "Abilities");
	settings.Add("HackingAbility",     true,  "Hacking Device",   "Abilities");
	settings.Add("AirDashAbility",     true,  "Air Dash",         "Abilities");
	settings.Add("GrenadeAbility",     true,  "Grenade Launcher", "Abilities");
	settings.Add("EMPAbility",         true,  "Power Void",       "Abilities");
	settings.Add("FlamerAbility",      true,  "Flamer",           "Abilities");
	settings.Add("VisorAbility",       false, "Special Visor",    "Abilities");
	settings.Add("ArmorAbility",       false, "U1M4 Armor",       "Abilities");
	settings.Add("GreenFlamerAbility", false, "Green Flamer",     "Abilities");

	settings.Add("Bosses",          true,  "All Bosses");
	settings.Add("HiveBoss",        true,  "Hornet Hive",                "Bosses");
	settings.Add("TreantBoss",      false, "Thorn Horn",                 "Bosses");
	settings.Add("StrangerBoss",    false, "Stranger",                   "Bosses");
	settings.Add("HanuBoss",        false, "Drifter Hanu",               "Bosses");
	settings.Add("DroneBoss",       false, "Illuminator Drone",          "Bosses");
	settings.Add("AnnihilatorBoss", false, "Annihilator Unit",           "Bosses");
	settings.Add("DukeBoss",        false, "Duke Atlas",                 "Bosses");
	settings.Add("ThyrBoss",        false, "Thyr, Sworn Blade",          "Bosses");
	settings.Add("DuoBoss",         false, "Valstrike & Sanray",         "Bosses");
	settings.Add("HabaBoss",        false, "Heavy Assault Battle Armor", "Bosses");
	settings.Add("PhantomBoss",     true,  "Phantom Parasite",           "Bosses");
	settings.Add("AssassinBoss",    true,  "Assassin",                   "Bosses");
	settings.Add("MimirBoss",       true,  "Mimir, Central Mind",        "Bosses");
	settings.Add("ValkyrieBoss",    true,  "Valkyrie Grace",             "Bosses");
	settings.Add("SeaMonsterBoss",  false, "Abyssal Monster",            "Bosses");
	settings.Add("ShivaBoss",       true,  "Shiva Pride",                "Bosses");

	settings.Add("MeleeWeapons", true,  "All Melee Weapons");
	settings.Add("CutterWeapon", false, "Quad Cutters", "MeleeWeapons");
	settings.Add("MorphWeapon",  true,  "Morph Edge",   "MeleeWeapons");
	settings.Add("SpearWeapon",  false, "Jet Spear",    "MeleeWeapons");

	settings.Add("RangedWeapons", true,  "All Ranged Weapons");
	settings.Add("PlasmaWeapon",  true,  "Plasma Avenger",  "RangedWeapons");
	settings.Add("ZapperWeapon",  false, "Arc-Power Beam",  "RangedWeapons");
	settings.Add("BazookaWeapon", false, "Rocket Launcher", "RangedWeapons");

	settings.Add("Powerups",          false, "All Powerups");
	settings.Add("HealthPowerups",    false, "Health",    "Powerups");
	settings.Add("NanobotPowerups",   false, "Nanobot",   "Powerups");
	settings.Add("NanoplantPowerups", false, "Nanoplant", "Powerups");

	settings.Add("MimirGate", true,  "Mimir Gate Open");
}

init {
	print("Scanning for pointers");

	IntPtr ptr = IntPtr.Zero;

	foreach(var page in game.MemoryPages()) {
		var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);

		if(ptr == IntPtr.Zero) {
			ptr = scanner.Scan(vars.target, 8);
		}

		if(ptr != IntPtr.Zero) {
			break;
		}
	}

	if(ptr == IntPtr.Zero) {
		throw new Exception("Failed to scan for pointers");
	}

	print("ptr = " + ptr.ToString("X4"));
	print("Scanned all pointers");

	vars.watchers = new MemoryWatcherList {
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x1a)) { Name = "DashAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x1b)) { Name = "WallJumpAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x1c)) { Name = "ShadowAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x1d)) { Name = "HackingAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x1e)) { Name = "AirDashAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x1f)) { Name = "GrenadeAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x20)) { Name = "EMPAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x21)) { Name = "FlamerAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x22)) { Name = "VisorAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x23)) { Name = "ArmorAbility" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x24)) { Name = "GreenFlamerAbility" },

		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x2c)) { Name = "HiveBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x2d)) { Name = "TreantBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x2e)) { Name = "StrangerBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x2f)) { Name = "HanuBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x30)) { Name = "DroneBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x31)) { Name = "AnnihilatorBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x32)) { Name = "DukeBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x33)) { Name = "ThyrBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x34)) { Name = "DuoBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x35)) { Name = "HabaBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x36)) { Name = "PhantomBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x37)) { Name = "AssassinBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x38)) { Name = "MimirBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x39)) { Name = "ValkyrieBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x3a)) { Name = "SeaMonsterBoss" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x3b)) { Name = "ShivaBoss" },

		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x14)) { Name = "CutterWeapon" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x15)) { Name = "MorphWeapon" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x16)) { Name = "SpearWeapon" },

		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x17)) { Name = "PlasmaWeapon" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x18)) { Name = "ZapperWeapon" },
		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x19)) { Name = "BazookaWeapon" },

		new MemoryWatcher<int >(IntPtr.Add(ptr, 0x08)) { Name = "HealthPowerups" },
		new MemoryWatcher<int >(IntPtr.Add(ptr, 0x0c)) { Name = "NanobotPowerups" },
		new MemoryWatcher<int >(IntPtr.Add(ptr, 0x10)) { Name = "NanoplantPowerups" },

		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x3d)) { Name = "MimirGate" },

		new MemoryWatcher<byte>(IntPtr.Add(ptr, 0x3c)) { Name = "InGame" }
	};
}

update {
	vars.watchers.UpdateAll(game);
}

start {
	bool InGame = vars.watchers["InGame"].Changed && vars.watchers["InGame"].Current == 1;
	return InGame;
}

split {
	if(settings["DashAbility"       ] && vars.watchers["DashAbility"       ].Changed && vars.watchers["DashAbility"       ].Current == 1) { return true; }
	if(settings["WallJumpAbility"   ] && vars.watchers["WallJumpAbility"   ].Changed && vars.watchers["WallJumpAbility"   ].Current == 1) { return true; }
	if(settings["ShadowAbility"     ] && vars.watchers["ShadowAbility"     ].Changed && vars.watchers["ShadowAbility"     ].Current == 1) { return true; }
	if(settings["HackingAbility"    ] && vars.watchers["HackingAbility"    ].Changed && vars.watchers["HackingAbility"    ].Current == 1) { return true; }
	if(settings["AirDashAbility"    ] && vars.watchers["AirDashAbility"    ].Changed && vars.watchers["AirDashAbility"    ].Current == 1) { return true; }
	if(settings["GrenadeAbility"    ] && vars.watchers["GrenadeAbility"    ].Changed && vars.watchers["GrenadeAbility"    ].Current == 1) { return true; }
	if(settings["EMPAbility"        ] && vars.watchers["EMPAbility"        ].Changed && vars.watchers["EMPAbility"        ].Current == 1) { return true; }
	if(settings["FlamerAbility"     ] && vars.watchers["FlamerAbility"     ].Changed && vars.watchers["FlamerAbility"     ].Current == 1) { return true; }
	if(settings["VisorAbility"      ] && vars.watchers["VisorAbility"      ].Changed && vars.watchers["VisorAbility"      ].Current == 1) { return true; }
	if(settings["ArmorAbility"      ] && vars.watchers["ArmorAbility"      ].Changed && vars.watchers["ArmorAbility"      ].Current == 1) { return true; }
	if(settings["GreenFlamerAbility"] && vars.watchers["GreenFlamerAbility"].Changed && vars.watchers["GreenFlamerAbility"].Current == 1) { return true; }

	if(settings["HiveBoss"       ] && vars.watchers["HiveBoss"       ].Changed && vars.watchers["HiveBoss"       ].Current == 1) { return true; }
	if(settings["TreantBoss"     ] && vars.watchers["TreantBoss"     ].Changed && vars.watchers["TreantBoss"     ].Current == 1) { return true; }
	if(settings["StrangerBoss"   ] && vars.watchers["StrangerBoss"   ].Changed && vars.watchers["StrangerBoss"   ].Current == 1) { return true; }
	if(settings["HanuBoss"       ] && vars.watchers["HanuBoss"       ].Changed && vars.watchers["HanuBoss"       ].Current == 1) { return true; }
	if(settings["DroneBoss"      ] && vars.watchers["DroneBoss"      ].Changed && vars.watchers["DroneBoss"      ].Current == 1) { return true; }
	if(settings["AnnihilatorBoss"] && vars.watchers["AnnihilatorBoss"].Changed && vars.watchers["AnnihilatorBoss"].Current == 1) { return true; }
	if(settings["DukeBoss"       ] && vars.watchers["DukeBoss"       ].Changed && vars.watchers["DukeBoss"       ].Current == 1) { return true; }
	if(settings["ThyrBoss"       ] && vars.watchers["ThyrBoss"       ].Changed && vars.watchers["ThyrBoss"       ].Current == 1) { return true; }
	if(settings["DuoBoss"        ] && vars.watchers["DuoBoss"        ].Changed && vars.watchers["DuoBoss"        ].Current == 1) { return true; }
	if(settings["HabaBoss"       ] && vars.watchers["HabaBoss"       ].Changed && vars.watchers["HabaBoss"       ].Current == 1) { return true; }
	if(settings["PhantomBoss"    ] && vars.watchers["PhantomBoss"    ].Changed && vars.watchers["PhantomBoss"    ].Current == 1) { return true; }
	if(settings["AssassinBoss"   ] && vars.watchers["AssassinBoss"   ].Changed && vars.watchers["AssassinBoss"   ].Current == 1) { return true; }
	if(settings["MimirBoss"      ] && vars.watchers["MimirBoss"      ].Changed && vars.watchers["MimirBoss"      ].Current == 1) { return true; }
	if(settings["ValkyrieBoss"   ] && vars.watchers["ValkyrieBoss"   ].Changed && vars.watchers["ValkyrieBoss"   ].Current == 1) { return true; }
	if(settings["SeaMonsterBoss" ] && vars.watchers["SeaMonsterBoss" ].Changed && vars.watchers["SeaMonsterBoss" ].Current == 1) { return true; }
	if(settings["ShivaBoss"      ] && vars.watchers["ShivaBoss"      ].Changed && vars.watchers["ShivaBoss"      ].Current == 1) { return true; }

	if(settings["CutterWeapon"] && vars.watchers["CutterWeapon"].Changed && vars.watchers["CutterWeapon"].Current == 1) { return true; }
	if(settings["MorphWeapon" ] && vars.watchers["MorphWeapon" ].Changed && vars.watchers["MorphWeapon" ].Current == 1) { return true; }
	if(settings["SpearWeapon" ] && vars.watchers["SpearWeapon" ].Changed && vars.watchers["SpearWeapon" ].Current == 1) { return true; }

	if(settings["PlasmaWeapon" ] && vars.watchers["PlasmaWeapon" ].Changed && vars.watchers["PlasmaWeapon" ].Current == 1) { return true; }
	if(settings["ZapperWeapon" ] && vars.watchers["ZapperWeapon" ].Changed && vars.watchers["ZapperWeapon" ].Current == 1) { return true; }
	if(settings["BazookaWeapon"] && vars.watchers["BazookaWeapon"].Changed && vars.watchers["BazookaWeapon"].Current == 1) { return true; }

	if(settings["HealthPowerups"   ] && vars.watchers["HealthPowerups"   ].Changed && vars.watchers["HealthPowerups"   ].Current == vars.watchers["HealthPowerups"   ].Old + 1) { return true; }
	if(settings["NanobotPowerups"  ] && vars.watchers["NanobotPowerups"  ].Changed && vars.watchers["NanobotPowerups"  ].Current == vars.watchers["NanobotPowerups"  ].Old + 1) { return true; }
	if(settings["NanoplantPowerups"] && vars.watchers["NanoplantPowerups"].Changed && vars.watchers["NanoplantPowerups"].Current == vars.watchers["NanoplantPowerups"].Old + 1) { return true; }

	if(settings["MimirGate"] && vars.watchers["MimirGate"].Changed && vars.watchers["MimirGate"].Current == 1) { return true; }

	return false;
}
