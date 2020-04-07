state("MindSeize") {}

startup {
	vars.targetStartPress = new SigScanTarget(31, "55 48 8B EC 48 83 EC 30 48 B8 ?? ?? ?? ?? ?? ?? ?? ?? 0F B6 00 85 C0 0F 85 ?? ?? ?? ?? 48 B8 ?? ?? ?? ?? ?? ?? ?? ?? C6 00 01");
}

init {
	print("Scanning for pointers");

	IntPtr ptrStartPress = IntPtr.Zero;

	foreach(var page in game.MemoryPages()) {
		var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);

		if(ptrStartPress == IntPtr.Zero) {
			ptrStartPress = scanner.Scan(vars.targetStartPress);
		}

		if(ptrStartPress != IntPtr.Zero) {
			break;
		}
	}

	if(ptrStartPress == IntPtr.Zero) {
		throw new Exception("Failed to scan for pointers");
	}

	print("ptrStartPress = " + ptrStartPress.ToString("X4"));

	ptrStartPress = game.ReadValue<IntPtr>(ptrStartPress);

	print("Scanned all pointers");

	vars.watchers = new MemoryWatcherList {
		new MemoryWatcher<byte>(ptrStartPress) { Name = "StartPress" }
	};
}

update {
	vars.watchers.UpdateAll(game);
}

start {
	bool StartPress = vars.watchers["StartPress"].Changed && vars.watchers["StartPress"].Current == 1;
	return StartPress;
}
