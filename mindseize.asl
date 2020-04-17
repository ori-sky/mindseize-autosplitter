state("MindSeize") {}

startup {
	vars.target = new SigScanTarget(0, "37 13 37 13 37 13 37 13");
}

init {
	print("Scanning for pointers");

	IntPtr ptr = IntPtr.Zero;

	foreach(var page in game.MemoryPages()) {
		var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);

		if(ptr == IntPtr.Zero) {
			ptr = scanner.Scan(vars.target);
		}

		if(ptr != IntPtr.Zero) {
			break;
		}
	}

	if(ptr == IntPtr.Zero) {
		throw new Exception("Failed to scan for pointers");
	}

	print("ptr = " + ptr.ToString("X4"));

	//ptr = game.ReadValue<IntPtr>(ptr);
	IntPtr ptrInGame = IntPtr.Add(ptr, 0x1c);

	print("Scanned all pointers");

	vars.watchers = new MemoryWatcherList {
		new MemoryWatcher<byte>(ptrInGame) { Name = "InGame" }
	};
}

update {
	vars.watchers.UpdateAll(game);
}

start {
	bool InGame = vars.watchers["InGame"].Changed && vars.watchers["InGame"].Current == 1;
	return InGame;
}
